window.beats.DemandProfile::defaults =
  demand: []
  destination_network_id: null
  crudFlag: null
  id: null
  link_id: null
  std_dev_add: 0
  std_dev_mult: 1
  start_time: 0
  knob: 0
  dt: 0

window.beats.DemandProfile::initialize = ->
  @set 'demand', []

window.beats.DemandProfile::resolve_references =
  window.beats.ReferenceHelper.resolver('link_id_org', 'link', 'link', 'demandprofile', 'DemandProfile', true)

window.beats.DemandProfile::encode_references = ->
  if @get('link')?
    @set('link_id_org', @get('link').ident())

window.beats.DemandProfile::demands_by_vehicle_type = ->
    timeSepDemands = @get('text').split(",")
    vehTypeTimeSepDemands = _.map(timeSepDemands, (d) ->
       _.map(d.split(":"), Number))
    vals = _.zip.apply(null, vehTypeTimeSepDemands)

window.beats.DemandProfile::is_constant = ->
   @demands_by_vehicle_type()[0].length == 1

window.beats.DemandProfile::crud = -> @get('crudFlag')
window.beats.DemandProfile::set_crud = (flag) ->
  @set('crudFlag', flag)

window.beats.DemandProfile::add = ->
  window.beats.models.demand().push(@)

window.beats.DemandProfile::link_id = ->
  @get('link_id_org')

window.beats.DemandProfile::set_link_id = (id) ->
  @set('link_id_org', id)

# returns link reference
window.beats.DemandProfile::link = ->
  @get('link')

# set link reference
window.beats.DemandProfile::set_link = (link) ->
  @set('link', link)

window.beats.DemandProfile::start_time = ->
  @get('start_time')

window.beats.DemandProfile::set_start_time = (s) ->
  @set('start_time', s)

window.beats.DemandProfile::dt = ->
  @get('dt')

window.beats.DemandProfile::set_dt = (s) ->
  @set('dt', s)

window.beats.DemandProfile::knob = ->
  @get('knob')

window.beats.DemandProfile::set_std_dev_add = (s) ->
  @set('std_dev_add', s)

window.beats.DemandProfile::std_dev_add = ->
  @get('std_dev_add')

window.beats.DemandProfile::set_std_dev_mult = (s) ->
  @set('std_dev_mult', s)

window.beats.DemandProfile::std_dev_mult = ->
  @get('std_dev_mult')

window.beats.DemandProfile::set_knob = (s) ->
  @set('knob', s)

window.beats.DemandProfile::destination_network_id = ->
  @get('destination_network_id')

window.beats.DemandProfile::set_destintation_network_id = (id) ->
  @set('destination_network_id', id)

window.beats.DemandProfile::demands = ->
  @get('demand')

# Returns demands for vehicle_type_id
window.beats.DemandProfile::demand = (vehicle_type_id) ->
  demands =  @.demands()
  for demand in demands
    if demand.equals(vehicle_type_id)
      return demand
return null