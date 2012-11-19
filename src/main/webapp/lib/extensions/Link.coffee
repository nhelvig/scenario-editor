window.beats.Link::defaults =
  type: 'ST'
  lanes: 1
  lane_offset: 0
  record: true

window.beats.Link::initialize = ->
  @set('dynamics', new window.beats.Dynamics())

window.beats.Link::parallel_links = ->
  begin_node = @get('begin').get('node')
  end_node = @get('end').get('node')

  _.map(_.filter(begin_node.get('outputs').get('output'),
    (output) =>
      link2 = output.get('link')
      link2 isnt this and link2.get('end').get('node') is end_node
  ), (output) -> output.get('link'))


window.beats.Link::get_road_names = ->
  _.map(@get('roads').get('road'), (r) -> r.get('name')).join(", ")

window.beats.Link::begin_node = ->
  @get('begin').get('node')

window.beats.Link::end_node = ->
  @get('end').get('node')
