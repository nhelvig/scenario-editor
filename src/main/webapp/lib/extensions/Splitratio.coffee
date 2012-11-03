window.beats.Splitratio::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    @set('in_link', object_with_id.link[@get('link_in')])
    @set('out_link', object_with_id.link[ @get('link_out')])

window.beats.Splitratio::encode_references = ->
  @set('link_in', @get('in_link').id)
  @set('link_out', @get('out_link').id)