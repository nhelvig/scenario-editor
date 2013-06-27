window.beats.DemandProfile::resolve_references =
  window.beats.ReferenceHelper.resolver('link_id_org', 'link', 'link', 'demand', 'DemandProfile', true)

window.beats.DemandProfile::encode_references = ->
  @set('link_id', @get('link').ident())

window.beats.DemandProfile::demands_by_vehicle_type = ->
    timeSepDemands = @get('text').split(",")
    vehTypeTimeSepDemands = _.map(timeSepDemands, (d) ->
       _.map(d.split(":"), Number))
    vals = _.zip.apply(null, vehTypeTimeSepDemands)

window.beats.DemandProfile::is_constant = ->
   @demands_by_vehicle_type()[0].length == 1

window.beats.DemandProfile::demands = ->
  @get('demand')