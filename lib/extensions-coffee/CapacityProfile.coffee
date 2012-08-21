window.sirius.CapacityProfile::resolve_references =
  window.sirius.ReferenceHelper.resolver('link_id', 'link', 'link', 'capacity', 'CapacityProfile', true)

window.sirius.CapacityProfile::encode_references = ->
  @set('link_id', @get('link').id)