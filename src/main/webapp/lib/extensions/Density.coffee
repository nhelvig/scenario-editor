window.beats.Density::resolve_references =
  window.beats.ReferenceHelper.resolver('link_id', 'link', 'link', 'density', 'Density', true)

window.beats.Density::encode_references = ->
  @set('link_id', @get('link').id)