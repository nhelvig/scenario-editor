window.beats.FundamentalDiagramProfile::resolve_references =
  window.beats.ReferenceHelper.resolver('link_id', 'link', 'link', 'fundamentaldiagramprofile', 'FundamentalDiagramProfile', true)
  
window.beats.FundamentalDiagramProfile::encode_references = ->
  @set('link_id', @get('link').ident())