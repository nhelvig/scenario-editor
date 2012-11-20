window.beats.Node::input_indexes = (other_node) ->
  _.map(@get('inputs').get('input'),
    (input, idx) ->
      link = input.get('link')
      [link, idx] if link.get('begin').get('node') == other_node
  )

window.beats.Node::output_indexes = (other_node) ->
  _.map(@get('outputs').get('output'),
    (output, idx) ->
      link = output.get('link')
      [link, idx] if link.get('end').get('node') == other_node
  )

window.beats.Node::road_names = ->
  _.map(@get('roadway_markers')?.get('marker'), 
    (marker) -> 
      marker?.get('name')
  ).join(", ") || "Name not defined"
  
window.beats.Node::terminal = ->
  @get('type') is 'T'

window.beats.Node::signalized = ->
  @get('type') is 'S'

window.beats.Node::inputs = ->
  @get('inputs').get('input')

window.beats.Node::outputs = ->
  @get('outputs').get('output')

window.beats.Node::ios = ->
  _.union(@outputs(), @inputs())

window.beats.Node::updatePosition = (pos) ->
  @get('position').get('point')[0].set({'lat':pos.lat(), 'lng':pos.lng()})

window.beats.Node::position = ->
  @get('position').get('point')[0]

  