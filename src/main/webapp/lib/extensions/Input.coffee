window.beats.Input::resolve_references =
  window.beats.ReferenceHelper.resolver('link_id', 'link', 'link', 'input', 'Input', false)

window.beats.Input::encode_references = ->
  @set('link_id', @get('link').id)
  
window.beats.Input::link = ->
  @get('link')