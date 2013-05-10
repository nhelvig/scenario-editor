window.beats.SplitRatioProfile::resolve_references =
  window.beats.ReferenceHelper.resolver('node_id', 'node', 'node', 'splitratioprofile', 'SplitRatioProfile', false)

window.beats.SplitRatioProfile::encode_references = ->
  @set 'node_id', @get('node').id