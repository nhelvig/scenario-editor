window.beats.Node::defaults =
  type: ''
  lock: false

window.beats.Node::initialize = ->
  @set('roadway_markers', new window.beats.Roadway_markers)

window.beats.Node::ident = -> @get("id")
window.beats.Node::type = -> @get("type")

window.beats.Node::set_type = (val) -> 
  @set('type', val)
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
  @get('type') is 'T'

window.beats.Node::signalized = ->
  @get('type') is 'S'

window.beats.Node::inputs = ->
  @get('inputs').get('input')

window.beats.Node::outputs = ->
  @get('outputs').get('output')

window.beats.Node::ios = ->
  _.union(@outputs(), @inputs())

window.beats.Node::updatePosition = (pos) ->
  @get('position').get('point')[0].set({'lat':pos.lat(), 'lng':pos.lng()})

window.beats.Node::position = ->
  @get('position').get('point')[0]

window.beats.Node::remove = ->
  nodes = window.beats.models.nodes()
  nodes = _.reject(nodes, (n) => n is @)
  window.beats.models.set_nodes(nodes)

window.beats.Node::add = ->
  window.beats.models.nodes().push(@)