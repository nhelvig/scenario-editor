window.sirius.Input::resolve_references =
  window.sirius.ReferenceHelper.resolver('link_id', 'link', 'link', 'input', 'Input', false)

window.sirius.Input::encode_references = ->
  @set('link_id', @get('link').id)