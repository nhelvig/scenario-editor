window.beats.CapacityProfile::resolve_references =
  window.beats.ReferenceHelper.resolver('link_id', 'link', 'link', 'capacity', 'CapacityProfile', true)

window.beats.CapacityProfile::encode_references = ->
  @set('link_id', @get('link').id)