# The main class managing the view of the network on the map.
# A network consists of all the links, nodes, sensors, controllers
# events, and signals along a route. It uses the google api Directions
# Service to determine the route by passing the service
# a set of latitude and longitudes along the route(waypoints). 
#
# The class also creates and then triggers the rendering of the treeView 
# of the scenario elements.
class window.beats.MapNetworkView extends Backbone.View
  $a = window.beats
  WARNING_MSG = 'Directions API Warning(s):'
  ERROR_MSG = 'Directions API Error: Could not render link :'
  NETWORK_EDIT_MSG : 'Network Editing Mode'
  SCENARIO_EDIT_MSG : 'Scenario Editing Mode'
  ROUTE_EDIT_MSG : 'Route Editing Mode'
  VIEW_ONLY_MSG : 'View Only Mode'
  
  broker_events: {
    'map:open_view_mode' : 'viewMode'
    'map:open_network_mode' : 'networkMode'
    'map:open_scenario_mode' : 'scenarioMode'
    'map:open_route_mode' : 'routeMode'
    'map:open_network_editor' : '_editor'
    'map:open_scenario_editor' : '_scenarioEditor'
    'map:open_route_editor' : '_routeEditor'
    'map:clear_map' : '_tearDownEvents'
  }
  
  initialize: (@scenario) ->
    @networks =  @scenario.networks()
    @_initializeCollections()
    # if there are networks in the scenario draw them
    _.each(@networks, (network) => @_drawNetwork(network))
    @_centerMap() if @networks[0].position()?
    @_drawScenarioItems()
    @_layersMenu()
    @_modeMenu() 
    # handle network browser event
    $a.Util.publishEvents($a.broker, @broker_events, @)

    # This class creates the tree view of all the elements of the scenario
    $a.tree = new $a.TreeView({ scenario: @scenario, attach: "#tree_view"})
    @render()
  
  render: ->
    $a.broker.trigger('map:init')
    $a.broker.trigger('app:main_tree')
    $a.broker.trigger('map:open_scenario_mode')
    @
  
  viewMode: ->
    $a.broker.trigger('app:display_message:info', @VIEW_ONLY_MSG)
  
  networkMode: ->
    $a.broker.trigger('app:display_message:info', @NETWORK_EDIT_MSG)

  scenarioMode: ->
    $a.broker.trigger('app:display_message:info', @SCENARIO_EDIT_MSG)
  
  routeMode: ->
    $a.broker.trigger('app:display_message:info', @ROUTE_EDIT_MSG)

  _tearDownEvents: ->
    # Commenting out since this ends up preventing the network properties editor from being lauched
    # after the map has been cleared (ie. New Scenario selected)
    $a.Util.unpublishEvents($a.broker, @broker_events, @)
  
  _initializeCollections: () ->
    $a.nodeList = new $a.NodeListCollection($a.models.nodes())
    $a.linkList = new $a.LinkListCollection($a.models.links())
    $a.sensorList = new $a.SensorListCollection($a.models.sensors())
    $a.controllerSet = new $a.ControllerSetCollection($a.models.controllers())
    $a.eventSet = new $a.EventSetCollection($a.models.events())
  
  # This creates the layers menu bar
  _layersMenu: ->
    attrs = {
      className: 'dropdown-menu bottom-up'
      id: 'l_list'
      parentId: 'lh'
      menuItems: $a.layers_menu
    }
    @lmenu = new $a.LayersMenuView(attrs)
  
  # This creates the layers menu bar
  _modeMenu: ->
    attrs = {
      className: 'dropdown-menu bottom-up'
      id: 'm_list'
      parentId: 'mh'
      menuItems: $a.mode_menu
    }
    @mmenu = new $a.ModeMenuView(attrs)

  #center the map based on network position
  _centerMap: () ->
    pts = $a.Util.convertPointsToGoogleLatLng(@networks[0].position().points())

    # if we have 1 display position defined, use it as the center
    if length of pts and pts.length = 1
      $a.map.setCenter(new google.maps.LatLng(pts[0].lat(), pts[0].lng()))
    # if we have more two or more points defined, take midpoint of them
    else if length of pts and pts.length > 1
      mid = google.maps.geometry.spherical.interpolate(pts[0], pts[1], 0.5)
      $a.map.setCenter(new google.maps.LatLng(mid.lat(), mid.lng()))
    # otherwise we display position is not given and output error message
    else
      $a.broker.trigger('app:show_message:info', "Error, No Network Display Position Set.")

  _drawScenarioItems: () ->
    @_drawSensors()
    @_drawControllers()
    @_drawEvents()
    #@_drawSignals()
    
  # _drawNetwork is organizing function calling all the methods that
  # instantiate the various elements of the network
  _drawNetwork: (network)->
    $a.map.setZoom($a.AppView.INITIAL_ZOOM_LEVEL)
    # if there are network links, draw them
    if network.links()?
      @_drawLinks(network)
    # if there are network nodes, draw them
    if network.nodes()?
      @_drawNodes network.nodes(), network
  
  # These methods instantiate each elements view instance in the map
  _drawLinks: (network) ->
    $a.linkListView = new $a.LinkListView($a.linkList, network)
    
  _drawNodes: (nodes, network) ->
    $a.nodeListView = new $a.NodeListView($a.nodeList, network)

  _drawSensors: ->
    $a.sensorListView = new $a.SensorListView($a.sensorList)

  _drawEvents: ->
    $a.eventListView = new $a.EventSetView($a.eventSet)

  _drawControllers: ->
    $a.controllerSetView = new $a.ControllerSetView($a.controllerSet)

  _drawSignals: (signals) ->
    _.each(signals, (i) ->  new $a.MapSignalView(i) if $a.Util.getLatLng(i)?)

  _editor: (msg) ->
    env = new $a.EditorNetworkView(elem: 'network', models: @networks, message: msg, width: 300)
    $('body').append(env.el)
    env.render()
    $(env.el).dialog('open')
  
  _scenarioEditor: (msg) ->
    esv = new $a.EditorScenarioView(elem: 'scenario', models: [@scenario], message: msg, width: 300)
    $('body').append(esv.el)
    esv.render()
    $(esv.el).dialog('open')
  
  _routeEditor: (msg) ->
    @route = new $a.Route() if !@route?
    esv = new $a.EditorRouteView(elem: 'route', models: [@route], message: msg, width: 300)
    $('body').append(esv.el)
    esv.render()
    $(esv.el).dialog('open')