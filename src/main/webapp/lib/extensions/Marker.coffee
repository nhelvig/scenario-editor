window.beats.Marker::defaults =
  name: ''
  postmile: 0.0

window.beats.Marker::name = -> @get('name')
window.beats.Marker::postmile = -> @get('postmile')

window.beats.Marker::set_name = (name) -> @set('name', name)
window.beats.Marker::set_postmile = (postmile) -> @set('postmile', postmile)