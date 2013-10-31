$a = window.beats
window.beats.SensorType::defaults =
  id: 1
  name: "Loop"
  description: ""

window.beats.SensorType::name = -> @get 'name'
window.beats.SensorType::set_name = (name) -> @set 'name', name

window.beats.SensorType::ident = -> @get 'id'
window.beats.SensorType::set_id = (id) -> @set 'id', id

window.beats.SensorType::description = -> @get 'description'
window.beats.SensorType::set_description = (desc) -> @set 'description', desc