window.beats.SplitRatioProfile::resolve_references =
  window.beats.ReferenceHelper.resolver('node_id', 'node', 'node', 'splitratioprofile', 'SplitRatioProfile', true)

window.beats.SplitRatioProfile::encode_references = ->
  @set 'node_id', @get('node').ident()

window.beats.SplitRatioProfile::split_ratios = ->
  @get('splitratio')