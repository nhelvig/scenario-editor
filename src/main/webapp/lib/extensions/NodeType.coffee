$a = window.beats

window.beats.NodeType::defaults =
  name: ''

window.beats.NodeType::name = -> @get 'name'
window.beats.NodeType::set_name = (name) -> @set 'name', name

window.beats.NodeType::id = -> @get 'id'
window.beats.NodeType::set_id = (id) -> @set 'id', id