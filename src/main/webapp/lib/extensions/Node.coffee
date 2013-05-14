$a = window.beats

window.beats.Node::defaults =
  in_sync: false

window.beats.Node::initialize = ->
  @set('roadway_markers', new $a.Roadway_markers)
  @set('outputs', new $a.Outputs({output: []}))
  @set('inputs', new $a.Inputs({input: []}))
  t = new $a.Node_type()
  t.set_name("simple")
  @set('node_type',t)

window.beats.Node::crud = -> @get 'crudFlag'
window.beats.Node::set_crud = (flag) ->
  if @crud() != $a.CrudFlag.CREATE
    @set 'crudFlag', flag

window.beats.Node::name = -> @get("node_name")
window.beats.Node::set_name = (name) -> @set("node_name", name)

window.beats.Node::in_sync = -> @get("in_sync")
window.beats.Node::set_in_sync = (flag) -> @set("in_sync", flag)

window.beats.Node::ident = -> Number(@get("id"))

window.beats.Node::node_type = -> @get("node_type") if @get("node_type")?
window.beats.Node::type = -> @get("node_type").name() if @get("node_type")?
window.beats.Node::set_type = (val) -> 
  @get("node_type").set_name(val)
  @defaults['type'] = val

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
  @get('node_type').name() is 'terminal'

window.beats.Node::signalized = ->
  @get('type') is 'S'

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
  # nodes = window.beats.models.nodes()
  # nodes = _.reject(nodes, (n) => n is @)
  # window.beats.models.set_nodes(nodes)
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

window.beats.Node::selected = ->
  @get('selected')