window.beats.Scenario.from_xml = (xml) ->
  object_with_id =
    networkset: {}
    node: {}
    link: {}
    path: {}
    sensor: {}

  sc = window.beats.Scenario.from_xml1(xml, object_with_id)
  sc.object_with_id = object_with_id

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

window.beats.Scenario::ident = ->
  @get('id')
window.beats.Scenario::set_id = (id) ->
  @set('id', id)

window.beats.Scenario::name = ->
  @get('name')
window.beats.Scenario::set_name = (name) ->
  @set('name', name)

window.beats.Scenario::description_text = ->
  @get('description')?.get('text')
window.beats.Scenario::set_description_text = (s) ->
  description = new window.beats.Description()
  description.set('text',s)
  @set('description',description)

window.beats.Scenario::project_id = -> @get 'project_id'
window.beats.Scenario::set_project_id = (pid) ->
  @set 'project_id', pid

window.beats.Scenario::locked_for_edit = -> @get('lockedForEdit')
window.beats.Scenario::set_locked_for_edit = (s) ->
  @set('lockedForEdit',(s.toString().toLowerCase() == 'true') if s?)

window.beats.Scenario::locked_for_history = ->  @get('lockedForHistory')
window.beats.Scenario::set_locked_for_history = (s) ->
  @set('lockedForHistory',(s.toString().toLowerCase() == 'true') if s?)

window.beats.Scenario::set_editor_show = (flag) ->
  @set('editor_show', flag)
  
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

window.beats.Scenario::set_sensor_set = (set) ->
  @set('sensorset', set)
  
window.beats.Scenario::sensor_set = ->
  if !@get('sensorset')?
    ss = new window.beats.SensorSet({'crudFlag': window.beats.CrudFlag.CREATE})
    @set('sensorset', ss) 
  @get('sensorset')

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

window.beats.Scenario::splitratio_set = ->
  @get('splitratioset')

window.beats.Scenario::set_splitratio_set = (set) ->
  @set('splitratioset', set)

window.beats.Scenario::splitratio_profiles = ->
  @get('splitratioset')?.get('splitratioprofile') || @createSplitRatioSet()

window.beats.Scenario::set_splitratio_profiles = (list) ->
  @get('splitratioset')?.set('splitratioprofile', list)

# Add the split ratio profile to the set for given node
window.beats.Scenario::add_splitratio_profile = (node) ->
  # create new Split Ratio Profile model
  profile = new window.beats.SplitRatioProfile({crudFlag: window.beats.CrudFlag.CREATE})
  # set this node id and resolve the reference
  profile.set_node_id(node.ident())
  profile.set_node(node)
  # add split ratio profile to set
  @.splitratio_profiles().push(profile)
  # add split ratio reference to node
  node.set_splitratio_profile(profile)
  # return split ratio profile
  profile

window.beats.Scenario::demand_set = ->
  @get('demandset')

window.beats.Scenario::set_demand_set = (set) ->
  @set('demandset', set)

window.beats.Scenario::demand_profiles = ->
  @get('demandset')?.get('demandprofile') || @createDemandSet()

window.beats.Scenario::set_demand_profiles = (list) ->
  @get('demandset')?.set('demandprofile', list)

# Add the demand profile to the set for given link
window.beats.Scenario::add_demand_profile = (link) ->
  # create new Demand Profile model
  profile = new window.beats.DemandProfile({crudFlag: window.beats.CrudFlag.CREATE})
  # set this link id and resolve the reference
  profile.set_link_id(link.ident())
  profile.set_link(link)
  # add demand profile to set
  @.demand_profiles().push(profile)
  # add demand reference to link
  link.set_demand_profile(profile)
  # return demand profile
  profile

window.beats.Scenario::fundamentaldiagram_set = ->
  @get('fundamentaldiagramset')

window.beats.Scenario::set_fundamentaldiagram_set = (set) ->
  @set('fundamentaldiagramset', set)

window.beats.Scenario::fundamentaldiagram_profiles = ->
  @get('fundamentaldiagramset')?.get('fundamentaldiagramprofile') || @createFundamentalDiagramSet()

window.beats.Scenario::set_fundamentaldiagram_profiles = (list) ->
  @get('fundamentaldiagramset')?.set('fundamentaldiagramprofile', list)

