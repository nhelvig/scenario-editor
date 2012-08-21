window.sirius.FundamentalDiagramProfile::resolve_references =
  window.sirius.ReferenceHelper.resolver('link_id', 'link', 'link', 'fundamentaldiagramprofile', 'FundamentalDiagramProfile', false)

window.sirius.FundamentalDiagramProfile::encode_references = ->
  @set('link_id', @get('link').id)