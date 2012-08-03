window.sirius.Begin::resolve_references =
  window.sirius.ReferenceHelper.resolver('node_id', 'node', 'node', 'begin', 'Begin', false)

window.sirius.Begin::encode_references = ->
  @set 'node_id', @get('node').id