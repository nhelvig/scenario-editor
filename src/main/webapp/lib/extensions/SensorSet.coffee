window.beats.SensorSet::defaults =
  sensor: []
  name: null
  description: null
  id: null
  project_id: null
  lockedForEdit: false
  lockedForHistory: false

window.beats.SensorSet::initialize = -> 
  @set 'sensor', []

window.beats.SensorSet::ident = -> @get 'id'
window.beats.SensorSet::set_id = (id) -> @set 'id', id

window.beats.SensorSet::project_id = -> @get 'project_id'
window.beats.SensorSet::set_project_id = (pid) -> @set 'project_id', pid

window.beats.SensorSet::name = -> @get 'name'
window.beats.SensorSet::set_name = (name) -> @set 'name', name

window.beats.SensorSet::description_text = ->
  @get('description')

window.beats.SensorSet::set_description_text = (s) ->
  @set('description',s)

window.beats.SensorSet::sensors = -> @get 'sensor'
window.beats.SensorSet::set_sensors = (set) -> @set 'sensor', set

window.beats.SensorSet::locked_for_edit = -> @get('lockedForEdit')
window.beats.SensorSet::set_locked_for_edit = (s) ->
  @set('lockedForEdit',(s.toString().toLowerCase() == 'true') if s?)

window.beats.SensorSet::locked_for_history = -> @get('lockedForHistory')
window.beats.SensorSet::set_locked_for_history = (s) ->
  @set('lockedForHistory',(s.toString().toLowerCase() == 'true') if s?)

window.beats.SensorSet::crud = -> @get('crudFlag')
window.beats.SensorSet::set_crud = (flag) ->
  @set('crudFlag', flag)

window.beats.SensorSet::mod_stamp = -> @get('mod_stamp')
window.beats.SensorSet::set_mod_stamp = (stamp) -> @set('mod_stamp', stamp)

window.beats.SensorSet::containsPemsSensor = (s) ->
  obj  = _.find(@sensors(), (sensor) => 
              sensor.sensor_id_original() is s.sensor_id_original()
            )
  return obj?

# we need to remove the sensors that are deleted before saving to xml and then
# put them in the sensor set so the database can be updated correctly
window.beats.SensorSet::old_to_xml = window.beats.SensorSet::to_xml 
window.beats.SensorSet::to_xml = (doc) ->
  xml = ''
  # If we are saving to file remove all deleted elements from list
  if window.beats? and window.beats.fileSaveMode
    filter = ((sensor) => sensor.crud() == window.beats.CrudFlag.DELETE)
    deletedSensors = _.filter(@sensors(), filter)
    keepSensors = _.reject(@sensors(), filter)
    @set_sensors keepSensors
    xml = @remove_crud_modstamp_for_xml(doc)
    @set('sensor', @sensors().concat(deletedSensors))
  # Otherwise we are converting to xml for the database, so keep delete CRUDFlag
  else
    xml = @old_to_xml(doc)
    if @has('crudFlag') then xml.setAttribute('crudFlag', @get('crudFlag'))
  xml