$a = window.beats
window.beats.SensorType::defaults =
  name: ''

window.beats.SensorType::name = -> @get 'name'
window.beats.SensorType::set_name = (name) -> @set 'name', name

window.beats.SensorType::ident = -> @get 'id'
window.beats.SensorType::set_id = (id) -> @set 'id', id