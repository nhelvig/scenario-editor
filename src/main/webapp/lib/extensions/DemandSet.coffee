window.beats.DemandSet::initialize = ->
  @set 'demandprofile', []

window.beats.DemandSet::description_text = ->
  @get('description')?.get('text')

window.beats.DemandSet::set_description_text = (s) ->
  @get('description').set('text',s)

window.beats.DemandSet::name = ->
  @get('name')

window.beats.DemandSet::set_name = (s) ->
  @set('name',s)

window.beats.DemandSet::demand_profiles = ->
  @get('demandprofiles')