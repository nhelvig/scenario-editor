window.beats.Intersection::defaults =
  stage: []

window.beats.Intersection::resolve_references =
  window.beats.ReferenceHelper.resolver('node_id', 'node', 'node', 'intersection', 'Intersection', false)

window.beats.Intersection::encode_references = ->
  @set('node_id', @get('node').id)