$a = window.beats

# The names of all the parent tree elements of the scenario. It is used in
# MapNetworkView's _treeView method
$a.main_tree_elements = [
  'Initial Density Profiles', 'Network List', 'Controllers', 'Demand Profiles',
  'Events', 'Fundamental Diagram Profiles', 'OD Demand Profiles',
  'Network Connections','Downstream Boundary Profiles','Split Ratio Profiles',
  'Sensors','Signals'
]

SCENARIO = "$a.Mode.SCENARIO"
NETWORK = "$a.Mode.NETWORK"
ROUTE = "$a.Mode.ROUTE"
VIEW = "$a.Mode.VIEW"

ETHAN_VIZ_MEASURE_URI = "http://via.path.berkeley.edu/~ethan/vis_chart.php"
noconfig = -> alert('Not Configured')

# The menu items and their events for the main navigation bar
nav_bar_menu_item = (label, event, mode) ->
  label: label,
  event: event,
  mode: mode
$a.nav_bar_menu_item_disabled = {
  className: 'menu_item_disable', 
  label: 'No Events Available'
}

$a.nav_bar_menu_items =
  File: [
    nav_bar_menu_item 'New Scenario', 
        (-> $a.broker.trigger("app:new_scenario")),
        [SCENARIO]
    nav_bar_menu_item 'Open Via Scenario',
        (-> $a.broker.trigger("app:open_scenario_browser_db")),
        [SCENARIO]
    nav_bar_menu_item 'Save New Via Scenario',
        (->  $a.broker.trigger("app:import_scenario_db")),
        [SCENARIO]
    nav_bar_menu_item 'Save Via Scenario',
        (->  $a.broker.trigger("app:save_scenario_db")),
        [SCENARIO]
    nav_bar_menu_item 'Open Local Scenario',
        (-> $a.broker.trigger("app:open_scenario")),
        [SCENARIO]
    nav_bar_menu_item 'Save Local Scenario',
        (->  $a.broker.trigger("app:save_scenario")),
        [SCENARIO]
    nav_bar_menu_item 'Close Local Scenario',
        (-> $a.broker.trigger("map:clear_map")),
        [SCENARIO]
    nav_bar_menu_item 'New Network',
        (-> $a.broker.trigger("app:new_network_browser_db")),
        [NETWORK]
    nav_bar_menu_item 'Open Via Network',
        (-> $a.broker.trigger("app:open_network_browser_db")),
        [NETWORK]
    nav_bar_menu_item 'Save New Via Network',
        (-> $a.broker.trigger("app:import_network_db")),
        [NETWORK]
    nav_bar_menu_item 'Save Via Network',
        (-> $a.broker.trigger("app:save_network_db")),
        [NETWORK]
    nav_bar_menu_item 'New Route',
        (-> $a.broker.trigger("app:new_route_browser_db")),
        [ROUTE]
    nav_bar_menu_item 'Open Via Route',
        (-> $a.broker.trigger("app:open_route_browser_db")),
        [ROUTE]
    nav_bar_menu_item 'Save New Via Route',
        (-> $a.broker.trigger("app:import_route_db")),
        [ROUTE]
    nav_bar_menu_item 'Save Via Route',
        (-> $a.broker.trigger("app:save_route_db")),
        [ROUTE]
  ]
  Windows: [
    nav_bar_menu_item 'Node Browser',
        (-> $a.BrowserView.start('node')),
        [NETWORK, SCENARIO]
    nav_bar_menu_item 'Link Browser',
        (-> $a.BrowserView.start('link')),
        [NETWORK, SCENARIO]
    nav_bar_menu_item 'Path Browser',
        noconfig,
        [SCENARIO]
    nav_bar_menu_item 'Event Browser',
        noconfig,
        [SCENARIO]
    nav_bar_menu_item 'Controller Browser',
        (-> $a.BrowserView.start('controller')),
        [SCENARIO]
    nav_bar_menu_item 'Sensor Browser',
        (-> $a.BrowserView.start('sensor')),
        [SCENARIO]
    nav_bar_menu_item 'Scenario Properties',
        (-> $a.broker.trigger("map:open_scenario_editor")),
        [SCENARIO]
    nav_bar_menu_item 'Network Properties',
        (-> $a.broker.trigger("map:open_network_editor")),
        [NETWORK]
    nav_bar_menu_item 'Route Properties',
        (-> $a.broker.trigger("map:open_route_editor")),
        [ROUTE]
  ]
  Tools: [
    nav_bar_menu_item 'Import PeMS VDS Stations',
        (-> $a.broker.trigger("map:import_pems")),
        [SCENARIO]
    nav_bar_menu_item 'Calibrate',
        noconfig,
        [SCENARIO]
    nav_bar_menu_item 'Simulate',
        noconfig,
        [SCENARIO]
    nav_bar_menu_item 'Visualize Measurements',
        (-> window.open(ETHAN_VIZ_MEASURE_URI)),
        [SCENARIO]
  ]
  Help: [
    nav_bar_menu_item 'About', noconfig, null
    nav_bar_menu_item 'Help', noconfig, null
    nav_bar_menu_item 'Version', noconfig, null
    nav_bar_menu_item 'Identity', noconfig, null
    nav_bar_menu_item 'Contact', noconfig, null
    nav_bar_menu_item 'Legal', noconfig, null
  ]

