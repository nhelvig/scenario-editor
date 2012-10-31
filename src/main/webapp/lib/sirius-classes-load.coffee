$a = window.sirius

$a.models_with_extensions = [ 'Begin', 'CapacityProfile',
  'Controller', 'ControllerSet', 'Data_sources', 'DemandProfile',
  'Density', 'Display_position', 'Dynamics', 'End', 'Event', 'EventSet',
  'FundamentalDiagramProfile','Input', 'Intersection', 'Link', 'LinkList',
  'Network', 'NetworkList','Node', 'NodeList', 'Od', 'ODList', 'Output',
  'Phase', 'Plan', 'PlanList', 'PlanSequence', 'Point', 'Position', 'Scenario',
  'Sensor', 'SensorList', 'Settings', 'Signal', 'SignalList',
  'Splitratio', 'SplitratioProfile'
]

$a.models_without_extensions = [ 'ALatLng',
  'CapacityProfile', 'Data_source', 'Decision_point',
  'Decision_point_split', 'Decision_points', 'DecisionPoints',
  'DemandProfileSet', 'Description', 'DirectionsCacheEntry',
  'DirectionsCache', 'DownstreamBoundaryCapacityProfileSet',
  'EncodedPolyline', 'FeedbackElements', 'From', 'FundamentalDiagram',
  'FundamentalDiagramProfile', 'FundamentalDiagramProfileSet',
  'InitialDensitySet', 'Inputs', 'IntersectionCacheEntry',
  'IntersectionCache', 'Knob', 'Lane_count_change', 'Levels',
  'LinkGeometry', 'Link_reference', 'Linkpair', 'Links',
  'NetworkConnections', 'Networkpair', 'Od_demandProfile',
  'ODDemandProfileSet', 'Outputs', 'On_off_switch', 'Outputs',
  'Parameter', 'Parameters', 'Plan_reference', 'Points', 'Postmile',
  'Qcontroller', 'Route_segment', 'Route_segments',
  'RouteSegments', 'ScenarioElement', 'Splitratio', 'SplitratioEvent',
  'SplitRatioProfileSet', 'Stage', 'TargetElements', 'To', 'Units',
  'Vehicle_type', 'VehicleTypes', 'VehicleTypeOrder',
  'Weavingfactors', 'WeavingFactorSet' ]

$a.models_util = ['ArrayText', 'ReferenceHelper']

$a.collection_classes = ['NodeListCollection','NodeListView', 
  'LinkListCollection', 'LinkListView', 'SensorListCollection']

$a.map_view_classes = [
  'AppView', 'BrowserView', 'BrowserTypeView',  
  'ContextMenuItemView', 'ContextMenuView', 'DemandVisualizer', 'EditorView',
  'EditorLinkView', 'EditorSensorView', 'EditorNodeView', 'FileUploadView',
  'LayersMenuView', 'LayersMenuViewItem', 'MapLinkView', 'MapMarkerView',
  'MapNetworkView', 'MapNodeView', 'MapSensorView', 'MapControllerView', 
  'MapEventView', 'MapSignalView', 'MessagePanelView', 'TreeView',
  'TreeParentItemView', 'TreeChildItemView',
  'TreeChildItemLinkView', 'TreeChildItemNetworkView', 'TreeChildItemNodeView',
  'NavBarView','NavParentItemView','NavChildItemView'
]

$a.util_classes = ['ContextMenuHandler', 'GoogleMapRouteHandler', 'Util']
