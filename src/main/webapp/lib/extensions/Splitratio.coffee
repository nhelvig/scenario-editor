window.beats.Splitratio::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    @set('in_link', object_with_id.link[@get('link_in')])
    @set('out_link', object_with_id.link[ @get('link_out')])

window.beats.Splitratio::encode_references = ->
  @set('link_in', @get('in_link').id)
  @set('link_out', @get('out_link').id)

window.beats.Splitratio::in_link_id = ->
  @get('link_in')

window.beats.Splitratio::set_in_link_id(id) = ->
  @set('link_in', id)

window.beats.Splitratio::out_link_id = ->
  @get('link_out')

window.beats.Splitratio::set_out_link_id(id)= ->
  @set('link_out', id)

window.beats.Splitratio::vehicle_type_id = ->
  @get('vehicleType_id')

window.beats.Splitratio::set_vehicle_type_id(id) = ->
  @set('vehicleType_id', id)

# get split ratio, at dt offset
window.beats.Splitratio::split_ratio(offset) = ->
  # create array of ratio values
  ratios = @get('text').split(',')
  ratio = null
  # check if offset is out of bounds
  if ratios.length > offset
    ratio = ratios[offset]
  ratio

# set split ratio, at dt offset
window.beats.Splitratio::set_split_ratio(ratio, offset) = ->
  # create array of ratio values
  ratios = @get('text').split(',')
  # check if offset is out of bounds
  if ratios.length > offset
    ratios[offset] = ratio
  # otherwise add ratio to end of array
  else
    ratios.push(ratio)
  @set('text', ratios.join())

# get split ratio database id, at dt offset
window.beats.Splitratio::ident(offset) = ->
  # create array of ids
  ids = @get('ids').split(',')
  id = null
  # check if offset is out of bounds
  if ids.length > offset
    id = ids[offset]
  id

# set split ratio database id, at dt offset
window.beats.Splitratio::set_ident(id, offset) = ->
  # create array of id values
  ids = @get('id').split(',')
  # check if offset is out of bounds
  if ids.length > offset
    ids[offset] = id
    # otherwise add id to end of array
  else
    ids.push(id)
  @set('ids', ids.join())

# get split ratio crudflag, at dt offset
window.beats.Splitratio::crud(offset) = ->
  # create array of crudFlags
  crudFlags = @get('crudFlags').split(',')
  crudFlag = null
  # check if offset is out of bounds
  if crudFlags.length > offset
    crudFlag = crudFlags[offset]
  crudFlag

# set crudflag, at dt offset
window.beats.Splitratio::set_split_ratio(crudFlag, offset) = ->
  # create array of crudFlag values
  crudFlags = @get('crudFlags').split(',')
  # check if offset is out of bounds
  if crudFlags.length > offset
    crudFlags[offset] = crudFlag
    # otherwise add crudFlag to end of array
  else
    crudFlags.push(crudFlag)
  @set('crudFlags', crudFlags.join())
