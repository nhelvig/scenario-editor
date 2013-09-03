window.beats.Scenario.from_xml = (xml) ->
  object_with_id =
    networkset: {}
    node: {}
    link: {}
    path: {}
    sensor: {}

  sc = window.beats.Scenario.from_xml1(xml, object_with_id)
  sc.object_with_id = object_with_id

  if sc.has('demandset')
    _.each(sc.get('demandset').get('demandprofile'),
           (demand) ->
              demand.get('link').set('demand', demand)
    )
    sc.get('demandset').set('demand', [])

  if sc.has('capacityprofileset')
    _.each(sc.get('capacityprofileset').get('capacity'),
           (capacity) ->
              capacity.get('link').set('capacity', capacity)
    )
    sc.get('capacityprofileset').set('capacity', [])

  if sc.has('initialdensityset')
    _.each(sc.get('initialdensityset').get('density'),
           (density) ->
             density.get('link').set('density',density)
    )
    sc.get('initialdensityset').set('density', [])

  if sc.has('splitratioset')
    _.each(sc.get('splitratioset').get('splitratioprofile'),
           (splitratios) ->
              splitratios.get('node').set('splitratios', splitratios)
    )
    sc.get('splitratioset').set('splitratios', [])

  sc

window.beats.Scenario::initialize = ->
  @set('schemaVersion', window.beats.SchemaVersion)
  @object_with_id = network: {}, node: {}, link: {}, path: {}, sensor: {}
  @set 'settings', new window.beats.Settings
  @set 'networkset', new window.beats.NetworkSet
  @set 'controllerset', new window.beats.ControllerSet
  @set 'eventset', new window.beats.EventSet
  @set 'sensorset', new window.beats.SensorSet
  @set 'signalset', new window.beats.SignalSet

window.beats.Scenario::set_position = (lat, lng) ->
  @network().set_position(lat, lng)

window.beats.Scenario::nodes = -> 
  @network().get('nodelist')?.get('node') || []

window.beats.Scenario::set_nodes = (list) ->
  @network().get('nodelist')?.set('node', list)

window.beats.Scenario::links = -> 
  @network().get('linklist')?.get('link') || []

window.beats.Scenario::set_links = (list) ->
  @network().get('linklist')?.set('link', list)

window.beats.Scenario::sensors = ->
  @get('sensorset')?.get('sensor') || []

window.beats.Scenario::set_sensors = (list) ->
  @get('sensorset')?.set('sensor', list)

window.beats.Scenario::controllers = ->
  @get('controllerset')?.get('controller') || @createController()

window.beats.Scenario::set_controllers = (list) ->
  @get('controllerset')?.set('controller', list)

window.beats.Scenario::events = ->
  @get('eventset')?.get('event') || @createEvent()

window.beats.Scenario::set_events = (list) ->
  @get('eventset')?.set('event', list)

window.beats.Scenario::splitratio_profiles = ->
  @get('splitratioset')?.get('splitratioprofile') || @createSplitRatioSet()

window.beats.Scenario::set_splitratio_profiles = (list) ->
  @get('splitratioset')?.set('splitratioprofile', list)

window.beats.Scenario::networkset = -> 
  @get('networkset')

window.beats.Scenario::networks = -> 
  @get('networkset').get('network')
     
window.beats.Scenario::network = -> 
  @get('networkset').get('network')[0]

window.beats.Scenario::settings = -> 
  @get('settings')

window.beats.Scenario::units_text = -> 
  @get('settings')?.get('units')?.get('text') || '' 

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
  demandset = @get('demandset')
  capacityprofileset = @get('downstreamboundarycapacityprofileset')
  initialdensityset = @get('initialdensityset')
  splitratioset = @get('splitratioset')
  network = @network()
  linklist = network.get('linklist') if network
  nodelist = network.get('nodelist') if network

  if demandset && demandset.has('demand')
    demandset.set('demand', [])

  if capacityprofileset && capacityprofileset.has('capacity')
    capacityprofileset.set('capacity', [])

  if initialdensityset && initialdensityset.has('density')
    initialdensityset.set('density', [])

  if splitratioset && splitratioset.has('splitratioprofile')
    splitratioset.set('splitratioprofile', [])

  if linklist and linklist.has('link')
    _.each(linklist.get('link'),
          (link) =>
            if link.has('demand')
              if(!demandset)
                @set('demandset', new window.beats.DemandSet())
                demandset = @get('demandset')
              if(!demandset.has('demandprofile'))
                demandset.set('demandprofile', [])
              demandset.get('demandprofile').push(link.get('demand'))

            if link.has('capacity')
              if(!capacityprofileset)
                @set('downstreamboundarycapacityprofileset', new window.beats.DownstreamBoundaryCapacitySet())
                capacityprofileset = @get('downstreamboundarycapacityprofileset')
              if(!capacityprofileset.has('capacityprofile'))
                capacityprofileset.set('capacityprofile',[])
              capacityprofileset.get('capacityprofile').push(link.get('capacity'))

            if link.has('density')
              if(!initialdensityset)
                @set('initialdensityset', new window.beats.InitialDensitySet())
                initialdensityset =  @get('initialdensityset')
              if(!initialdensityset.has('density'))
                initialdensityset.set('density', [])
              initialdensityset.get('density').push(link.get('density'))
    )

    if nodelist and nodelist.has('node')
      _.each(nodelist.get('node'),
        (node) =>
          if (node.has('splitratios'))
            if(!splitratioset)
              @set('splitratioset', new window.beats.SplitRatioSet())
              splitratioset = @get('splitratioset')
            if(!splitratioset.has('splitratioprofile'))
              splitratioset.set('splitratioprofile', [])
            splitratioset.get('splitratioprofile').push(node.get('splitratios'))
      )

window.beats.Scenario::createController = ->
  @set('controllerset', new window.beats.ControllerSet)
  @get('controllerset').get('controller')

window.beats.Scenario::createEvent = ->
  @set('eventset', new window.beats.EventSet)
  @get('eventset').get('event')

window.beats.Scenario::createSplitRatioSet = ->
  @set('splitratioset', new window.beats.SplitRatioSet)
  @get('splitratioset').get('splitratioprofile')