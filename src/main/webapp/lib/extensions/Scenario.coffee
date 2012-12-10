window.beats.Scenario.from_xml = (xml) ->
  object_with_id =
    networklist: {}
    node: {}
    link: {}
    path: {}
    sensor: {}

  sc = window.beats.Scenario.from_xml1(xml, object_with_id)
  sc.object_with_id = object_with_id

  if sc.has('demandprofileset')
    _.each(sc.get('demandprofileset').get('demandprofile'),
           (demand) ->
              demand.get('link').set('demand', demand)
    )
    sc.get('demandprofileset').set('demand', [])

  if sc.has('capacityprofileset')
    _.each(sc.get('capacityprofileset').get('capacity'),
           (capacity) ->
              capacity.get('link').set('capacity', capacity)
    )
    sc.get('capacityprofileset').set('capacity', [])

  if sc.has('initialdensityprofile')
    _.each(sc.get('initialdensityprofile').get('density'),
           (density) ->
             density.get('link').set('density',density)
    )
    sc.get('initialdensityprofile').set('density', [])

  if sc.has('splitratioprofileset')
    _.each(sc.get('splitratioprofileset').get('splitratioprofile'),
           (splitratios) ->
              splitratios.get('node').set('splitratios', splitratios)
    )
    sc.get('splitratioprofileset').set('splitratios', [])

  sc

window.beats.Scenario::initialize = ->
  @set('schemaVersion', window.beats.SchemaVersion)
  @object_with_id = network: {}, node: {}, link: {}, path: {}, sensor: {}
  @set 'settings', new window.beats.Settings
  @set 'networklist', new window.beats.NetworkList
  @set 'controllerset', new window.beats.ControllerSet
  @set 'eventset', new window.beats.EventSet
  @set 'sensorlist', new window.beats.SensorList
  @set 'signallist', new window.beats.SignalList

window.beats.Scenario::nodes = -> 
  @network().get('nodelist').get('node')

window.beats.Scenario::set_nodes = (list) ->
  @network().get('nodelist')?.set('node', list)

window.beats.Scenario::links = -> 
  @network().get('linklist')?.get('link') || []

window.beats.Scenario::set_links = (list) ->
  @network().get('linklist')?.set('link', list)

window.beats.Scenario::sensors = ->
  @get('sensorlist')?.get('sensor')

window.beats.Scenario::set_sensors = (list) ->
  @get('sensorlist')?.set('sensor', list)

window.beats.Scenario::controllers = ->
  @get('controllerset')?.get('controller') || @createController()

window.beats.Scenario::set_controllers = (list) ->
  @get('controllerset')?.set('controller', list)

window.beats.Scenario::events = ->
  @get('eventset')?.get('event') || @createEvent()

window.beats.Scenario::set_events = (list) ->
  @get('eventset')?.set('event', list)

window.beats.Scenario::networklist = -> 
  @get('networklist')
   
window.beats.Scenario::network = -> 
  @get('networklist').get('network')[0]

window.beats.Scenario::network_with_id = (id) ->
  @object_with_id.network[id]

window.beats.Scenario::node_with_id = (id) ->
  @object_with_id.node[id]

window.beats.Scenario::link_with_id = (id) ->
  @object_with_id.link[id]

window.beats.Scenario::set_network_with_id = (id, network) ->
  if network
    @object_with_id.network[id] = network
  else
    delete @object_with_id.network[id]

window.beats.Scenario::set_node_with_id = (id, node) ->
  if node
    @object_with_id.node[id] = node
  else
    delete @object_with_id.node[id]

window.beats.Scenario::set_link_with_id = (id, link) ->
  if link
    @object_with_id.link[id] = link
  else
    delete @object_with_id.link[id]

window.beats.Scenario::stampSchemaVersion = ->
  @set('schemaVersion', window.beats.SchemaVersion)

window.beats.Scenario::encode_references = ->
  demandprofileset = @get('demandprofileset')
  capacityprofileset = @get('downstreamboundarycapacityprofileset')
  initialdensityprofile = @get('initialdensityprofile')
  splitratioprofileset = @get('splitratioprofileset')
  network = @network()
  linklist = network.get('linklist') if network
  nodelist = network.get('nodelist') if network

  if demandprofileset && demandprofileset.has('demand')
    demandprofileset.set('demand', [])

  if capacityprofileset && capacityprofileset.has('capacity')
    capacityprofileset.set('capacity', [])

  if initialdensityprofile && initialdensityprofile.has('density')
    initialdensityprofile.set('density', [])

  if splitratioprofileset && splitratioprofileset.has('splitratios')
    splitratioprofileset.set('splitratios', [])

  if linklist and linklist.has('link')
    _.each(linklist.get('link'),
          (link) =>
            if link.has('demand')
              if(!demandprofileset)
                @set('demandprofileset', new window.beats.DemandProfileSet())
              if(!demandprofileset.has('demandprofile'))
                demandprofileset.set('demandprofile', [])
              demandprofileset.get('demandprofile').push(link.get('demand'))

            if link.has('capacity')
              if(!capacityprofileset)
                @set('downstreamboundarycapacityprofileset', new window.beats.DownstreamBoundaryCapacityProfileSet())
              if(!capacityprofileset.has('capacityprofile'))
                capacityprofileset.set('capacityprofile',[])
              capacityprofileset.get('capacityprofile').push(link.get('capacity'))

            if link.has('density')
              if(!initialdensityprofile)
                @set('initialdensityprofile', new window.beats.InitialDensityProfile())
              if(!initialdensityprofile.has('density'))
                initialdensityprofile.set('density', [])
              initialdensityprofile.get('density').push(link.get('density'))
    )

    if nodelist and nodelist.has('node')
      _.each(nodelist.get('node'),
        (node) =>
          if (node.has('splitratios'))
            if(!splitratioprofileset)
              @set('splitratioprofileset', new SplitRatioProfileSet())
            if(!splitratioprofileset.has('splitratios'))
              splitratioprofileset.set('splitratios', [])
            splitratioprofileset.get('splitratios').push(node.get('splitratios'))
      )

window.beats.Scenario::createController = ->
  @set('controllerset', new window.beats.ControllerSet)
  @get('controllerset').get('controller')

window.beats.Scenario::createEvent = ->
  @set('eventset', new window.beats.EventSet)
  @get('eventset').get('event')