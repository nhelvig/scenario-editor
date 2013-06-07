window.beats.Begin::resolve_references =
  window.beats.ReferenceHelper.resolver('node_id', 'node', 'node', 'begin', 'Begin', false)

window.beats.Begin::encode_references = ->
  @set 'node_id', @get('node').id
  
window.beats.Begin::set_node = (node) ->
  @set 'node', node
  @set 'node_id', node.ident()

window.beats.Begin::node = -> @get 'node'