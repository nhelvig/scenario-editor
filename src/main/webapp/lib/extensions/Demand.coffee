window.beats.Demand::defaults =
  id: null
  vehicle_type_id: null
  text: null

window.beats.Demand::vehicle_type_id = ->
  @get('vehicle_type_id')

window.beats.Demand::set_vehicle_type_id = (id) ->
  @set('vehicle_type_id', Number(id))

window.beats.Demand::demands = -> @get('text')

# get demand, at dt offset
window.beats.Demand::demand = (offset) ->
  # create array of demand values
  demands = @get('text')?.split(',') || []
  demand = null
  # check if offset is out of bounds
  if demands.length > offset
    demand = demands[offset]
  demand

# set demand, at dt offset
window.beats.Demand::set_demand = (demand, offset) ->
  # create array of demand values
  demands = @get('text')?.split(',') || []
  # check if offset is out of bounds
  if demands.length > offset
    demands[offset] = demand
    # otherwise add demand to end of array
  else
    demands.push(demand)
  @set('text', demands.join())

# get demand database id, at dt offset
window.beats.Demand::ident = (offset) ->
  # create array of ids
  ids = @get('ids')?.split(',') || []
  id = null
  # check if offset is out of bounds
  if ids.length > offset
    id = ids[offset]
  id

# set demand database id, at dt offset
window.beats.Demand::set_ident = (id, offset) ->
  # create array of id values
  ids = @get('ids')?.split(',') || []
  # check if offset is out of bounds
  if ids.length > offset
    ids[offset] = id
    # otherwise add id to end of array
  else
    ids.push(id)
  @set('ids', ids.join())

window.beats.Demand::mod_stamp = -> @get('mod_stamp')
window.beats.Demand::set_mod_stamp = (stamp) -> @set('mod_stamp', stamp)

# get the array of crudflags
window.beats.Demand::cruds = () -> @get('crudFlags')
  
# get demand crudflag, at dt offset
window.beats.Demand::crud = (offset) ->
  # create array of crudFlags
  crudFlags = @get('crudFlags')?.split(',') || []
  crudFlag = null
  # check if offset is out of bounds
  if crudFlags.length > offset
    crudFlag = crudFlags[offset]
  crudFlag

# set crudflag, at dt offset
window.beats.Demand::set_crud = (crudFlag, offset) ->
  # create array of crudFlag values
  crudFlags = @get('crudFlags')?.split(',') || []
  # check if offset is out of bounds
  if crudFlags.length > offset
    crudFlags[offset] = crudFlag
    # otherwise add crudFlag to end of array
  else
    crudFlags.push(crudFlag)
  @set('crudFlags', crudFlags.join())

# Return True if demand has the same vehicle type id
window.beats.Demand::equals = (vehicle_type_id) ->
  # check if vehicle_type_id matches
  if @vehicle_type_id() == Number(vehicle_type_id)
    return true
  else
    return false

# Return the number of demands defined (ie. number of offsets)
window.beats.Demand::max_offset = () ->
  # get comma seperated demand values, if none exist set demands to empty array
  demands = @get('text')?.split(',') || []
  demands.length

# remove the text values that are to be deleted for the xml save
window.beats.Demand::remove_deleted_vals = ->
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

# removed the crudFlag and modstamp attributes from the object as well as  
# removing all deleted demand values to save the object to xml and then
# put everything back in order to ensure clean save to db
window.beats.Demand::old_to_xml = window.beats.Demand::to_xml 
window.beats.Demand::to_xml = (doc) ->
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