$a.context_menu_item_disabled = {
  className: 'context_menu_item menu_item_disable', 
  label: 'No Events Available'
}

context_menu_item = (label, event, mode) ->
  className: 'context_menu_item',
  label: label,
  event: event,
  mode: mode

# Main window context menu
$a.main_context_menu = [
  context_menu_item 'Zoom in', 
        (-> $a.map.setZoom $a.map.getZoom()+1),
        null
  context_menu_item 'Zoom out', 
        (-> $a.map.setZoom $a.map.getZoom()-1),
        null
  {className:'context_menu_separator'}
  context_menu_item 'Center map here', 
        (-> $a.map.panTo $a.contextMenu.position),
        null
  {className:'context_menu_separator'}
  context_menu_item 'Add Node here', 
      ( -> $a.broker.trigger("nodes:add", $a.contextMenu.position)),
      NETWORK
  context_menu_item 'Add Sensor here',
      ((e) -> $a.broker.trigger("sensors:add", $a.contextMenu.position)),
      SCENARIO
  context_menu_item 'Add Controller here',
      ((e) -> $a.broker.trigger("controllers:add", $a.contextMenu.position)),
      SCENARIO
  context_menu_item 'Add Event here',
      ((e) -> $a.broker.trigger("events:add", $a.contextMenu.position)), 
      SCENARIO
]

$a.node_selected = [
  context_menu_item 'Add Node and Link here', 
      ( -> $a.nodeList.trigger("nodes:add_link", $a.contextMenu.position)),
      NETWORK
  context_menu_item 'Add Origin here',
      (-> $a.nodeList.trigger("nodes:add_origin", $a.contextMenu.position)),
      NETWORK
  context_menu_item 'Add Destination here',
      (-> $a.nodeList.trigger("nodes:add_dest", $a.contextMenu.position)),
      NETWORK
]

# Addition to context menu, to be added when a node is selected and another
# node is click on
$a.node_selected_node_clicked = [
  context_menu_item 'Add link to this node', 
      ((e) -> $a.nodeList.trigger("nodes:add_connecting_link_dest", e.currentTarget.id)),
      NETWORK
  context_menu_item 'Add link from this node', 
      ((e) -> $a.nodeList.trigger("nodes:add_connecting_link_orig", e.currentTarget.id)),
      NETWORK
]

# Link Context Menu
$a.link_context_menu = [
  context_menu_item 'Edit link scenario data',
      ((e) -> $a.linkList.trigger('links:open_editor', e.currentTarget.id)),
      SCENARIO
  context_menu_item 'Edit this link',
      ((e) -> $a.linkList.trigger('links:open_editor', e.currentTarget.id)),
      NETWORK
  context_menu_item  'Select Link and its Nodes',
      ((e) -> $a.linkList.trigger('links:select_neighbors', e.currentTarget.id)),
      NETWORK
  context_menu_item 'Remove this link',
      ((e) -> $a.broker.trigger("links:remove", e.currentTarget.id)),
      NETWORK
  {className:'context_menu_separator'}
  context_menu_item 'Add sensor to this link',
      ((e) -> $a.linkList.trigger("links:add_sensor", e.currentTarget.id)),
      SCENARIO
  context_menu_item 'Add controller to this link',
      ((e) -> $a.linkList.trigger("links:add_controller", e.currentTarget.id)),
      SCENARIO
  context_menu_item 'Add event to this link',
      ((e) -> $a.linkList.trigger("links:add_event", e.currentTarget.id)),
      SCENARIO
  {className:'context_menu_separator'}
  context_menu_item  'Clear Selection',
      ((e) -> $a.linkList.trigger('links:deselect_link', e.currentTarget.id)),
      NETWORK
  {className:'context_menu_separator'}
  context_menu_item  'Split link, add node here',
      ((e) -> $a.linkList.trigger("links:split_add_node", e.currentTarget.id, $a.contextMenu.position)),
      NETWORK
  context_menu_item  'Split link with nodes',
      ((e) -> $a.linkList.trigger("links:split", e.currentTarget.id, 2)),
      NETWORK
  context_menu_item  'Duplicate link',
      ((e) -> $a.linkList.trigger("links:duplicate", e.currentTarget.id)),
      NETWORK

]

