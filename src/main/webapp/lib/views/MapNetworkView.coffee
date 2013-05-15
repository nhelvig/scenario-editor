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
    
  initialize: (@scenario) ->
    @networks =  @scenario.networks()
    @_initializeCollections()
    _.each(@networks, (network) => @_drawNetwork(network))
    @_centerMap() if @networks[0].position()?
    @_drawScenarioItems()
    @_layersMenu()
    
    # This class creates the tree view of all the elements of the scenario
    $a.tree = new $a.TreeView({ scenario: @scenario, attach: "#tree_view"})
    @render()
  
  render: ->
    $a.broker.trigger('map:init')
    $a.broker.trigger('app:main_tree')
    @
  
  _initializeCollections: () ->
    $a.nodeList = new $a.NodeListCollection($a.models.nodes())
    $a.linkList = new $a.LinkListCollection($a.models.links(), @network)
    $a.sensorList = new $a.SensorListCollection($a.models.sensors())
    $a.controllerSet = new $a.ControllerSetCollection($a.models.controllers())
    $a.eventSet = new $a.EventSetCollection($a.models.events())
  
  # This creates the layers menu bar
  _layersMenu: () ->
    attrs = {
      className: 'dropdown-menu bottom-up'
      id: 'l_list'
      parentId: 'lh'
      menuItems: $a.layers_menu
    }
    @lmenu = new $a.LayersMenuView(attrs)
  
  #center the map based on network position
  _centerMap: () ->
    pt = @networks[0].position().points()[0]
    $a.map.setCenter(new google.maps.LatLng(pt.lat(), pt.lng()))
    
  _drawScenarioItems: () ->
    @_drawSensors()
    @_drawControllers()
    @_drawEvents()
    #@_drawSignals()
    
  # _drawNetwork is organizing function calling all the methods that
  # instantiate the various elements of the network
  _drawNetwork: (network)->
    $a.map.setCenter($a.Util.getLatLng(network))
    @_drawLinks(network)
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