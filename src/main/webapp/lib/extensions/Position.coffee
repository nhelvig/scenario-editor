window.beats.Position::defaults =
  point: []
  
window.beats.Position::initialize = ->
  @set 'point', []
  
window.beats.Position::points = -> @get 'point'