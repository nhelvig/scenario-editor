window.beats.SensorSet::defaults =
  sensor: []

window.beats.SensorSet::initialize = ->
  @set 'sensor', []

window.beats.Sensor::description = ->
  @get('description')

window.beats.Network::set_description = (s) ->
  @set('description',s)