window.beats.Output::resolve_references =
  window.beats.ReferenceHelper.resolver('link_id', 'link', 'link', 'output', 'Output', false)

window.beats.Output::encode_references = ->
  @set('link_id', @get('link').id)

window.beats.Output::link = ->
  @get('link')
