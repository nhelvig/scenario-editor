class window.beats.Scenario extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    #return null if (not xml? or xml.length == 0)
    obj = new window.beats.Scenario()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    settings = xml.children('settings')
    obj.set('settings', $a.Settings.from_xml2(settings, deferred, object_with_id))
    NetworkSet = xml.children('NetworkSet')
    obj.set('networkset', $a.NetworkSet.from_xml2(NetworkSet, deferred, object_with_id))
    VehicleTypeSet = xml.children('VehicleTypeSet')
    obj.set('vehicletypeset', $a.VehicleTypeSet.from_xml2(VehicleTypeSet, deferred, object_with_id))
    SignalSet = xml.children('SignalSet')
    obj.set('signalset', $a.SignalSet.from_xml2(SignalSet, deferred, object_with_id))
    SensorSet = xml.children('SensorSet')
    obj.set('sensorset', $a.SensorSet.from_xml2(SensorSet, deferred, object_with_id))
    InitialDensitySet = xml.children('InitialDensitySet')
    obj.set('initialdensityset', $a.InitialDensitySet.from_xml2(InitialDensitySet, deferred, object_with_id))
    WeavingFactorSet = xml.children('WeavingFactorSet')
    obj.set('weavingfactorset', $a.WeavingFactorSet.from_xml2(WeavingFactorSet, deferred, object_with_id))
    SplitRatioSet = xml.children('SplitRatioSet')
    obj.set('splitratioset', $a.SplitRatioSet.from_xml2(SplitRatioSet, deferred, object_with_id))
    DownstreamBoundaryCapacitySet = xml.children('DownstreamBoundaryCapacitySet')
    obj.set('downstreamboundarycapacityset', $a.DownstreamBoundaryCapacitySet.from_xml2(DownstreamBoundaryCapacitySet, deferred, object_with_id))
    EventSet = xml.children('EventSet')
    obj.set('eventset', $a.EventSet.from_xml2(EventSet, deferred, object_with_id))
    DemandSet = xml.children('DemandSet')
    obj.set('demandset', $a.DemandSet.from_xml2(DemandSet, deferred, object_with_id))
    ControllerSet = xml.children('ControllerSet')
    obj.set('controllerset', $a.ControllerSet.from_xml2(ControllerSet, deferred, object_with_id))
    FundamentalDiagramSet = xml.children('FundamentalDiagramSet')
    obj.set('fundamentaldiagramset', $a.FundamentalDiagramSet.from_xml2(FundamentalDiagramSet, deferred, object_with_id))
    NetworkConnections = xml.children('NetworkConnections')
    obj.set('networkconnections', $a.NetworkConnections.from_xml2(NetworkConnections, deferred, object_with_id))
    DestinationNetworks = xml.children('DestinationNetworks')
    obj.set('destinationnetworks', $a.DestinationNetworks.from_xml2(DestinationNetworks, deferred, object_with_id))
    Route = xml.children('Route')
    obj.set('route', $a.Route.from_xml2(Route, deferred, object_with_id))
    project_id = $(xml).attr('project_id')
    obj.set('project_id', Number(project_id))
    id = $(xml).attr('id')
    obj.set('id', Number(id))
    name = $(xml).attr('name')
    obj.set('name', name)
    schemaVersion = $(xml).attr('schemaVersion')
    obj.set('schemaVersion', schemaVersion)
    lockedForEdit = $(xml).attr('lockedForEdit')
    obj.set('lockedForEdit', (lockedForEdit.toString().toLowerCase() == 'true') if lockedForEdit?)
    lockedForHistory = $(xml).attr('lockedForHistory')
    obj.set('lockedForHistory', (lockedForHistory.toString().toLowerCase() == 'true') if lockedForHistory?)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('scenario')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    xml.appendChild(@get('settings').to_xml(doc)) if @has('settings')
    xml.appendChild(@get('networkset').to_xml(doc)) if @has('networkset')
    xml.appendChild(@get('vehicletypeset').to_xml(doc)) if @has('vehicletypeset')
    xml.appendChild(@get('signalset').to_xml(doc)) if @has('signalset')
    xml.appendChild(@get('sensorset').to_xml(doc)) if @has('sensorset')
    xml.appendChild(@get('initialdensityset').to_xml(doc)) if @has('initialdensityset')
    xml.appendChild(@get('weavingfactorset').to_xml(doc)) if @has('weavingfactorset')
    xml.appendChild(@get('splitratioset').to_xml(doc)) if @has('splitratioset')
    xml.appendChild(@get('downstreamboundarycapacityset').to_xml(doc)) if @has('downstreamboundarycapacityset')
    xml.appendChild(@get('eventset').to_xml(doc)) if @has('eventset')
    xml.appendChild(@get('demandset').to_xml(doc)) if @has('demandset')
    xml.appendChild(@get('controllerset').to_xml(doc)) if @has('controllerset')
    xml.appendChild(@get('fundamentaldiagramset').to_xml(doc)) if @has('fundamentaldiagramset')
    xml.appendChild(@get('networkconnections').to_xml(doc)) if @has('networkconnections')
    xml.appendChild(@get('destinationnetworks').to_xml(doc)) if @has('destinationnetworks')
    xml.appendChild(@get('route').to_xml(doc)) if @has('route')
    if @has('project_id') && @project_id != 0 then xml.setAttribute('project_id', @get('project_id'))
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('schemaVersion', @get('schemaVersion')) if @has('schemaVersion')
    if @has('lockedForEdit') && @lockedForEdit != false then xml.setAttribute('lockedForEdit', @get('lockedForEdit'))
    if @has('lockedForHistory') && @lockedForHistory != false then xml.setAttribute('lockedForHistory', @get('lockedForHistory'))
    xml
  
  deep_copy: -> Scenario.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null