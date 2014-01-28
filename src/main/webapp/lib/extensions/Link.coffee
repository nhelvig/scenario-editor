$a = window.beats
window.beats.Link::defaults =
  selected : false
  lanes: 1
  lane_offset: 0
  in_sync: true

window.beats.Link::initialize = ->
  @set('dynamics', new window.beats.Dynamics)
  @set('roads', new window.beats.Roads)
  @set('position', new window.beats.Position)
  @set('subdivide', false)
  @set('shape', new window.beats.Shape)
  t = new window.beats.LinkType()
  @set('link_type',t)

window.beats.Link::shape = -> @get("shape")
window.beats.Link::geometry = -> @get("shape")?.get('text') || undefined
window.beats.Link::ident = -> Number(@get("id"))
window.beats.Link::demand = -> @get("demand")
window.beats.Link::demand_profile = -> @get("demandprofile")
window.beats.Link::fundamental_diagram_profile = -> @get("fundamentaldiagramprofile")
window.beats.Link::crud = -> @get 'crudFlag'
window.beats.Link::lanes = -> @get("lanes")
window.beats.Link::lane_offset = -> @get("lane_offset")
window.beats.Link::length = -> @get('length')
window.beats.Link::speed_limit = -> @get('speed_limit')
window.beats.Link::link_name = -> @get('link_name')
window.beats.Link::mod_stamp = -> @get('mod_stamp')
window.beats.Link::in_sync = -> @get('in_sync')
window.beats.Link::dynamics = -> @get('dynamics')
window.beats.Link::roads = -> @get('roads')
window.beats.Link::subdivide = -> @get("subdivide")

window.beats.Link::set_id = (id) -> @set('id', id)
window.beats.Link::set_end_node = (node) -> @end().set_node(node)
window.beats.Link::set_begin_node = (node) -> @begin().set_node(node)
window.beats.Link::begin = -> 
  if(!@has('begin'))
     @set('begin', new window.beats.Begin())
  @get('begin')
  
window.beats.Link::end = -> 
  if(!@has('end'))
     @set('end', new window.beats.End())
  @get('end')
  
window.beats.Link::begin_node = -> @begin()?.node()
window.beats.Link::end_node = -> @end()?.node()
  
window.beats.Link::set_generic = (id, val) -> 
  @set(id, val)
  @defaults[id] = val

window.beats.Link::set_link_name = (name) -> @set('link_name',name)

window.beats.Link::set_length = (length) ->@set('length', length)
window.beats.Link::set_mod_stamp = (stamp) -> @set('mod_stamp', stamp) 
window.beats.Link::set_crud = (flag) -> 
    if @crud() != window.beats.CrudFlag.CREATE
      @set 'crudFlag', flag
window.beats.Link::set_crud_update = ->
    if @crud() != window.beats.CrudFlag.CREATE
      @set 'crudFlag', window.beats.CrudFlag.UPDATE

window.beats.Link::set_demand_profile = (profile) -> @set('demandprofile',profile)

window.beats.Link::set_fundamental_diagram_profile = (profile) -> @set('fundamentaldiagramprofile',profile)

window.beats.Link::set_subdivide = (val) -> @set("subdivide", val)

window.beats.Link::set_geometry = (text) ->
  @set('shape', new window.beats.Shape)  if not @get('shape')?
  @get('shape').set('text',text)

window.beats.Link::set_dynamics = (type) -> 
  @get('dynamics').set_type(type)

window.beats.Link::link_type = -> @get("link_type")
window.beats.Link::type_id = -> @get("link_type").get("id") if @get("link_type")?
window.beats.Link::type_name = -> @get("link_type").name() if @get("link_type")?
window.beats.Link::set_type = (id, name) ->
  @set('link_type', new window.beats.LinkType)  if not @get('link_type')?
  @get("link_type").set_name(name)
  @get("link_type").set_id(id)
  @defaults['link_type'] = id

