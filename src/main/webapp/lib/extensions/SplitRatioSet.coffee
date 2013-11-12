window.beats.SplitRatioSet::defaults =
  description: null
  splitratioprofile: []
  id: null
  project_id: null
  name: null
  lockedForEdit: false
  lockedForHistory: false

window.beats.SplitRatioSet::initialize = ->
  @set 'splitratioprofile', []

window.beats.SplitRatioSet::ident = -> @get 'id'
window.beats.SplitRatioSet::set_id = (id) -> @set 'id', id

window.beats.SplitRatioSet::project_id = -> @get 'project_id'
window.beats.SplitRatioSet::set_project_id = (pid) ->
  @set 'project_id', pid

window.beats.SplitRatioSet::description_text = ->
  @get('description')?.get('text')
window.beats.SplitRatioSet::set_description_text = (s) ->
  description = new window.beats.Description()
  description.set('text',s)
  @set('description',description)

window.beats.SplitRatioSet::name = ->
  @get('name')

window.beats.SplitRatioSet::set_name = (s) ->
  @set('name',s)

window.beats.SplitRatioSet::split_ratio_profiles = ->
  @get('splitratioprofile')

window.beats.SplitRatioSet::set_split_ratio_profiles = (profs) ->
  @set 'splitratioprofile', profs

window.beats.SplitRatioSet::crud = -> @get('crudFlag')
window.beats.SplitRatioSet::set_crud = (flag) ->
  @set('crudFlag', flag)

window.beats.SplitRatioSet::locked_for_edit = -> @get('lockedForEdit')
window.beats.SplitRatioSet::set_locked_for_edit = (s) ->
  @set('lockedForEdit',(s.toString().toLowerCase() == 'true') if s?)

window.beats.SplitRatioSet::locked_for_history = -> @get('lockedForHistory')
window.beats.SplitRatioSet::set_locked_for_history = (s) ->
  @set('lockedForHistory',(s.toString().toLowerCase() == 'true') if s?)

# we need to remove the split ratio profiles that are deleted before saving to 
# xml and then put them back in the split ratio set so the database can be 
# updated correctly
window.beats.SplitRatioSet::old_to_xml = window.beats.SplitRatioSet::to_xml 
window.beats.SplitRatioSet::to_xml = (doc) ->
  xml = ''
  # If we are saving to file remove all deleted elements from list
  if window.beats? and window.beats.fileSaveMode
    filter = ((prof) => prof.crud() == window.beats.CrudFlag.DELETE)
    deletedProf = _.filter(@split_ratio_profiles(), filter)
    keepProf = _.reject(@split_ratio_profiles(), filter)
    @set_split_ratio_profiles keepProf
    xml = @remove_crud_modstamp_for_xml(doc)
    @set_split_ratio_profiles @split_ratio_profiles().concat(deletedProf)
  # Otherwise we are converting to xml for the database, so keep delete CRUDFlag
  else
    xml = @old_to_xml(doc)
    if @has('crudFlag') then xml.setAttribute('crudFlag', @get('crudFlag'))
  xml