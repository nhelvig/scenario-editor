$a = window.sirius
# The names of all the parent tree elements of the scenario. It is used in MapNetworkView's _treeView method
$a.main_tree_elements = [
  'Initial Density Profiles', 'Network List', 'Controllers', 'Demand Profiles', 'Events', 'Fundamental Diagram Profiles', 'OD Demand Profiles',
  'Network Connections','Downstream Boundary Profiles','Split Ratio Profiles','Sensors','Signals'
  ]


# The menu items and their events for the main navigation bar
$a.nav_bar_menu_items = {
    'File': {
              'New' : (() -> alert('Not Configured'))
              'Open Local Network' : ((e) ->
                                        $("#uploadField").click()
                                        e.preventDefault())              
              'Save Local Network' : (() ->  if $a.models?
                                                doc = document.implementation.createDocument(null, null, null)
                                                $a.Util.writeAndDownloadXML $a.models.to_xml(doc), "../scenario.php", "../scenario-download.php"
                                             else
                                                $a.broker.trigger("app:show_message:info", "No scenario loaded")
                                    )
              'Close Local Network' : (() -> $a.broker.trigger('app:clear_map'))
              'Import Local Network' : (() -> alert('Not Configured'))
            }
    'Windows': {
                'Node Browser' : (() -> alert('Not Configured'))
                'Link Browser' : (() -> alert('Not Configured'))
                'Path Browser' : (() -> alert('Not Configured'))
                'Event Browser' : (() -> alert('Not Configured'))
                'Controller Browser' : (() -> alert('Not Configured'))
                'Sensor Browser' : (() -> alert('Not Configured'))
                'Network Properties' : (() -> alert('Not Configured'))
              }
    'Tools': {
              'Import PeMS data' : (() -> alert('Not Configured'))
              'Calibrate' : (() -> alert('Not Configured'))
              'Simulate' : (() -> alert('Not Configured'))
            }
    'Help': {
              'About' : (() -> alert('Not Configured'))
              'Help' : (() -> alert('Not Configured'))
              'Version' : (() -> alert('Not Configured'))
              'Identity' : (() -> alert('Not Configured'))
              'Contact' : (() -> alert('Not Configured'))
              'Legal' : (() -> alert('Not Configured'))
            }
}

# Main window context menu
$a.main_context_menu = [
   {className:'context_menu_item', event: (() -> $a.map.setZoom $a.map.getZoom()+1), label:'Zoom in'}
   {className:'context_menu_item', event: (() -> $a.map.setZoom $a.map.getZoom()-1), label:'Zoom out'}
   {className:'context_menu_separator'}
   {className:'context_menu_item', event: (() -> $a.map.panTo $a.contextMenu.position), label:'Center map here'}
]

# Link Context Menu
$a.link_context_menu = [
  { label: 'Select Link and its Nodes', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}")) }
  { label: 'Clear Selection', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}")) }
]

# Sensor Context Menu
$a.sensor_context_menu = [
  { label: 'Select sensor link', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}")) }
  { label: 'Clear Selection', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}")) }
]

