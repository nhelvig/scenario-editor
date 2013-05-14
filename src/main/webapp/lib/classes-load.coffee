$a = window.beats

$a.models_with_extensions = [ 'Begin', 'CapacityProfile',
  'Controller', 'ControllerSet', 'DemandProfile',
  'Density', 'Display_position', 'Dynamics', 'End', 'Event', 'EventSet',
  'FundamentalDiagramProfile', 'Input', 'Intersection', 'Link', 'LinkList',
  'Link_type', 'Marker', 'Network', 'NetworkSet', 'Node', 'Node_type', 'NodeList', 'Output',
  'Phase', 'Point', 'Position', 'Road',
  'Roads', 'Roadway_markers', 'Scenario', 'Sensor', 'SensorSet', 'Settings',
  'Signal', 'SignalSet', 'Splitratio', 'SplitRatioProfile'
]

$a.models_without_extensions = [ 'ActivationIntervals', 'Beats'
  'Column', 'Column_name', 'Column_names', 'DemandSet', 'Description',
  'DestinationNetworks','DownstreamBoundaryCapacityProfile',
  'DownstreamBoundaryCapacitySet', 'FeedbackElements',
  'FundamentalDiagram', 'FundamentalDiagramSet', 'FundamentalDiagramType',
  'InitialDensitySet', 'Inputs',
  'Interval', 'Link_reference', 'Link_references', 'Link_type',
  'Linkpair','NetworkConnections', 'Networkpair',  'Node_type', 'Outputs',
  'Parameter', 'Parameters', 'Queue_controller', 
  'Route', 'Route_links', 'Row', 'ScenarioElement', 'Sensor_type', 
  'Shape', 'SplitratioEvent',
  'SplitRatioSet', 'Table', 'TargetElements', 'Units',
  'UserSession', 'Vehicle_type', 'VehicleTypeOrder',
  'VehicleTypeSet','Weavingfactors', 'WeavingFactorSet' 
  ]

$a.collections = ['LinkListCollection', 'LinkListView',
  'ControllerSetCollection', 'ControllerSetView', 
  'EventSetCollection', 'EventSetView', 'NetworkCollection'
  'NodeListCollection','NodeListView', 
  'SensorListCollection', 'SensorListView',
  'ScenarioElementCollection'
]

$a.map_views = [
  'AppView', 'BrowserView', 'BrowserTypeView',  
  'ContextMenuItemView', 'ContextMenuView', 'DemandVisualizer', 'EditorView',
  'EditorControllerView', 'EditorLinkView', 'EditorSensorView', 'EditorNodeView', 
  'FileUploadView', 'LayersMenuView', 'LayersMenuViewItem', 'LogInView'
  'MapLinkView', 'MapMarkerView', 'MapNetworkView', 'MapNodeView', 'MapSensorView', 
  'MapControllerView', 'MapEventView', 'MapSignalView', 'MessagePanelView', 'MessageWindowView'
  'NetworkBrowserView', 'TreeView', 'TreeParentItemView', 'TreeChildItemView',
  'TreeChildItemLinkView', 'TreeChildItemNetworkView', 'TreeChildItemNodeView',
  'NavBarView','NavParentItemView','NavChildItemView'
]

$a.utils = ['ArrayText',  'ContextMenuHandler', 'Constants', 'Environment',
  'GoogleMapRouteHandler', 'ReferenceHelper', 'Util'
]

$a.overrides = [ 'Sync' ]
