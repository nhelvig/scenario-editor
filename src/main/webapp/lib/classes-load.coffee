$a = window.beats

$a.models_with_extensions = [ 'Begin', 'CapacityProfile',
  'Controller', 'ControllerSet', 'DemandProfile',
  'Density', 'Display_position', 'Dynamics', 'End', 'Event', 'EventSet',
  'FundamentalDiagramProfile', 'Input', 'Intersection', 'Link', 'LinkList',
  'Marker', 'Network', 'NetworkList', 'Node', 'NodeList', 'Output',
  'Phase', 'Plan', 'PlanList', 'PlanSequence', 'Point', 'Position', 'Road',
  'Roads', 'Roadway_markers', 'Scenario', 'Sensor', 'SensorList', 'Settings',
  'Signal', 'SignalList', 'Splitratio', 'SplitratioProfile'
]

$a.models_without_extensions = [ 'ActivationIntervals', 'Beats'
  'Column', 'Column_name', 'Column_names', 'DemandProfileSet', 'Description',
  'DestinationNetworks', 'DownstreamBoundaryCapacityProfileSet',
  'FeedbackElements', 'FundamentalDiagram', 'FundamentalDiagramProfileSet',
  'InitialDensitySet', 'Inputs', 'IntersectionCacheEntry',
  'IntersectionCache', 'Interval', 'Link_reference', 'Link_references', 
  'Linkpair','NetworkConnections', 'Networkpair', 'Outputs',
  'Parameter', 'Parameters', 'Plan_reference', 'Queue_controller', 
  'Route', 'Routes', 'Row', 'ScenarioElement', 'Shape', 'SplitratioEvent',
  'SplitRatioProfileSet', 'Stage', 'Table', 'TargetElements', 'Units',
  'UserSession', 'Vehicle_type', 'VehicleTypes', 'VehicleTypeOrder',
  'Weavingfactors', 'WeavingFactorSet' 
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
