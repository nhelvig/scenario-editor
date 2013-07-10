# This handles the routing calls and will eventually become only one way we get
# routing information
class window.beats.GoogleMapRouteHandler
  $a = window.beats
  queue = []
  rate = 100
  
  constructor: (@links) ->
    @stop = false
    $a.broker.on('map:clear_map', @stopDrawing, @)
    @directionsService = new google.maps.DirectionsService()
    @_requestLinks(@links.length - 1)
  
  # this sets a flag that gets flipped when clear:map is triggered during the
  # link request process
  stopDrawing: ->
    @stop = true
     
  # recursive method used to grab the Google route for every link
  # indexOfLink starts at the end of the link list and is decreased 
  # on each recursive call. If geometry exists we just draw the link
  _requestLinks: (indexOfLink) ->
    if indexOfLink > -1  and !@stop
      link = @links[indexOfLink]
      if(@_geomDoesNotExist(link))
        link.index = indexOfLink
        @setUpLink(link)
        @_directionsRequest(link)
        if(indexOfLink % 10 == 0)
          $a.broker.trigger('app:show_message:info', "Loading ... #{indexOfLink} more" )
        else if(indexOfLink == 0)
          $a.broker.trigger('app:show_message:success', 'Loaded map successfully')
      else
        $a.broker.trigger('map:draw_link', link)
        @_requestLinks(indexOfLink - 1)
  
  # grab the Google route for one link -- happens on add link and move node
  # events
  requestLink: (link) ->
    @setUpLink(link)
    @_directionsRequestOneLink(link)
    $a.broker.trigger('app:show_message:success', 'Loaded map successfully')
  
  # setUpLink takes the link that may need geometry and a flag indicating 
  # whether or not we want to force new geometry to be querried. This happens
  # when an existing node is dragged or a node is added.
  setUpLink: (link) ->
      begin =  link.begin_node()
      end = link.end_node()
      #Create DirectionsRequest using DRIVING directions.
      link.request = {
       origin: $a.Util.getLatLng(begin),
       destination: $a.Util.getLatLng(end),
       travelMode: google.maps.TravelMode.DRIVING,
      }
      link
  
  # check to see if the geometry exists before cycling to get route
  # returns true if link geom and position are not set
  _geomDoesNotExist: (link) ->
     g = link.get('shape')?.get('text')
     pos = link.position()
     # if link position is null, undefined or has a zero length and
     # the link shape string is null or undefined return true
     return (pos is undefined or pos is null or pos?.length is 0) and (g is undefined or g is null)
  
  # _directionsRequest makes the actual route request to google. if we 
  # recieve any error, this method will wait 3 seconds and then 
  # call itself again with the same request object. I removed
  # monitoring the the number of attempts and just keep trying until we are 
  # done. If get a route, this method calls _drawLink to render the link on the 
  # page
  _directionsRequest: (link) ->
      @directionsService.route(link.request, (response, status) =>
        if (status == google.maps.DirectionsStatus.OK)
            @_handleRouteInfo(response, link)
            $a.broker.trigger('map:draw_link', link) if !@stop
            if(rate > 200)
              rate -= 100
            setTimeout (() =>  @_requestLinks(link.index - 1)), rate
        else
          rate = 1000
          setTimeout (() =>  @_requestLinks(link.index)), rate
      )

  _duplicatePoint: (point, arrayOfPoints) ->
    duplicate = false
    for pt in arrayOfPoints
      if pt.equals(point)
        duplicate = true
    duplicate

  _getPoints: (rte) ->
    smPath = []
    for leg in rte.legs
      for step in leg.steps
        for pt in step.path
          if !@_duplicatePoint(pt,smPath)
            smPath.push pt
    smPath

  # this method is called from LinkListView on an existing link whose
  # endpoints have been changed
  setNewPath: (link) ->
    @setUpLink(link)
    @directionsService.route(link.request, (response, status) =>
      if (status == google.maps.DirectionsStatus.OK)
        @_handleRouteInfo(response, link)
        link.poly.setPath(link.legs)
        link.view._saveLinkLength()
      else
        msg = "Problem drawing new path; re-position node again."
        $a.broker.trigger('app:show_message:error', msg)
    )

  # this makes a single request to a link and triggers its drawing on the map
  _directionsRequestOneLink: (link) ->
      @directionsService.route(link.request, (response, status) =>
        if (status == google.maps.DirectionsStatus.OK)
          @_handleRouteInfo(response, link)
          $a.broker.trigger('map:draw_link', link)
        else
          setTimeout (() =>  @requestLink(link)), 1000
      )
    
  # helper method for directions responses
  _handleRouteInfo: (response, link) ->
    rte = response.routes[0]
    if rte.warnings.length > 0
      msg = "#{WARNING_MSG} #{rte.warnings}"
      $a.broker.trigger('app:show_message:info', msg)
    smPath = @_getPoints(rte)
    if link?
      link.legs = smPath
      link.set_position(@_convertLatLngToPoints(smPath))

  #checks to see if we are over the google query limit
  _isOverQuery: (status) ->
    status == google.maps.DirectionsStatus.OVER_QUERY_LIMIT
    
  _convertLatLngToPoints: (pts) ->
    moPoints = []
    for pt in pts
      p = new $a.Point()
      p.set_lat(pt.lat())
      p.set_lng(pt.lng())
      moPoints.push(p)
    moPoints