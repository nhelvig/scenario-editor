window.beats.End::resolve_references =
  window.beats.ReferenceHelper.resolver('node_id', 'node', 'node', 'end', 'End', false)

window.beats.End::encode_references = ->
  @set 'node_id', @get('node')?.id
  
window.beats.End::set_node = (node) ->
  @set 'node', node
  @set 'node_id', node.ident()

window.beats.End::node = -> @get 'node'