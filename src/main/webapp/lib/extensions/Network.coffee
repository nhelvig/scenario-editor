window.beats.Network::defaults =
  ml_control: false
  q_control: false
  dt: 300

window.beats.Network::initialize = ->
  @set 'nodelist', new window.beats.NodeList
  @set 'linklist', new window.beats.LinkList
  @set 'controllerset', new window.beats.ControllerSet
  @set 'description', new window.beats.Description
  @set 'position', new window.beats.Position
  @get('position').get('point').push(new window.beats.Point)

window.beats.Network::nodes = -> 
  @get('nodelist')?.get('node') || []

window.beats.Network::links = ->
  @get('linklist')?.get('link') || []

window.beats.Network::name = ->
  @get('name')

window.beats.Network::set_name = (s) ->
  @set('name',s)

window.beats.Network::description_text = ->
  @get('description')?.get('text')

window.beats.Network::set_description_text = (s) ->
  description = new window.beats.Description()
  description.set('text',s)
  @set('description',description)

window.beats.Network::locked_for_edit = ->
  @get('lockedForEdit')

window.beats.Network::set_locked_for_edit = (s) ->
  @set('lockedForEdit',(s.toString().toLowerCase() == 'true') if s?)

window.beats.Network::locked_for_history = ->
  @get('lockedForHistory')

window.beats.Network::set_locked_for_history = (s) ->
  @set('lockedForHistory',(s.toString().toLowerCase() == 'true') if s?)

window.beats.Network::set_position = (lat,lng) ->
  @get('position').get('point')[0].set('lat', lat)
  @get('position').get('point')[0].set('lng', lng)

window.beats.Network::position = -> @get('position')

window.beats.Network::ident = -> @get('id')

window.beats.Network::set_id = (id) ->
  @set('id', id)

window.beats.Network::set_editor_show = (flag) ->
  @set('editor_show', flag)