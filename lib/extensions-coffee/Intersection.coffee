window.sirius.Intersection::defaults =
  stage: []

window.sirius.Intersection::resolve_references =
  window.sirius.ReferenceHelper.resolver('node_id', 'node', 'node', 'intersection', 'Intersection', false)

window.sirius.Intersection::encode_references = ->
  @set('node_id', @get('node').id)