window.beats.FundamentalDiagramSet::defaults =
  description: null
  fundamentaldiagramprofile: []
  id: null
  project_id: null
  name: null
  lockedForEdit: false
  lockedForHistory: false

window.beats.FundamentalDiagramSet::initialize = -> 
  @set 'fundamentaldiagramprofile', []

window.beats.FundamentalDiagramSet::fds_id = -> @get 'id'
window.beats.FundamentalDiagramSet::set_id = (id) -> @set 'id', id

window.beats.FundamentalDiagramSet::project_id = -> @get 'project_id'
window.beats.FundamentalDiagramSet::set_project_id = (pid) -> 
  @set 'project_id', pid

window.beats.FundamentalDiagramSet::name = -> @get 'name'
window.beats.FundamentalDiagramSet::set_name = (name) -> @set 'name', name

window.beats.FundamentalDiagramSet::description_text = -> @get('description')
window.beats.FundamentalDiagramSet::set_description_text = (s) ->
  @set('description', s)

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
