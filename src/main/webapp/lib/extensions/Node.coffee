$a = window.beats

window.beats.Node::defaults =
  in_sync: false

window.beats.Node::initialize = ->
  @set('roadway_markers', new $a.RoadwayMarkers)
  @set('outputs', new $a.Outputs({output: []}))
  @set('inputs', new $a.Inputs({input: []}))
  t = new $a.NodeType()
  t.set_name("simple")
  t.set_id("4")
  @set('node_type',t)

window.beats.Node::splitratio_profile = ->
  @get("splitratioprofile")

window.beats.Node::set_splitratio_profile = (profile) ->
  @set("splitratioprofile", profile)

window.beats.Node::crud = -> @get 'crudFlag'
window.beats.Node::set_crud = (flag) ->
  if @crud() != $a.CrudFlag.CREATE
    @set 'crudFlag', flag
window.beats.Node::set_crud_update = ->
  if @crud() != $a.CrudFlag.CREATE
    @set 'crudFlag', window.beats.CrudFlag.UPDATE

window.beats.Node::name = -> @get("node_name")
window.beats.Node::set_name = (name) -> @set("node_name", name)

window.beats.Node::in_sync = -> @get("in_sync")
window.beats.Node::set_in_sync = (flag) -> @set("in_sync", flag)

window.beats.Node::ident = -> Number(@get("id"))
window.beats.Node::set_id = (id) -> @set("id", id)

window.beats.Node::node_type = -> @get("node_type") if @get("node_type")?
window.beats.Node::type_id = -> @get("node_type").get("id") if @get("node_type")?
window.beats.Node::type_name = -> @get("node_type").name() if @get("node_type")?
window.beats.Node::set_type = (id, name) ->
  @set('node_type', new window.beats.NodeType)  if not @get('node_type')?
  @get("node_type").set_name(name)
  @get("node_type").set_id(id)
  @defaults['node_type'] = id


window.beats.Node::mod_stamp = -> @get('mod_stamp')
window.beats.Node::set_mod_stamp = (stamp) -> @set('mod_stamp', stamp)

window.beats.Node::locked = -> @get("lock")? and @get("lock") is true
window.beats.Node::set_locked = (val) -> 
  @set("lock", val)
  @defaults['lock'] = val

window.beats.Node::input_indexes = (other_node) ->
  _.map(@get('inputs').get('input'),
    (input, idx) ->
      link = input.get('link')
      [link, idx] if link.get('begin').get('node') == other_node
  )

window.beats.Node::output_indexes = (other_node) ->
  _.map(@get('outputs').get('output'),
    (output, idx) ->
      link = output.get('link')
      [link, idx] if link.get('end').get('node') == other_node
  )

window.beats.Node::roadway_markers = -> @get('roadway_markers')
window.beats.Node::road_names = ->
  _.map(@get('roadway_markers')?.get('marker'), 
    (marker) -> 
      marker?.get('name')
  ).join(", ") || "Name not defined"

window.beats.Node::set_road_names = (name) ->
  if !@get('roadway_markers')?
    @set('roadway_markers', new window.beats.Roadway_markers)
  if !@get('roadway_markers').get('marker')?
    @get('roadway_markers').set('marker',[])
  m = @get('roadway_markers').get('marker')
  if m.length == 0
    m.push(new window.beats.Marker())
  m[0].set('name',name)
  m[0].defaults['name'] = name

window.beats.Node::terminal = ->
  @get('node_type').name() is 'Terminal'

window.beats.Node::signalized = ->
  @get('type') is 'S'

window.beats.Node::remove_input_output = (link) ->
  if @has('inputs') and @get('inputs').get('input').length > 0
    @get('inputs').set 'input', @inputs().filter (i) -> i.link() isnt link
  if @has('outputs') and @get('outputs').get('output').length > 0
    @get('outputs').set 'output', @outputs().filter (o) -> o.link() isnt link
  
window.beats.Node::set_input = (link) ->
  @inputs().push new window.beats.Input({link: link})
  
window.beats.Node::set_output = (link) ->
  @outputs().push new window.beats.Output({link: link})

window.beats.Node::inputs = ->
  if(!@has('inputs'))
    @set('inputs', new window.beats.Inputs({input: []}))
  @get('inputs').get('input')

window.beats.Node::outputs = ->
  if(!@has('outputs'))
    @set('outputs', new window.beats.Outputs({output: []}))
  @get('outputs').get('output')

window.beats.Node::ios = ->
  _.union(@outputs(), @inputs())

window.beats.Node::updatePosition = (pos) ->
  @get('position').get('point')[0].set({'lat':pos.lat(), 'lng':pos.lng()})

window.beats.Node::position = ->
  @get('position').get('point')[0]

window.beats.Node::remove = ->
  if @crud() is $a.CrudFlag.CREATE
    nodes = window.beats.models.nodes()
    nodes = _.reject(nodes, (n) => n is @)
    window.beats.models.set_nodes(nodes)
  else
    @set_crud($a.CrudFlag.DELETE)
  @stopListening

window.beats.Node::add = ->
  window.beats.models.nodes().push(@)

window.beats.Node::editor_show = ->
  @get('editor_show')

window.beats.Node::set_editor_show = (flag) ->
  @set('editor_show', flag)

window.beats.Node::toggle_selected =  ->
  if(@selected() is true) 
    @set('selected', false) 
  else 
    @set('selected', true)

window.beats.Node::set_selected = (flag) ->
  @set('selected', flag)

window.beats.Node::selected = ->
  @get('selected')

# we need to remove the crudFlag and mop_stamp before saving to an xml file
# and then replace both attributes on the object
window.beats.Node::old_to_xml = window.beats.Node::to_xml 
window.beats.Node::to_xml = (doc) ->
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