$a.link_context_menu_demand_item = [
  context_menu_item  'View Demands'
      ((e) -> $a.linkList.trigger('links:view_demands', e.currentTarget.id)),
      SCENARIO
]
# Sensor Context Menu
$a.sensor_context_menu = [
  context_menu_item 'Edit this sensor',
      ((e) -> $a.broker.trigger("map:open_editor:#{e.currentTarget.id}")),
      SCENARIO
  context_menu_item 'Remove this sensor',
      ((e) -> $a.sensorList.trigger("sensors:remove", e.currentTarget.id)),
      SCENARIO
  context_menu_item 'Select sensor link',
      ((e) -> 
        i = e.currentTarget.id
        $a.sensorListView.trigger("sensors:selectSelfAndConnected", i)
      ),
      SCENARIO
  context_menu_item 'Clear Selection',
      ((e) -> 
        i = e.currentTarget.id
        $a.sensorListView.trigger("sensors:clearSelfAndConnected", i)
      ),
      SCENARIO
]

$a.sensor_cm_link_selected = [
  context_menu_item 'Attach to selected link',
      ((e) -> $a.sensorList.trigger("sensors:attach_to_link", e.currentTarget.id)),
      SCENARIO
]

# Controller Context Menu
$a.controller_context_menu = [
  context_menu_item 'Edit this controller', noconfig
  context_menu_item 'Remove this controller',
      ((e) -> $a.controllerSet.trigger("controllers:remove", e.currentTarget.id)),
      SCENARIO
  context_menu_item 'Select controller link',
      ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}")),
      SCENARIO
  context_menu_item 'Clear Selection',
      ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}")),
      SCENARIO
]

# Event Context Menu
$a.event_context_menu = [
  context_menu_item 'Edit this event', 
      noconfig,
      SCENARIO
  context_menu_item 'Remove this event',
      ((e) -> $a.eventSet.trigger("events:remove", e.currentTarget.id)),
      SCENARIO
  context_menu_item 'Select event link',
      ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}")),
      SCENARIO
  context_menu_item 'Clear Selection',
      ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}")),
      SCENARIO
]

# Signal Context Menu
$a.signal_context_menu = [
  context_menu_item 'Select signal node',
      ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}")),
      SCENARIO
  context_menu_item 'Clear Selection',
      ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}")),
      SCENARIO
]

# Node Context Menu
$a.node_context_menu = [
  context_menu_item 'Edit this node',
      ((e) -> $a.broker.trigger("map:open_editor:#{e.currentTarget.id}")),
      NETWORK
  context_menu_item 'Remove this node',
      ((e) -> $a.broker.trigger("nodes:remove", e.currentTarget.id)),
      NETWORK
  context_menu_item 'Remove this node and its links',
      ((e) -> $a.broker.trigger("nodes:remove_and_links", e.currentTarget.id)),
      NETWORK
  context_menu_item 'Remove this node and join links',
      ((e) -> $a.broker.trigger("nodes:remove_and_join", e.currentTarget.id)),
      NETWORK
  context_menu_item 'Select node and its links',
      ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}")),
      NETWORK
  context_menu_item 'Select Outgoing links',
      ((e) -> $a.broker.trigger("map:select_neighbors_out:#{e.currentTarget.id}")),
      NETWORK
  context_menu_item 'Select Incoming links',
      ((e) -> $a.broker.trigger("map:select_neighbors_in:#{e.currentTarget.id}")),
      NETWORK
  context_menu_item 'Clear Selection',
      ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}")),
      NETWORK
]

