# This handles the routing calls and will eventually become only one way we get
# routing information
class window.beats.GoogleMapRouteHandler
  $a = window.beats
  queue = []
  rate = 100
  
  constructor: (@links) ->
    @directionsService = new google.maps.DirectionsService()
    @_requestLinks(@links.length - 1)
  
  # recursive method used to grab the Google route for every link
  # indexOfLink starts at the end of the link list and is decreased 
  # on each recursive call. If geometry exists we just draw the link
  _requestLinks: (indexOfLink) ->
    if indexOfLink > -1
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
      begin =  link.get('begin').get('node')
      end = link.get('end').get('node')
      #Create DirectionsRequest using DRIVING directions.
      link.request = {
       origin: $a.Util.getLatLng(begin),
       destination: $a.Util.getLatLng(end),
       travelMode: google.maps.TravelMode.DRIVING,
      }
      link
  
  # check to see if the geometry exists before cycling to get route
  _geomDoesNotExist: (link) ->
     geom = link.get('shape')?.get('text')
     return geom is undefined or geom is null
  
  # _directionsRequest makes the actual route request to google. if we 
  # recieve any error, this method will wait 3 seconds and then 
  # call itself again with the same request object. I removed
  # monitoring the the number of attempts and just keep trying until we are 
  # done. If get a route, this method calls _drawLink to render the link on the 
  # page
  _directionsRequest: (link) ->
      @directionsService.route(link.request, (response, status) =>
        if (status == google.maps.DirectionsStatus.OK)
          rte = response.routes[0]
          if rte.warnings.length > 0
            msg = "#{WARNING_MSG} #{rte.warnings}"
            $a.broker.trigger('app:show_message:info', msg)
          if link?
            link.legs = rte.legs 
            $a.broker.trigger('map:draw_link', link)
            if(rate > 200)
              rate -= 100
            setTimeout (() =>  @_requestLinks(link.index - 1)), rate
        else
          rate = 1000
          setTimeout (() =>  @_requestLinks(link.index)), rate
      )
  
  # this makes a single request to a link and triggers its drawing on the map
  _directionsRequestOneLink: (link) ->
      @directionsService.route(link.request, (response, status) =>
        if (status == google.maps.DirectionsStatus.OK)
          rte = response.routes[0]
          if rte.warnings.length > 0
            msg = "#{WARNING_MSG} #{rte.warnings}"
            $a.broker.trigger('app:show_message:info', msg)
          link.legs = rte.legs
          $a.broker.trigger('map:draw_link', link)
        else
          setTimeout (() =>  @requestLink(link)), 1000
      )
  
  #checks to see if we are over the google query limit
  _isOverQuery: (status) ->
    status == google.maps.DirectionsStatus.OVER_QUERY_LIMIT
  