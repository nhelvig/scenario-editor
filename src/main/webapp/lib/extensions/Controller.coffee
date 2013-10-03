$a = window.beats

window.beats.Controller::initialize = ->
  @set 'parameters', {}

window.beats.Controller::selected = -> @get('selected')
window.beats.Controller::name = -> @get('name')

window.beats.Controller::from_position = (position, link) ->
  c = new window.beats.Controller
  p = new window.beats.DisplayPosition()
  pt = new window.beats.Point()
  pt.set(
          { 
            'lat':position.lat(),
            'lng':position.lng(),
            'elevation':''
          }
        )
  p.set('point', []) 
  p.get('point').push(pt)
  c.set('display_position', p)
  c.set('type', '')
  if link?
    s = new window.beats.ScenarioElement({type:'link', id:link.ident()})
    t = new window.beats.TargetElements({scenarioelement: [s]})
    c.set('targetelements', t)
  c

window.beats.Controller::display_point = ->
  display_position = @get('display_position')
  if(not @has('display_position'))
    display_position = new $a.Display_position()
    @set 'display_position', display_position
    p = new $a.Point()
    display_position.get('point').push(p)
    pos_elt = null
    if(@has('link'))
      pos_elt = @get('link').get('begin').get('node')
    else if(@has('node'))
      pos_elt = @get('node')
    else if(network)
      pos_elt = @get('network')

    if(pos_elt and pos_elt.has('position') and
       pos_elt.get('position').has('point') and
       pos_elt.get('position').get('point')[0])
      elt_pt = pos_elt.get('position').get('point')[0]
      p.set 'lat', elt_pt.get('lat')
      p.set 'lng', elt_pt.get('lng')
    else
      p.set 'lat', 0
      p.set 'lng', 0

  display_position.get('point')[0]

window.beats.Controller::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    @set 'id', @get('id')
    @set('targetreferences',[]);
    if @get('targetelements')?
      _.each(@get('targetelements').get('scenarioelement'), (e) =>
        switch e.get('type')
          when 'link' then @get('targetreferences').push object_with_id.link[e.id]
          when 'node' then @get('targetreferences').push object_with_id.node[e.id]
          when 'controller' then @get('targetreferences').push object_with_id.controller[e.id]
          when 'sensor' then @get('targetreferences').push object_with_id.sensor[e.id]
          when 'event' then @get('targetreferences').push object_with_id.event[e.id]
          when 'signal' then @get('targetreferences').push object_with_id.signal[e.id]
      )

    # if @get('targetreferences').length == 0
    #    throw "Event must have target elements defined"

window.beats.Controller::encode_references = ->
  # TODO : do we to encode references? All the data will be written back via 
  # scenarioElements
  # @set('node_id', @get('node').id) if @has('node')
  # @set('link_id', @get('link').id) if @has('link')
  # @set('network_id', @get('network').id) if @has('network')

window.beats.Controller::remove = ->
  controllers = window.beats.models.controllers() 
  controllers = _.reject(controllers, (c) => c is @)
  window.beats.models.set_controllers(controllers)

window.beats.Controller::add = ->
  window.beats.models.controllers().push(@)  

# Return list of target elements
window.beats.Controller::get_target_elements = ->
  @get('targetelements')

# Return list of feedback elements
window.beats.Controller::get_feedback_elements = ->
  @get('feedbackelements')
  
window.beats.Controller::updatePosition = (pos) ->
  @display_point().set({'lat':pos.lat(), 'lng':pos.lng()})