# Layers Menu
$a.layers_node_type_list = [
  {
    label: 'Freeway'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_freeway"
    triggerHide: "map:nodes:hide_freeway"
    collection : '$a.broker'
    nodeSubMenu: true }
  {
    label: 'Highway'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_highway"
    triggerHide: "map:nodes:hide_higway"
    collection : '$a.broker'
    nodeSubMenu: true  }
  {
    label: 'Signalized Intersections'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_signalized_intersection"
    triggerHide: "map:nodes:hide_signalized_intersection"
    collection : '$a.broker'
    nodeSubMenu: true  }
  {
    label: 'Simple'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_simple"
    triggerHide: "map:nodes:hide_simple"
    collection : '$a.broker'
    nodeSubMenu: true }
  {
    label: 'Stop Intersections'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_stop_intersection"
    triggerHide: "map:nodes:hide_stop_intersection"
    collection : '$a.broker'
    nodeSubMenu: true  }
  {
    label: 'Terminals'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_terminal"
    triggerHide: "map:nodes:hide_terminal"
    collection : '$a.broker'
    nodeSubMenu: true  }
  {
    label: 'Other'
    event: 'toggleVisible'
    triggerShow: "map:nodes:show_other"
    triggerHide: "map:nodes:hide_other"
    collection : '$a.broker'
    nodeSubMenu: true}
]

$a.layers_link_type_list = [
  {
    label: 'Elec. toll coll. lanes'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    collection: '$a.linkList'
    param: 'electric_toll'
    linkSubMenu: true}
  {
    label: 'Freeway mainlines'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    collection: '$a.linkList'
    param: 'freeway'
    linkSubMenu: true }
  {
    label: 'Highway mainlines'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    collection: '$a.linkList'
    param: 'highway'
    linkSubMenu: true  }
  {
    label: 'Heavy vehicle lanes'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    collection: '$a.linkList'
    param: 'heavy_vehicle'
    linkSubMenu: true }
  {
    label: 'HOV lanes'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    collection: '$a.linkList'
    param: 'hov'
    linkSubMenu: true }
  {
    label: 'HOT lanes'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    collection: '$a.linkList'
    param: 'hot'
    linkSubMenu: true  }
  {
    label: 'Interconnects'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    collection: '$a.linkList'
    param: 'freeway_connector'
    linkSubMenu: true }
  {
    label: 'Intersection Approach'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    collection: '$a.linkList'
    param: 'intersection_approach'
    linkSubMenu: true }
  {
    label: 'On-ramps'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    collection: '$a.linkList'
    param: 'onramp'
    linkSubMenu: true }
  {
    label: 'Off-ramps'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    collection: '$a.linkList'
    param: 'offramp'
    linkSubMenu: true  }
  {
    label: 'Streets'
    event: 'toggleVisible'
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    collection: '$a.linkList'
    param: 'streets'
    linkSubMenu: true  }
]

$a.layers_menu = [
  {
    label: 'Show all nodes'
    event: 'toggleVisible'
    collection : '$a.broker' 
    triggerShow: 'map:show_node_layer'
    triggerHide: 'map:hide_node_layer'
    toggleSubs: "map:toggle_node_subs" }
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
    event: 'toggleVisible'
    collection : '$a.linkList' 
    triggerShow: "links:show_link_layer"
    triggerHide: "links:hide_link_layer"
    toggleSubs: "links:toggle_link_subs" }
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
    collection: '$a.eventSet'
    triggerShow: "map:show_event_layer"
    triggerHide: "map:hide_event_layer"}
  {
    label: 'Controllers'
    event: 'toggleVisible'
    collection: '$a.controllerSet'
    triggerShow: "map:show_controller_layer"
    triggerHide: "map:hide_controller_layer" }
  {
    label: 'Sensors'
    event: 'toggleVisible'
    collection: '$a.sensorList'
    triggerShow: "map:show_sensor_layer"
    triggerHide: "map:hide_sensor_layer" }
  # { 
  #  label: 'Demands'
  #  event: 'toggleVisible'
  #  triggerShow: "map:show_demand_layer"
  #  triggerHide: "map:hide_demand_layer" }
  { className: 'divider' }
  {
    label: 'Satelite Tiles'
    event: 'toggleMapTypeVisible'
    triggerShow: "map:show_satellite"
    triggerHide: "map:hide_satellite"
    collection: '$a.broker'
    initiallyChecked: false}
]

$a.mode_menu = [
  {
    label: 'View Only Mode'
    triggerShow: 'map:open_view_mode'
    initiallyChecked: false}
  {
    label: 'Network Edit Mode'
    triggerShow: 'map:open_network_mode'
    initiallyChecked: false}
  {
    label: 'Scenario Edit Mode'
    triggerShow: 'map:open_scenario_mode'
    initiallyChecked: true}
  {
    label: 'Route Edit Mode'
    triggerShow: 'map:open_route_mode'
    initiallyChecked: false}
]