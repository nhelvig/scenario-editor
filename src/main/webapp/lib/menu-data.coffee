$a = window.beats

# The names of all the parent tree elements of the scenario. It is used in
# MapNetworkView's _treeView method
$a.main_tree_elements = [
  'Initial Density Profiles', 'Network List', 'Controllers', 'Demand Profiles',
  'Events', 'Fundamental Diagram Profiles', 'OD Demand Profiles',
  'Network Connections','Downstream Boundary Profiles','Split Ratio Profiles',
  'Sensors','Signals'
]

ETHAN_VIZ_MEASURE_URI = "http://via.path.berkeley.edu/~ethan/vis_chart.php"
noconfig = -> alert('Not Configured')

# The menu items and their events for the main navigation bar
$a.nav_bar_menu_items =
  File:
    'New Scenario': (-> $a.broker.trigger("app:new_scenario"))
    'Open Local Scenario': (-> $a.broker.trigger("app:open_scenario"))
    'Save Local Scenario': (->  $a.broker.trigger("app:save_scenario"))
    'Close Local Scenario': (-> $a.broker.trigger("map:clear_map"))
  DB:
    'Log In': (-> $a.broker.trigger("app:login"))
    'Open Scenario': (-> $a.broker.trigger("app:open_scenario_browser_db"))
    'Open Network': (-> $a.broker.trigger("app:open_network_browser_db"))
    'Save New Network': (-> $a.broker.trigger("app:import_network_db"))
    'Save Network': (-> $a.broker.trigger("app:save_network_db"))
  Windows:
    'Node Browser': (-> $a.BrowserView.start('node'))
    'Link Browser': (-> $a.BrowserView.start('link'))
    'Path Browser': noconfig
    'Event Browser': noconfig
    'Controller Browser': (-> $a.BrowserView.start('controller'))
    'Sensor Browser': (-> $a.BrowserView.start('sensor'))
    'Network Properties': (-> $a.broker.trigger("map:open_network_editor"))
  Tools:
    'Import PeMS data': noconfig
    Calibrate: noconfig
    Simulate: noconfig
    'Visualize Measurements': (-> window.open(ETHAN_VIZ_MEASURE_URI))
  Help:
    About: noconfig
    Help: noconfig
    Version: noconfig
    Identity: noconfig
    Contact: noconfig
    Legal: noconfig

context_menu_item = (label, event) ->
  className: 'context_menu_item',
  label: label,
  event: event

# Main window context menu
$a.main_context_menu = [
  context_menu_item 'Zoom in', (-> $a.map.setZoom $a.map.getZoom()+1)
  context_menu_item 'Zoom out', (-> $a.map.setZoom $a.map.getZoom()-1)
  {className:'context_menu_separator'}
  context_menu_item 'Center map here', (-> $a.map.panTo $a.contextMenu.position)
  {className:'context_menu_separator'}
  context_menu_item 'Add Node here', 
                    ( -> $a.broker.trigger("nodes:add", $a.contextMenu.position))
  context_menu_item 'Add Sensor here',
                    ((e) -> $a.broker.trigger("sensors:add", $a.contextMenu.position))
  context_menu_item 'Add Controller here',
                    ((e) -> $a.broker.trigger("controllers:add", $a.contextMenu.position))
  context_menu_item 'Add Event here',
                    ((e) -> $a.broker.trigger("events:add", $a.contextMenu.position))
]

$a.node_selected = [
  context_menu_item 'Add Node and Link here', 
                    ( -> $a.nodeList.trigger("nodes:add_link", $a.contextMenu.position))
  context_menu_item 'Add Origin here',
                    (-> $a.nodeList.trigger("nodes:add_origin", $a.contextMenu.position))
  context_menu_item 'Add Destination here',
                    (-> $a.nodeList.trigger("nodes:add_dest", $a.contextMenu.position))
]

# Addition to context menu, to be added when a node is selected and another
# node is click on
$a.node_selected_node_clicked = [
  context_menu_item 'Add link to this node', 
                    ( (e) -> $a.nodeList.trigger("nodes:add_connecting_link_dest", e.currentTarget.id))
  context_menu_item 'Add link from this node', 
                    ( (e) -> $a.nodeList.trigger("nodes:add_connecting_link_orig", e.currentTarget.id))
]

