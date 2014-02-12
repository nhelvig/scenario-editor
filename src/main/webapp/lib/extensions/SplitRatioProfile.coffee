window.beats.SplitRatioProfile::defaults =
  splitratio: []
  destination_network_id: null
  network_id: null
  crudFlag: null
  id: null
  node_id: null
  start_time: 0
  dt: 0

window.beats.SplitRatioProfile::initialize = ->
  @set 'splitratio', []

window.beats.SplitRatioProfile::resolve_references =
  window.beats.ReferenceHelper.resolver('node_id', 'node', 'node', 'splitratioprofile', 'SplitRatioProfile', true)

window.beats.SplitRatioProfile::encode_references = ->
  if @get('node')?
    @set 'node_id', @get('node').ident()

window.beats.SplitRatioProfile::add = ->
  window.beats.models.split_ratio_profiles().push(@)

window.beats.SplitRatioProfile::node_id = ->
  @get('node_id')

window.beats.SplitRatioProfile::set_node_id = (id) ->
  @set('node_id', id)

# returns node reference
window.beats.SplitRatioProfile::node = ->
  @get('node')

# set node reference
window.beats.SplitRatioProfile::set_node = (node) ->
  @set('node', node)

window.beats.SplitRatioProfile::start_time = ->
  @get('start_time')

window.beats.SplitRatioProfile::set_start_time = (s) ->
  @set('start_time', s)

window.beats.SplitRatioProfile::dt = ->
  @get('dt')

window.beats.SplitRatioProfile::set_dt = (s) ->
  @set('dt', s)

window.beats.SplitRatioProfile::network_id = ->
  @get('network_id')

window.beats.SplitRatioProfile::set_network_id = (id) ->
  @set('network_id', id)

window.beats.SplitRatioProfile::destination_network_id = ->
  @get('destination_network_id')

window.beats.SplitRatioProfile::set_destintation_network_id = (id) ->
  @set('destination_network_id', id)

window.beats.SplitRatioProfile::split_ratios = ->
  @get('splitratio')

window.beats.SplitRatioProfile::set_split_ratios = (ratios) ->
  @set('splitratio', ratios)
  
window.beats.SplitRatioProfile::crud = -> @get('crudFlag')
window.beats.SplitRatioProfile::set_crud = (flag) ->
  @set('crudFlag', flag)

# Returns split ratios which have given link_in, link_out and vehicle_type_id
window.beats.SplitRatioProfile::split_ratio = (link_in, link_out, vehicle_type_id) ->
  splitratios =  @.split_ratios()
  for splitratio in splitratios
    if splitratio.equals(link_in, link_out, vehicle_type_id)
      return splitratio
  return null

# we need to remove the splitratios that have no ratios before saving to xml 
# and then put them back in the profile so the database is updated correctly
window.beats.SplitRatioProfile::old_to_xml = window.beats.SplitRatioProfile::to_xml 
window.beats.SplitRatioProfile::to_xml = (doc) ->
  xml = ''
  # If we are saving to file remove all deleted elements from list
  if window.beats? and window.beats.fileSaveMode
    keepSplits = []
    deletedSplits = []
    for split in @split_ratios()
        count = 0
        splitsArray = if split.cruds() then split.cruds().split(',') else Array()
        for s in splitsArray
          if s == window.beats.CrudFlag.DELETE
            count++
        if count is not 0 and count is splitsArray.length
          deletedSplits.push(split)
        else
          keepSplits.push(split)
    
    @set_split_ratios keepSplits
    xml = @remove_crud_modstamp_for_xml(doc)
    @set_split_ratios @split_ratios().concat(deletedSplits)
  # Otherwise we are converting to xml for the database, so keep delete CRUDFlag
  else
    xml = @old_to_xml(doc)
    if @has('crudFlag') then xml.setAttribute('crudFlag', @get('crudFlag'))
  xml
