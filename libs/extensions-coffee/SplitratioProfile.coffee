window.sirius.SplitratioProfile::resolve_references =
  window.sirius.ReferenceHelper.resolver('node_id', 'node', 'node', 'splitratioprofile', 'SplitratioProfile', false)

window.sirius.SplitratioProfile::encode_references = ->
  @set 'node_id', @get('node').id