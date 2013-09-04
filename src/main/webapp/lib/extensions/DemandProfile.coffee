window.beats.DemandProfile::resolve_references =
  window.beats.ReferenceHelper.resolver('link_id_org', 'link', 'link', 'demand', 'DemandProfile', true)

window.beats.DemandProfile::encode_references = ->
  @set('link_id_org', @get('link').ident())

window.beats.DemandProfile::demands_by_vehicle_type = ->
    timeSepDemands = @get('text').split(",")
    vehTypeTimeSepDemands = _.map(timeSepDemands, (d) ->
       _.map(d.split(":"), Number))
    vals = _.zip.apply(null, vehTypeTimeSepDemands)

window.beats.DemandProfile::is_constant = ->
   @demands_by_vehicle_type()[0].length == 1

window.beats.DemandProfile::add = ->
  window.beats.models.split_ratio_profiles().push(@)

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

window.beats.DemandProfile::set_knob = (s) ->
  @set('knob', s)

window.beats.DemandProfile::destination_network_id = ->
  @get('destination_network_id')

window.beats.DemandProfile::set_destintation_network_id = (id) ->
  @set('destination_network_id', id)

window.beats.DemandProfile::demands = ->
  @get('demand')

# Returns demands for vehicle_type_id
window.beats.DemandProfile::split_ratio = (vehicle_type_id) ->
  demands =  @.split_ratios()
  for demand in demands
    if demand.equals(vehicle_type_id)
      return demand
return null