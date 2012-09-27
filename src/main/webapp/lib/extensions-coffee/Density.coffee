window.sirius.Density::resolve_references =
  window.sirius.ReferenceHelper.resolver('link_id', 'link', 'link', 'density', 'Density', true)

window.sirius.Density::encode_references = ->
  @set('link_id', @get('link').id)