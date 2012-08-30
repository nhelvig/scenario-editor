# The main class managing the view of the network on the map.
# A network consists of all the links, nodes, sensors, controllers
# events, and signals along a route. It uses the google api Directions
# Service to determine the route by passing the service
# a set of latitude and longitudes along the route(waypoints). 
#
# The class also creates and then triggers the rendering of the treeView 
# of the scenario elements.
class window.sirius.MapNetworkView extends Backbone.View
  $a = window.sirius
  WARNING_MSG = 'Directions API Warning(s):'
  ERROR_MSG = 'Directions API Error: Could not render link :'
    
  initialize: (@scenario) ->
    @networks =  @scenario.get('networklist').get('network')
    _.each(@networks, (network) => @_drawNetwork(network))
    
    @_drawScenarioItems()
    
    # This class creates the tree view of all the elements of the scenario
    new $a.TreeView({ scenario: @scenario, attach: "#right_tree"})
    @render()
  
  render: ->
    $a.broker.trigger('map:init')
    $a.broker.trigger('app:main_tree')
    @
  
  _drawScenarioItems: () ->
    if @scenario.get('sensorlist')?
      @_drawSensors @scenario.get('sensorlist').get('sensor')
    if @scenario.get('controllerset')?
      @_drawControllers @scenario.get('controllerset').get('controller')
    if @scenario.get('eventset')?
      @_drawEvents  @scenario.get('eventset').get('event')
    if @scenario.get('signallist')?
      @_drawSignals @scenario.get('signallist').get('signal')
    
  # _drawNetwork is organizing function calling all the methods that
  # instantiate the various elements of the network
  _drawNetwork: (network)->
    $a.map.setCenter($a.Util.getLatLng(network))
    @_drawRoute(network)
    if network.get('nodelist')?
      @_drawNodes network.get('nodelist').get('node'), network

  # _drawRoute uses the Google Direction's api to get the data used to render 
  # the route. The network reference is the network you are drawing now
  _drawRoute: (network)->
    @directionsService = new google.maps.DirectionsService()
    @_requestLink(network.get('linklist').get('link').length - 1, network)

  # recursive method used to grab the Google route for every link
  # indexOfLink starts at the end of the link list and is decreased 
  # on each recrusive call
  _requestLink: (indexOfLink, network) ->
    if indexOfLink > -1
      link = network.get('linklist').get('link')[indexOfLink]
      begin =  link.get('begin').get('node')
      end = link.get('end').get('node')
      #Create DirectionsRequest using DRIVING directions.
      request = {
       origin: $a.Util.getLatLng(begin),
       destination: $a.Util.getLatLng(end),
       travelMode: google.maps.TravelMode.DRIVING,
      }
      # request the route from the directions service.
      # The parameters are the request object for Google API
      # as well as 0, indicating the number of attempts -- read
      # below
      params = {
        request: request
        linkModel: link
        network: network
        attempts: 0
      }
      @_directionsRequest(params)
      @_requestLink(indexOfLink - 1, network)
    else
      $a.broker.trigger('app:show_message:success', 'Loaded map successfully')
    
  
  # _directionsRequest makes the actual route request to google. if we 
  # recieve OVER_QUERY_LIMIT error, this method will wait 3 seconds and then 
  # call itself again with the same request object but montior the number of 
  # attempts. We attempt to get the route for the link 3 times and then give 
  # up. If get a route, this method calls _drawLink to render the link on the 
  # page
  _directionsRequest: (params) ->
    @directionsService.route(params.request, (response, status) =>
      if (status == google.maps.DirectionsStatus.OK)
        rte = response.routes[0]
        if rte.warnings.length > 0
          msg = "#{WARNING_MSG} #{rte.warnings}"
          $a.broker.trigger('app:show_message:info', msg)
        @_drawLink params, rte.legs
      else if @_isOverQuery(status) and params.attempts < 3
        setTimeout (() => @_directionsRequest(params)), 3000
      else #TODO configure into html
        $a.broker.trigger('app:show_message:error', "#{ERROR_MSG} #{status}")
    )

  #checks to see if we are over the google query limit
  _isOverQuery: () ->
    status == google.maps.DirectionsStatus.OVER_QUERY_LIMIT
  
  # These methods instantiate each elements view instance in the map
  _drawLink: (params, legs) ->
    new $a.MapLinkView(params.linkModel, params.network, legs)

  _drawNodes: (nodes, network) ->
    _.each(nodes, (i) ->  new $a.MapNodeView(i, network))

  _drawSensors: (sensors) ->
    _.each(sensors, (i) ->  new $a.MapSensorView(i))

  _drawEvents: (events) ->
    _.each(events, (i) ->  new $a.MapEventView(i))

  _drawControllers: (controllers) ->
    _.each(controllers, (i) -> new $a.MapControllerView(i))

  _drawSignals: (signals) ->
    _.each(signals, (i) ->  new $a.MapSignalView(i) if $a.Util.getLatLng(i)?)