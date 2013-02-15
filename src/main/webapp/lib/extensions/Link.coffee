window.beats.Link::defaults =
  type: ''
  lanes: 1
  lane_offset: 0
  record: true
  in_sync: true

window.beats.Link::initialize = ->
  @set('dynamics', new window.beats.Dynamics())
  @set('roads', new window.beats.Roads)
  @set('subdivide', false)

window.beats.Link::set_geometry = (text) ->
  sh = new window.beats.Shape()
  sh.set('text', text)
  @set('shape', sh)

window.beats.Link::geometry = -> @get("shape")?.get('text') || undefined
window.beats.Link::id = -> @get("id")
window.beats.Link::type = -> @get("type")
window.beats.Link::lanes = -> @get("lanes")
window.beats.Link::set_generic = (id, val) -> 
  @set(id, val)
  @defaults[id] = val

window.beats.Link::subdivide = -> @get("subdivide")

window.beats.Link::set_subdivide = (val) ->
  @set("subdivide", val)

window.beats.Link::ident = -> Number(@get("id"))
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

window.beats.Link::begin_node = ->
  @get('begin').get('node')

window.beats.Link::end_node = ->
  @get('end').get('node')
  
window.beats.Link::remove = ->
  links = window.beats.models.links()
  links = _.reject(links, (l) => l.id is @.id)
  window.beats.models.set_links(links)

window.beats.Link::add = ->
  window.beats.models.links().push(@)

window.beats.Link::set_length = (length) ->
  @set('length', length)

window.beats.Link::length = ->
  @get('length')