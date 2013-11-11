window.beats.DemandSet::defaults =
  description: null
  demandprofile: []
  id: null
  project_id: null
  name: null
  lockedForEdit: false
  lockedForHistory: false

window.beats.DemandSet::initialize = ->
  @set 'splitratioprofile', []

window.beats.DemandSet::ident = -> @get 'id'
window.beats.DemandSet::set_id = (id) -> @set 'id', id

window.beats.DemandSet::project_id = -> @get 'project_id'
window.beats.DemandSet::set_project_id = (pid) ->
  @set 'project_id', pid

window.beats.DemandSet::description_text = ->
  @get('description')?.get('text')
window.beats.DemandSet::set_description_text = (s) ->
  description = new window.beats.Description()
  description.set('text',s)
  @set('description',description)

window.beats.DemandSet::name = ->
  @get('name')

window.beats.DemandSet::set_name = (s) ->
  @set('name',s)

window.beats.DemandSet::demand_profiles = ->
  @get('demandprofile')

window.beats.DemandSet::set_demand_profiles = (profs) ->
  @set 'demandprofile', profs

window.beats.DemandSet::crud = -> @get('crudFlag')
window.beats.DemandSet::set_crud = (flag) ->
  @set('crudFlag', flag)

window.beats.DemandSet::locked_for_edit = -> @get('lockedForEdit')
window.beats.DemandSet::set_locked_for_edit = (s) ->
  @set('lockedForEdit',(s.toString().toLowerCase() == 'true') if s?)

window.beats.DemandSet::locked_for_history = -> @get('lockedForHistory')
window.beats.DemandSet::set_locked_for_history = (s) ->
  @set('lockedForHistory',(s.toString().toLowerCase() == 'true') if s?)
  
# we need to remove the demand profiles that are deleted before saving to 
# xml and then put them back in the demand set so the database can be 
# updated correctly
window.beats.DemandSet::old_to_xml = window.beats.DemandSet::to_xml 
window.beats.DemandSet::to_xml = (doc) ->
  xml = ''
  # If we are saving to file remove all deleted elements from list
  if window.beats? and window.beats.fileSaveMode
    filter = ((prof) => prof.crud() == window.beats.CrudFlag.DELETE)
    deletedProf = _.filter(@demand_profiles(), filter)
    keepProf = _.reject(@demand_profiles(), filter)
    @set_demand_profiles keepProf
    xml = @remove_crud_modstamp_for_xml(doc)
    @set_demand_profiles @demand_profiles().concat(deletedProf)
  # Otherwise we are converting to xml for the database, so keep delete CRUDFlag
  else
    xml = @old_to_xml(doc)
    if @has('crudFlag') then xml.setAttribute('crudFlag', @get('crudFlag'))
  xml