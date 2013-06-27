$a = window.beats
window.beats.Sensor_type::defaults =
  name: ''

window.beats.Sensor_type::name = -> @get 'name'
window.beats.Sensor_type::set_name = (name) -> @set 'name', name

window.beats.Sensor_type::ident = -> @get 'id'
window.beats.Sensor_type::set_id = (id) -> @set 'id', id