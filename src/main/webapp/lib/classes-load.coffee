$a = window.beats

$a.models_with_extensions = [ 'Begin',
  'Controller', 'ControllerSet', 'DemandSet', 'DemandProfile', 'Demand',
  'Density', 'DisplayPosition', 'Dynamics', 'End', 'Event', 'EventSet',
  'FeedbackElements', 'FundamentalDiagram', 'FundamentalDiagramProfile',
  'FundamentalDiagramSet', 'Input', 'Link', 'LinkList', 'LinkType',
  'Marker', 'Network', 'NetworkSet', 'Node', 'NodeType', 'NodeList',
  'Output', 'Phase', 'Point', 'Position', 'Road', 'Roads',
  'RoadwayMarkers', 'Route', 'Scenario', 'Sensor', 'SensorSet', 'SensorType',
  'Settings', 'Signal', 'SignalSet', 'SplitRatioSet', 'Splitratio',
  'SplitRatioProfile'
]

$a.models_without_extensions = [ 'ActivationIntervals',
  'CalibrationAlgorithmType', 'Column', 'ColumnName', 'ColumnNames',
  'Description', 'DestinationNetworks',
  'DownstreamBoundaryCapacityProfile', 'DownstreamBoundaryCapacitySet', 
  'FundamentalDiagram', 'FundamentalDiagramSet', 'FundamentalDiagramType',
  'InitialDensitySet', 'Inputs',
  'Interval', 'LinkReference', 'LinkReferences',
  'Linkpair','NetworkConnections', 'Networkpair', 'Outputs',
  'Parameter', 'Parameters', 'QueueController', 
  'RouteLink', 'RouteSet', 'Row', 'ScenarioElement',  
  'Shape', 'SplitratioEvent',
  'Table', 'TargetElements', 'Units',
  'VehicleType', 'VehicleTypeSet','Weavingfactors', 'WeavingFactorSet' 
  ]

$a.collections = ['LinkListCollection', 'LinkListView',
  'ControllerSetCollection', 'ControllerSetView', 
  'EventSetCollection', 'EventSetView', 'NetworkCollection'
  'NodeListCollection','NodeListView', 
  'SensorListCollection', 'SensorListView',
  'ScenarioCollection', 'ScenarioElementCollection'
]

$a.map_views = [
  'AppView', 'BrowserView', 'BrowserTypeView',  
  'ContextMenuItemView', 'ContextMenuView', 'DemandVisualizer', 'EditorView',
  'EditorControllerView', 'EditorLinkView', 'EditorSensorView', 'EditorNodeView',
  'EditorNetworkView', 'EditorRouteView', 'EditorScenarioView', 
  'EditorSplitRatioProfileView',
  'EditorDemandProfileView', 'EditorFundamentalDiagramProfileView', 'FileUploadView', 'LayersMenuView',
  'LayersMenuViewItem', 'LogInView', 'MapLinkView', 'MapMarkerView',
  'MapNetworkView', 'MapNodeView',
  'MapControllerView', 'MapEventView', 'MapSignalView', 'MessagePanelView',
  'MapSensorView', 'MessageWindowView', 'ModeMenuView', 'ModeMenuViewItem',
  'NetworkBrowserView', 'PolygonDynamicView',
  'ScenarioBrowserView', 'TreeView', 'TreeParentItemView',
  'TreeChildItemView', 'TreeChildItemLinkView', 'TreeChildItemNetworkView',
  'TreeChildItemNodeView', 'NavBarView','NavParentItemView','NavChildItemView'
]

$a.utils = ['AjaxRequestHandler', 'ArrayText', 'Beats', 'ContextMenuHandler', 'Constants',
  'Environment', 'GoogleMapRouteHandler', 'ReferenceHelper', 'UserSession', 'Util'
]

$a.overrides = [ 'Model', 'Number', 'Sync' ]
