window.sirius.DemandProfile::resolve_references =
  window.sirius.ReferenceHelper.resolver('link_id_origin', 'link', 'link', 'demand', 'DemandProfile', true)

window.sirius.DemandProfile::encode_references = ->
  @set('link_id', @get('link').id)