# Link Context Menu
$a.link_context_menu = [
  context_menu_item 'Edit this link',
      ((e) -> $a.linkList.trigger('links:open_editor', e.currentTarget.id))
  context_menu_item  'Select Link and its Nodes',
      ((e) -> $a.linkList.trigger('links:select_neighbors', e.currentTarget.id))
  context_menu_item 'Remove this link',
      ((e) -> $a.broker.trigger("links:remove", e.currentTarget.id))
  {className:'context_menu_separator'}
  context_menu_item 'Add sensor to this link',
      ((e) -> $a.linkList.trigger("links:add_sensor", e.currentTarget.id))
  context_menu_item 'Add controller to this link',
      ((e) -> $a.linkList.trigger("links:add_controller", e.currentTarget.id))
  context_menu_item 'Add event to this link',
      ((e) -> $a.linkList.trigger("links:add_event", e.currentTarget.id))
  {className:'context_menu_separator'}
  context_menu_item  'Clear Selection',
      ((e) -> $a.linkList.trigger('links:deselect_link', e.currentTarget.id))
  {className:'context_menu_separator'}
  context_menu_item  'Split link, add node here',
      ((e) -> $a.linkList.trigger("links:split_add_node", e.currentTarget.id, $a.contextMenu.position))
  context_menu_item  'Split link with nodes',
      ((e) -> $a.linkList.trigger("links:split", e.currentTarget.id, 2))
  context_menu_item  'Duplicate link',
      ((e) -> $a.linkList.trigger("links:duplicate", e.currentTarget.id))

]

$a.link_context_menu_demand_item = [
  context_menu_item  'View Demands'
      ((e) -> $a.linkList.trigger('links:view_demands', e.currentTarget.id))
]
# Sensor Context Menu
$a.sensor_context_menu = [
  context_menu_item 'Edit this sensor',
                    ((e) -> $a.broker.trigger("map:open_editor:#{e.currentTarget.id}"))
  context_menu_item 'Remove this sensor',
                    ((e) -> $a.sensorList.trigger("sensors:remove", e.currentTarget.id))
  context_menu_item 'Select sensor link',
                    ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}"))
  context_menu_item 'Clear Selection',
                    ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}"))
]

# Controller Context Menu
$a.controller_context_menu = [
  context_menu_item 'Edit this controller', noconfig
  context_menu_item 'Remove this controller',
                    ((e) -> $a.controllerSet.trigger("controllers:remove", e.currentTarget.id))
  context_menu_item 'Select controller link',
                    ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}"))
  context_menu_item 'Clear Selection',
                    ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}"))
]

# Event Context Menu
$a.event_context_menu = [
  context_menu_item 'Edit this event', noconfig
  context_menu_item 'Remove this event',
                    ((e) -> $a.eventSet.trigger("events:remove", e.currentTarget.id))
  context_menu_item 'Select event link',
                    ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}"))
  context_menu_item 'Clear Selection',
                    ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}"))
]

# Signal Context Menu
$a.signal_context_menu = [
  context_menu_item 'Select signal node',
                    ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}"))
  context_menu_item 'Clear Selection',
                    ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}"))
]

# Node Context Menu
$a.node_context_menu = [
  context_menu_item 'Edit this node',
                    ((e) -> $a.broker.trigger("map:open_editor:#{e.currentTarget.id}"))
  context_menu_item 'Remove this node',
                    ((e) -> $a.broker.trigger("nodes:remove", e.currentTarget.id))
  context_menu_item 'Remove this node and its links',
                    ((e) -> $a.broker.trigger("nodes:remove_and_links", e.currentTarget.id))
  context_menu_item 'Remove this node and join links',
                    ((e) -> $a.broker.trigger("nodes:remove_and_join", e.currentTarget.id))
  context_menu_item 'Select node and its links',
                    ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}"))
  context_menu_item 'Select Outgoing links',
                    ((e) -> $a.broker.trigger("map:select_neighbors_out:#{e.currentTarget.id}"))
  context_menu_item 'Select Incoming links',
                    ((e) -> $a.broker.trigger("map:select_neighbors_in:#{e.currentTarget.id}"))
  context_menu_item 'Clear Selection',
                    ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}"))
]