# Node Context Menu
$a.node_context_menu = [
  { label: 'Select node and its links', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}")) }
  { label: 'Select Outgoing links', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:select_neighbors_outgoing:#{e.currentTarget.id}",['output'])) }
  { label: 'Select Incoming links', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:select_neighbors_incoming:#{e.currentTarget.id}",['input'])) }
  { label: 'Clear Selection', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}")) }
]

# Layers Menu
$a.layers_node_type_list = [
       { label: 'Freeway', event: 'toggleVisabilty', triggerShow: "map:nodes:show_freeway", triggerHide: "map:nodes:hide_freeway" }
       { label: 'Highway',   event: 'toggleVisabilty', triggerShow: "map:nodes:show_highway", triggerHide: "map:nodes:hide_higway"  }
       { label: 'Signalized Intersections', event: 'toggleVisabilty', triggerShow: "map:nodes:show_signalized_intersection", triggerHide: "map:nodes:hide_signalized_intersection"  }
       { label: 'Simple', event: 'toggleVisabilty', triggerShow: "map:nodes:show_simple", triggerHide: "map:nodes:hide_simple" }
       { label: 'Stop Intersections',   event: 'toggleVisabilty', triggerShow: "map:nodes:show_stop_intersection", triggerHide: "map:nodes:hide_stop_intersection"  }
       { label: 'Terminals', event: 'toggleVisabilty', triggerShow: "map:nodes:show_terminal", triggerHide: "map:nodes:hide_terminal"  }
       { label: 'Other', event: 'toggleVisabilty', triggerShow: "map:nodes:show_other", triggerHide: "map:nodes:hide_other"  }  
     ]

$a.layers_link_type_list = [
      { label: 'Elec. toll coll. lanes', event: 'toggleVisabilty', triggerShow: "map:links:show_electric_toll", triggerHide: "map:links:hide_electric_toll" }
      { label: 'Freeway mainlines', event: 'toggleVisabilty', triggerShow: "map:links:show_freeway", triggerHide: "map:links:hide_freeway"  }
      { label: 'Highway mainlines', event: 'toggleVisabilty', triggerShow: "map:links:show_highway", triggerHide: "map:links:hide_highway"  }
      { label: 'Heavy vehicle lanes', event: 'toggleVisabilty', triggerShow: "map:links:show_heavy_vehicle", triggerHide: "map:links:hide_heavy_vehicle" }
      { label: 'HOV lanes', event: 'toggleVisabilty', triggerShow: "map:links:show_hov", triggerHide: "map:links:hide_hov"  }
      { label: 'HOT lanes', event: 'toggleVisabilty', triggerShow: "map:links:show_hot", triggerHide: "map:links:hide_hot"  }
      { label: 'Interconnects', event: 'toggleVisabilty', triggerShow: "map:links:show_freeway_connector", triggerHide: "map:links:hide_freeway_connector" }
      { label: 'Intersection Approach', event: 'toggleVisabilty', triggerShow: "map:links:show_intersection_approach", triggerHide: "map:links:hide_intersection_approach" }
      { label: 'On-ramps', event: 'toggleVisabilty', triggerShow: "map:links:show_onramp", triggerHide: "map:links:hide_onramp"  }
      { label: 'Off-ramps', event: 'toggleVisabilty', triggerShow: "map:links:show_offramp", triggerHide: "map:links:hide_offramp"  }
      { label: 'Streets', event: 'toggleVisabilty', triggerShow: "map:links:show_street", triggerHide: "map:links:hide_street"  }
    ]

$a.layers_menu = [
  { label: 'Show all nodes', event: ((e) -> $a.broker.trigger('map:show_node_layer')) }
  { label: 'Hide all nodes', event: ((e) -> $a.broker.trigger('map:hide_node_layer')) }
  { label: 'Nodes', className: 'dropdown submenu', link: 'nodeTypeList', href: '#nodeTypeList', items: $a.layers_node_type_list }
  { className: 'divider' }
  { label: 'Show all links', event: ((e) -> $a.broker.trigger('map:show_link_layer')) }
  { label: 'Hide all links', event: ((e) -> $a.broker.trigger('map:hide_link_layer')) }
  { label: 'Links', className: 'dropdown submenu', href: '#linkTypeList', link: 'linkTypeList', items: $a.layers_link_type_list }
  { className: 'divider' }
  { label: 'Events', event: 'toggleVisabilty', triggerShow: "map:show_event_layer", triggerHide: "map:hide_event_layer" }
  { label: 'Controllers',  event: 'toggleVisabilty', triggerShow: "map:show_controller_layer", triggerHide: "map:hide_controller_layer" }
  { label: 'Sensors', event: 'toggleVisabilty', triggerShow: "map:show_sensor_layer", triggerHide: "map:hide_sensor_layer" }
]

