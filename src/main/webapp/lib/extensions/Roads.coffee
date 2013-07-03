window.beats.Roads::initialize = ->
  @set('road',[new window.beats.Road])

window.beats.Roads::road = -> @get('road')

  