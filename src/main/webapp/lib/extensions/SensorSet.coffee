window.beats.SensorSet::defaults =
  sensor: []
  name: ''
  description: ''
  id: null
  project_id: null
  lockedForEdit: false
  lockedForHistory: false

window.beats.SensorSet::initialize = -> @set 'sensor', []

window.beats.SensorSet::ident = -> @get 'id'
window.beats.SensorSet::set_id = (id) -> @set 'id', id

window.beats.SensorSet::project_id = -> @get 'project_id'
window.beats.SensorSet::set_project_id = (pid) -> @set 'project_id', pid

window.beats.SensorSet::name = -> @get 'name'
window.beats.SensorSet::set_name = (name) -> @set 'name', name

window.beats.SensorSet::description = -> @get('description')
window.beats.SensorSet::set_description = (s) -> @set('description', s)

window.beats.SensorSet::sensors = -> @get 'sensor'
window.beats.SensorSet::set_sensors = (set) -> @set 'sensor', set

window.beats.SensorSet::locked_for_edit = -> @get('lockedForEdit')
window.beats.SensorSet::set_locked_for_edit = (s) ->
  @set('lockedForEdit',(s.toString().toLowerCase() == 'true') if s?)

window.beats.SensorSet::locked_for_history = -> @get('lockedForHistory')
window.beats.SensorSet::set_locked_for_history = (s) ->
  @set('lockedForHistory',(s.toString().toLowerCase() == 'true') if s?)