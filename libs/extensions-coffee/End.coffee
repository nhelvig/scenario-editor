window.sirius.End::resolve_references =
  window.sirius.ReferenceHelper.resolver('node_id', 'node', 'node', 'end', 'End', false)

window.sirius.End::encode_references = ->
  @set 'node_id', @get('node').id