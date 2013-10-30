window.beats.FundamentalDiagramSet::defaults =
  description: null
  fundamentaldiagramprofile: []
  id: null
  project_id: null
  name: null
  lockedForEdit: false
  lockedForHistory: false

window.beats.FundamentalDiagramSet::initialize = () ->
  @set 'fundamentaldiagramprofile', []

window.beats.FundamentalDiagramSet::ident = -> @get 'id'
window.beats.FundamentalDiagramSet::set_id = (id) -> @set 'id', id

window.beats.FundamentalDiagramSet::project_id = -> @get 'project_id'
window.beats.FundamentalDiagramSet::set_project_id = (pid) -> 
  @set 'project_id', pid

window.beats.FundamentalDiagramSet::name = -> @get 'name'
window.beats.FundamentalDiagramSet::set_name = (name) -> @set 'name', name

window.beats.FundamentalDiagramSet::description_text = ->
  @get('description')?.get('text') || null
  
window.beats.FundamentalDiagramSet::set_description_text = (s) ->
  description = new window.beats.Description()
  description.set('text',s)
  @set('description',description)

window.beats.FundamentalDiagramSet::crud = -> @get('crudFlag')
window.beats.FundamentalDiagramSet::set_crud = (flag) ->
  @set('crudFlag', flag)

window.beats.FundamentalDiagramSet::fd_profiles = -> 
  @get 'fundamentaldiagramprofile'
window.beats.FundamentalDiagramSet::set_fd_profiles= (profs) -> 
  @set 'fundamentaldiagramprofile', profs

window.beats.FundamentalDiagramSet::locked_for_edit = -> @get('lockedForEdit')
window.beats.FundamentalDiagramSet::set_locked_for_edit = (s) ->
  @set('lockedForEdit',(s.toString().toLowerCase() == 'true') if s?)

window.beats.FundamentalDiagramSet::locked_for_history = -> @get('lockedForHistory')
window.beats.FundamentalDiagramSet::set_locked_for_history = (s) ->
  @set('lockedForHistory',(s.toString().toLowerCase() == 'true') if s?)
  
# we need to remove the links that are deleted before saving to xml and then
# put them in the link list so the database can be updated correctly
window.beats.FundamentalDiagramSet::old_to_xml = window.beats.FundamentalDiagramSet::to_xml 
window.beats.FundamentalDiagramSet::to_xml = (doc) ->
  xml = ''
  # If we are converting to xml to be saved to file remove all deleted elements from list
  if window.beats? and window.beats.fileSaveMode
    filter = ((fdp) => fdp.crud() == window.beats.CrudFlag.DELETE)
    deletedFDPs = _.filter(@fd_profiles(), filter)
    keepFDPs = _.reject(@fd_profiles(), filter)
    @set_fd_profiles keepFDPs
    xml = @remove_crud_modstamp_for_xml(doc)
    @set('fundamentaldiagramprofile', @fd_profiles().concat(deletedFDPs))   
  # Otherwise we are converting to xml to goto the database, so keep delete CRUDFlag
  else
    xml = @old_to_xml(doc)
  xml