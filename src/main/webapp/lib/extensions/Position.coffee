window.beats.Position::defaults =
  point: []
  
window.beats.Position::initialize = ->
  @set 'point', []
  
window.beats.Position::points = -> @get 'point'

window.beats.Position::add_point = (pt) -> @get('point').push(pt)