# Layers Menu
$a.layers_node_type_list = [
  {
    label: 'Freeway'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_freeway"
    triggerHide: "map:nodes:hide_freeway" }
  {
    label: 'Highway'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_highway"
    triggerHide: "map:nodes:hide_higway"  }
  {
    label: 'Signalized Intersections'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_signalized_intersection"
    triggerHide: "map:nodes:hide_signalized_intersection"  }
  {
    label: 'Simple'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_simple"
    triggerHide: "map:nodes:hide_simple" }
  {
    label: 'Stop Intersections'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_stop_intersection"
    triggerHide: "map:nodes:hide_stop_intersection"  }
  {
    label: 'Terminals'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_terminal"
    triggerHide: "map:nodes:hide_terminal"  }
  {
    label: 'Other'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_other"
    triggerHide: "map:nodes:hide_other"  }
]

$a.layers_link_type_list = [
  {
    label: 'Elec. toll coll. lanes'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    collection: '$a.linkList'
    param: 'electric_toll'  }
  {
    label: 'Freeway mainlines'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:show_link_layer"
    collection: '$a.linkList'
    param: 'freeway' }
  {
    label: 'Highway mainlines'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:show_link_layer"
    collection: '$a.linkList'
    param: 'highway'  }
  {
    label: 'Heavy vehicle lanes'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:show_link_layer"
    collection: '$a.linkList'
    param: 'heavy_vehicle' }
  {
    label: 'HOV lanes'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:show_link_layer"
    collection: '$a.linkList'
    param: 'hov' }
  {
    label: 'HOT lanes'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:show_link_layer"
    collection: '$a.linkList'
    param: 'hot'  }
  {
    label: 'Interconnects'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:show_link_layer"
    collection: '$a.linkList'
    param: 'freeway_connector'}
  {
    label: 'Intersection Approach'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:show_link_layer"
    collection: '$a.linkList'
    param: 'intersection_approach' }
  {
    label: 'On-ramps'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:show_link_layer"
    collection: '$a.linkList'
    param: 'onramp'  }
  {
    label: 'Off-ramps'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:show_link_layer"
    collection: '$a.linkList'
    param: 'offramp'  }
  {
    label: 'Streets'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:show_link_layer"
    collection: '$a.linkList'
    param: 'streets'  }
]

$a.layers_menu = [
  {
    label: 'Show all nodes'
    event: ((e) -> $a.broker.trigger('map:show_node_layer')) }
  {
    label: 'Hide all nodes'
    event: ((e) -> $a.broker.trigger('map:hide_node_layer')) }
  {
    label: 'Nodes'
    className: 'dropdown submenu'
    link: 'nodeTypeList'
    href: '#nodeTypeList'
    collection: '$a.nodeList'
    items: $a.layers_node_type_list }
  { className: 'divider' }
  {
    label: 'Show all links'
    event: ((e) -> $a.linkList.trigger('links:show_link_layer')) }
  {
    label: 'Hide all links'
    event: ((e) -> $a.linkList.trigger('links:hide_link_layer')) }
  {
    label: 'Links'
    className: 'dropdown submenu'
    href: '#linkTypeList'
    link: 'linkTypeList'
    items: $a.layers_link_type_list }
  { className: 'divider' }
  {
    label: 'Events'
    event: 'toggleVisible'
    triggerShow: "map:show_event_layer"
    triggerHide: "map:hide_event_layer"}
  {
    label: 'Controllers'
    event: 'toggleVisible'
    triggerShow: "map:show_controller_layer"
    triggerHide: "map:hide_controller_layer" }
  {
    label: 'Sensors'
    event: 'toggleVisible'
    triggerShow: "map:show_sensor_layer"
    triggerHide: "map:hide_sensor_layer" }
  {
    label: 'Demands'
    event: 'toggleVisible'
    triggerShow: "map:show_demand_layer"
    triggerHide: "map:hide_demand_layer" }
  { className: 'divider' }
  {
    label: 'Satelite Tiles'
    event: 'toggleMapTypeVisible'
    triggerShow: "map:show_satellite"
    triggerHide: "map:hide_satellite"
    initiallyChecked: false}
]