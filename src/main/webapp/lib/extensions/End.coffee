window.beats.End::resolve_references =
  window.beats.ReferenceHelper.resolver('node_id', 'node', 'node', 'end', 'End', false)

window.beats.End::encode_references = ->
  @set 'node_id', @get('node').id