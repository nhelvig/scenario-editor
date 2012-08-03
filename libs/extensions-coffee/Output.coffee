window.sirius.Output::resolve_references =
  window.sirius.ReferenceHelper.resolver('link_id', 'link', 'link', 'output', 'Output', false)

window.sirius.Output::encode_references = ->
  @set('link_id', @get('link').id)