# Add the FD profile to the set for given link
window.beats.Scenario::add_fundamentaldiagram_profile = (link) ->
  # create new FD Profile model
  profile = new window.beats.FundamentalDiagramProfile({crudFlag: window.beats.CrudFlag.CREATE})
  # set this link id and resolve the reference
  profile.set_link_id(link.ident())
  profile.set_link(link)
  # add FD profile to set
  @.fundamentaldiagram_profiles().push(profile)
  # add FD reference to link
  link.set_fundamental_diagram_profile(profile)
  # return FD profile
  profile

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

  if linklist and linklist.has('link')
    _.each(linklist.get('link'),
          (link) =>

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


window.beats.Scenario::createController = ->
  @set('controllerset', new window.beats.ControllerSet)
  @get('controllerset').get('controller')

window.beats.Scenario::createEvent = ->
  @set('eventset', new window.beats.EventSet())
  @get('eventset').get('event')

window.beats.Scenario::createSplitRatioSet = ->
  @set('splitratioset', new window.beats.SplitRatioSet({crudFlag: window.beats.CrudFlag.CREATE}))
  @get('splitratioset').get('splitratioprofile')

window.beats.Scenario::createDemandSet = ->
  @set('demandset', new window.beats.DemandSet({crudFlag: window.beats.CrudFlag.CREATE}))
  @get('demandset').get('demandprofile')

window.beats.Scenario::createFundamentalDiagramSet = ->
  @set('fundamentaldiagramset', new window.beats.FundamentalDiagramSet({crudFlag: window.beats.CrudFlag.CREATE}))
  @get('fundamentaldiagramset').get('fundamentaldiagramprofile')

# This method copies the scenario project id, name and description to all set sub-elements
window.beats.Scenario::copy_info_to_sets = ->
  # Set all sets to have same project id to all sets
  if @sensor_set()?
    # copy project id if not set
    if @sensor_set().project_id() is null or @sensor_set().project_id() is undefined
      @sensor_set().set_project_id(@project_id())
    # copy scenario name if not set
    if @sensor_set().name() is null or @sensor_set().name() is undefined
      @sensor_set().set_name(@name() + ' Sensor Set')
    # copy description if not set
    if @sensor_set().description_text() is null or @sensor_set().description_text() is undefined
      @sensor_set().set_description_text(@description_text() + ' Sensor Set')

  if @splitratio_set()?
    # copy project id if not set
    if @splitratio_set().project_id() is null or @splitratio_set().project_id() is undefined
      @splitratio_set().set_project_id(@project_id())
    # copy scenario name if not set
    if @splitratio_set().name() is null or @splitratio_set().name() is undefined
      @splitratio_set().set_name(@name() + ' Split Ratio Set')
    # copy description if not set
    if @splitratio_set().description_text() is null or @splitratio_set().description_text() is undefined
      @splitratio_set().set_description_text(@description_text() + ' Split Ratio Set')

  if @fundamentaldiagram_set()?
    # copy project id if not set
    if @fundamentaldiagram_set().project_id() is null or @fundamentaldiagram_set().project_id() is undefined
      @fundamentaldiagram_set().set_project_id(@project_id())
    # copy scenario name if not set
    if @fundamentaldiagram_set().name() is null or @fundamentaldiagram_set().name() is undefined
      @fundamentaldiagram_set().set_name(@name() + ' FD Set')
    # copy description if not set
    if @fundamentaldiagram_set().description_text() is null or @fundamentaldiagram_set().description_text() is undefined
      @fundamentaldiagram_set().set_description_text(@description_text() + ' FD Set')

  if @demand_set()?
    # copy project id if not set
    if @demand_set().project_id() is null or @demand_set().project_id() is undefined
      @demand_set().set_project_id(@project_id())
    # copy scenario name if not set
    if @demand_set().name() is null or @demand_set().name() is undefined
      @demand_set().set_name(@name() + ' Demand Set')
    # copy description if not set
    if @demand_set().description_text() is null or @demand_set().description_text() is undefined
      @demand_set().set_description_text(@description_text() + ' Demand Set')

  if @networkset()?
    # copy project id if not set
    if @networkset().project_id() is null or @networkset().project_id() is undefined
      @networkset().set_project_id(@project_id())
    # copy scenario name if not set
    if @network().name() is null or @network().name() is undefined
      @network().set_name(@name() + ' Network')
    # copy description if not set
    if @network().description_text() is null or @network().description_text() is undefined
      @network().set_description_text(@description_text() + ' Network')


