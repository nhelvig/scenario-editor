window.beats.Splitratio::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    @set('in_link', object_with_id.link[@get('link_in')])
    @set('out_link', object_with_id.link[ @get('link_out')])

window.beats.Splitratio::encode_references = ->
  @set('link_in', @get('in_link').id)
  @set('link_out', @get('out_link').id)

window.beats.Splitratio::link_in_id = ->
  @get('link_in')

window.beats.Splitratio::set_link_in_id = (id) ->
  @set('link_in', id)

window.beats.Splitratio::link_out_id = ->
  @get('link_out')

window.beats.Splitratio::set_link_out_id = (id) ->
  @set('link_out', id)

window.beats.Splitratio::vehicle_type_id = ->
  @get('vehicleType_id')

window.beats.Splitratio::set_vehicle_type_id = (id) ->
  @set('vehicleType_id', id)

# get split ratio, at dt offset
window.beats.Splitratio::split_ratio = (offset) ->
  # create array of ratio values
  ratios = @get('text')?.split(',') || []
  ratio = null
  # check if offset is out of bounds
  if ratios.length > offset
    ratio = ratios[offset]
  ratio

# set split ratio, at dt offset
window.beats.Splitratio::set_split_ratio = (ratio, offset) ->
  # create array of ratio values
  ratios = @get('text')?.split(',') || []
  # check if offset is out of bounds
  if ratios.length > offset
    ratios[offset] = ratio
  # otherwise add ratio to end of array
  else
    ratios.push(ratio)
  @set('text', ratios.join())

# get split ratio database id, at dt offset
window.beats.Splitratio::ident = (offset) ->
  # create array of ids
  ids = @get('ids')?.split(',') || []
  id = null
  # check if offset is out of bounds
  if ids.length > offset
    id = ids[offset]
  id

# set split ratio database id, at dt offset
window.beats.Splitratio::set_ident = (id, offset) ->
  # create array of id values
  ids = @get('ids')?.split(',') || []
  # check if offset is out of bounds
  if ids.length > offset
    ids[offset] = id
    # otherwise add id to end of array
  else
    ids.push(id)
  @set('ids', ids.join())

# get split ratio crudflag, at dt offset
window.beats.Splitratio::crud = (offset) ->
  # create array of crudFlags
  crudFlags = @get('crudFlags')?.split(',') || []
  crudFlag = null
  # check if offset is out of bounds
  if crudFlags.length > offset
    crudFlag = crudFlags[offset]
  crudFlag

# set crudflag, at dt offset
window.beats.Splitratio::set_crud = (crudFlag, offset) ->
  # create array of crudFlag values
  crudFlags = @get('crudFlags')?.split(',') || []
  # check if offset is out of bounds
  if crudFlags.length > offset
    crudFlags[offset] = crudFlag
    # otherwise add crudFlag to end of array
  else
    crudFlags.push(crudFlag)
  @set('crudFlags', crudFlags.join())

# Return True if split ratio has the same link_in, link_out and vehicle type id
window.beats.Splitratio::equals = (link_in, link_out, vehicle_type_id) ->
  # check if link_in, link_out and vehicle_type_id match
  if @link_in_id() == link_in and @link_out_id() == link_out and @vehicle_type_id() == vehicle_type_id
    return true
  else
    return false

# Return the number of split ratios defined (ie. number of offsets)
window.beats.Splitratio::max_offset = () ->
  # get comma seperated ratio values, if none exist set ratios to empty array
  ratios = @get('text')?.split(',') || []
  ratios.length