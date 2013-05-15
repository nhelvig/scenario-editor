$a = window.beats
window.beats.Link_type::defaults =
  name: ''

window.beats.Link_type::name = -> @get 'name'
window.beats.Link_type::set_name = (name) -> @set 'name', name
