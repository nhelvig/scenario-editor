$a = window.beats
window.beats.LinkType::defaults =
  name: ''

window.beats.LinkType::name = -> @get 'name'
window.beats.LinkType::set_name = (name) -> @set 'name', name

window.beats.LinkType::id = -> @get 'id'
window.beats.LinkType::set_id = (id) -> @set 'id', id
