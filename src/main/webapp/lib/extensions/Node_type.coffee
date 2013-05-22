$a = window.beats

window.beats.Node_type::defaults =
  name: ''

window.beats.Node_type::name = -> @get 'name'
window.beats.Node_type::set_name = (name) -> @set 'name', name

window.beats.Node_type::id = -> @get 'id'
window.beats.Node_type::set_id = (id) -> @set 'id', name
