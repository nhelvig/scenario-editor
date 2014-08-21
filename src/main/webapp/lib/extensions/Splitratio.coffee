window.beats.Splitratio::defaults =
  crudFlag: null
  id: null
  link_in: null
  link_out: null
  vehicle_type_id: null
  text: null

window.beats.Splitratio::mod_stamp = -> @get('mod_stamp')
window.beats.Splitratio::set_mod_stamp = (stamp) -> @set('mod_stamp', stamp)

window.beats.Splitratio::link_in_id = ->
  @get('link_in')

window.beats.Splitratio::set_link_in_id = (id) ->
  @set('link_in', Number(id))

window.beats.Splitratio::link_out_id = ->
  @get('link_out')

window.beats.Splitratio::set_link_out_id = (id) ->
  @set('link_out', Number(id))

window.beats.Splitratio::vehicle_type_id = ->
  @get('vehicle_type_id')

window.beats.Splitratio::set_vehicle_type_id = (id) ->
  @set('vehicle_type_id', Number(id))

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

window.beats.Splitratio::mod_stamp = -> @get('mod_stamp')
window.beats.Splitratio::set_mod_stamp = (stamp) -> @set('mod_stamp', stamp)

# get split ratio crudflag, at dt offset
window.beats.Splitratio::crud = (offset) ->
  # create array of crudFlags
  crudFlags = @get('crudFlags')?.split(',') || []
  crudFlag = null
  # check if offset is out of bounds
  if crudFlags.length > offset
    crudFlag = crudFlags[offset]
  crudFlag

window.beats.Splitratio::cruds = -> @get('crudFlags')
  
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
  if @link_in_id() == Number(link_in) and @link_out_id() == Number(link_out) and \
  @vehicle_type_id() == Number(vehicle_type_id)
    return true
  else
    return false

# Return the number of split ratios defined (ie. number of offsets)
window.beats.Splitratio::max_offset = () ->
  # get comma seperated ratio values, if none exist set ratios to empty array
  ratios = @get('text')?.split(',') || []
  ratios.length

# remove the text values that are to be deleted for the xml save
window.beats.Splitratio::remove_deleted_vals = ->
  vals = @get('text').split(",")
  cruds = if @cruds() then @cruds().split(",") else Array()
  remove = 0
  for crud, i in  cruds
    if(crud == window.beats.CrudFlag.DELETE)
      vals.splice(remove, 1)
      remove--
    remove++
  keepText = vals.join(',')
  keepText

# removed the crudFlag and modstamp attributes from the object 
# saves the object to xml and puts the attributes back in
window.beats.Splitratio::old_to_xml = window.beats.Splitratio::to_xml 
window.beats.Splitratio::to_xml = (doc) ->
  xml = ''
  # If we are converting to xml to be saved to file removed CRUDFlag and modstamp
  if window.beats? and window.beats.fileSaveMode
    originalText = @get('text')
    @set('text', @remove_deleted_vals())
    crud = @get('crudFlags')
    mod = @mod_stamp()
    @unset 'crudFlags', { silent:true }
    @unset 'mod_stamp', { silent:true }
    xml = @old_to_xml(doc)
    @set('crudFlags', crud) if crud?
    @set_mod_stamp(mod) if mod?
    @set('text', originalText)
  # Otherwise we are converting to xml to goto the database
  else
    xml = @old_to_xml(doc)
  xml