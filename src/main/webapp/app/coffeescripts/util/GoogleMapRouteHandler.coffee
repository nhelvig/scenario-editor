# This handles the routing calls and will eventually become only one way we get
# routing information
class window.sirius.GoogleMapRouteHandler
  $a = window.sirius
  
  constructor: (@links) ->
    @directionsService = new google.maps.DirectionsService()
    @_requestLink(@links.length - 1)
    
  # recursive method used to grab the Google route for every link
  # indexOfLink starts at the end of the link list and is decreased 
  # on each recursive call
  _requestLink: (indexOfLink) ->
    if indexOfLink > -1
      link = @links[indexOfLink]
      @setUpLink(link)
      @_requestLink(indexOfLink - 1)
    else
      $a.broker.trigger('app:show_message:success', 'Loaded map successfully')
  
  setUpLink: (link) ->
      begin =  link.get('begin').get('node')
      end = link.get('end').get('node')
      #Create DirectionsRequest using DRIVING directions.
      request = {
       origin: $a.Util.getLatLng(begin),
       destination: $a.Util.getLatLng(end),
       travelMode: google.maps.TravelMode.DRIVING,
      }
      
      geom = link.get('linkgeometry')
      geom = geom?.get('encodedpolyline')?.get('points')?.get('text')
      # geometry exists to query google again
      if(geom is undefined or geom is null)
        @_directionsRequest(request, link)
      link
  
  # _directionsRequest makes the actual route request to google. if we 
  # recieve any error, this method will wait 3 seconds and then 
  # call itself again with the same request object. I removed
  # monitoring the the number of attempts and just keep trying until we are 
  # done. If get a route, this method calls _drawLink to render the link on the 
  # page
  _directionsRequest: (request, link) ->
    @directionsService.route(request, (response, status) =>
      if (status == google.maps.DirectionsStatus.OK)
        rte = response.routes[0]
        if rte.warnings.length > 0
          msg = "#{WARNING_MSG} #{rte.warnings}"
          $a.broker.trigger('app:show_message:info', msg)
        link.legs = rte.legs if link?
        $a.broker.trigger('map:draw_link', link)
      else #if @_isOverQuery(status) and params.attempts < 10
        setTimeout (() => @_directionsRequest(request)), 3000
      #else #I took out any error and just keep loading
      #  $a.broker.trigger('app:show_message:error', "#{ERROR_MSG} #{status}")
    )
    
  #checks to see if we are over the google query limit
  _isOverQuery: (status) ->
    status == google.maps.DirectionsStatus.OVER_QUERY_LIMIT
  