window.beats.Network::defaults =
  ml_control: false
  q_control: false
  dt: 300

window.beats.Network::initialize = ->
  @set 'nodelist', new window.beats.NodeList
  @set 'linklist', new window.beats.LinkList
  @set 'controllerset', new window.beats.ControllerSet
  @set 'description', new window.beats.Description
  @set 'intersectioncache', new window.beats.IntersectionCache
  @set 'position', new window.beats.Position
  @get('position').get('point').push(new window.beats.Point)

window.beats.Network::description_text = ->
  @get('description').get('text')

window.beats.Network::set_description_text = (s) ->
  @get('description').set('text',s)