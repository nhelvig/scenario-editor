window.beats.SplitratioProfile::resolve_references =
  window.beats.ReferenceHelper.resolver('node_id', 'node', 'node', 'splitratioprofile', 'SplitratioProfile', false)

window.beats.SplitratioProfile::encode_references = ->
  @set 'node_id', @get('node').id