window.beats.Link::updatePosition = (pos) ->
  @get('position').get('point').push(pos)

window.beats.Link::set_position = (points) ->
  @set('position', new $a.Position) if !@get('position')?
  @get('position').set('point', points)
  
window.beats.Link::position = ->
  @get('position')?.get('point')

window.beats.Link::parallel_links = ->
  begin_node = @get('begin').get('node')
  end_node = @get('end').get('node')

  _.map(_.filter(begin_node.get('outputs').get('output'),
    (output) =>
      link2 = output.get('link')
      link2 isnt this and link2.get('end').get('node') is end_node
  ), (output) -> output.get('link'))

window.beats.Link::road_names = ->
  _.map(@get('roads')?.get('road'), (r) -> r.get('name')).join(", ")

window.beats.Link::set_road_names = (name) ->
  if !@get('roads')?
    @set('roads', new window.beats.Roads)
  if !@get('roads').get('road')?
    @get('roads').set('road',[])
  r = @get('roads').get('road')
  if r.length == 0
    r.push(new window.beats.Road())
  r[0].set('name',name)
  r[0].defaults["name"] = name

window.beats.Link::set_hide = (flag) ->
  @set('hide', flag)
  
window.beats.Link::hide = ->
  @get('hide')

window.beats.Link::toggle_selected =  ->
  if(@selected() is true) 
    @set('selected', false) 
  else 
    @set('selected', true)

window.beats.Link::set_selected = (flag) ->
  @set('selected', flag)
  
window.beats.Link::selected = ->
  @get('selected')

window.beats.Link::remove = ->
  if @crud() is $a.CrudFlag.CREATE
    links = window.beats.models.links()
    links = _.reject(links, (l) => l.ident() is @.ident())
    window.beats.models.set_links(links)
  else
    # remove link from input output
    @set_crud($a.CrudFlag.DELETE)
  @updateInputOutputs()
  @stopListening

window.beats.Link::updateInputOutputs = ->
  @begin_node().remove_input_output(@) if @begin_node()?
  @end_node().remove_input_output(@) if @end_node()?
  
window.beats.Link::add = ->
  window.beats.models.links().push(@)

window.beats.Link::editor_show = ->
  @get('editor_show')

window.beats.Link::set_editor_show = (flag) ->
  @set('editor_show', flag)

window.beats.Link::set_show_demands = (flag) ->
  @set('show_demands', flag)

window.beats.Link::show_demands = -> @get('show_demands', flag)

# This method is called when a node is re-positioned and the link redrawn.
# Before removing the link we need to get its attributes so they can 
# be copied into the new link. Note: Moving a node requires a delete of 
# the old attached link and creating a new link in order to meet the specs
# for link handling in the database
window.beats.Link::copy_attributes = ->
  {
    'link_name': @link_name()
    'lanes': @lanes()
    'lane_offset': @lane_offset()
    'in_sync': @in_sync()
    'selected': @selected()
    'speed_limit': @speed_limit()
    'subdivide': @subdivide()
    'link_type': new $a.LinkType({id:@type_id(), name:@type_name()})
    'dynamics': new $a.Dynamics({type:@dynamics().type()}) if @dynamics()?
    'roads': @roads() if @roads?
  }

# we need to remove the crudFlag and mop_stamp before saving to an xml file
# and then replace both attributes on the object
window.beats.Link::old_to_xml = window.beats.Link::to_xml 
window.beats.Link::to_xml = (doc) ->
  xml = ''
  # If we are converting to xml to be saved to file removed CRUDFlag and modstamp
  if window.beats? and window.beats.fileSaveMode
    crud = @crud()
    mod = @mod_stamp()
    @unset 'crudFlag', { silent:true }
    @unset 'mod_stamp', { silent:true }
    xml = @old_to_xml(doc)
    @set_crud(crud) if crud?
    @set_mod_stamp(mod) if mod?
  # Otherwise we are converting to xml to goto the database
  else
    xml = @old_to_xml(doc)
  xml
