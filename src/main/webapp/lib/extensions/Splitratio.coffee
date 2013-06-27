window.beats.Splitratio::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    @set('in_link', object_with_id.link[@get('link_in')])
    @set('out_link', object_with_id.link[ @get('link_out')])

window.beats.Splitratio::encode_references = ->
  @set('link_in', @get('in_link').id)
  @set('link_out', @get('out_link').id)

window.beats.Splitratio::ident = ->
  @get('id')

window.beats.Splitratio::in_link_id = ->
  @get('link_in')

window.beats.Splitratio::out_link_id = ->
  @get('link_out')

window.beats.Splitratio::ratio_order = ->
  @get('ratio_order')

window.beats.Splitratio::vehicle_type_id = ->
  @get('vehicleType_id')

window.beats.Splitratio::split_ratio = ->
  @get('text')
