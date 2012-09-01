window.sirius.Node::input_indexes = (other_node) ->
  _.map(@get('inputs').get('input'),
    (input, idx) ->
      link = input.get('link')
      [link, idx] if link.get('begin').get('node') == other_node
  )

window.sirius.Node::output_indexes = (other_node) ->
  _.map(@get('outputs').get('output'),
    (output, idx) ->
      link = output.get('link')
      [link, idx] if link.get('end').get('node') == other_node
  )

window.sirius.Node::terminal = ->
  @get('type') is 'T'

window.sirius.Node::signalized = ->
  @get('type') is 'S'

window.sirius.Node::inputs = ->
  @get('inputs').get('input')

window.sirius.Node::outputs = ->
  @get('outputs').get('output')

window.sirius.Node::ios = ->
  _.union(@outputs(), @inputs())