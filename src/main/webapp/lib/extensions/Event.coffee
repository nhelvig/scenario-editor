
window.beats.Event::selected = -> @get('selected')
window.beats.Event::name = -> @get('name')

window.beats.Event::from_position = (position, link) ->
  e = new window.beats.Event
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
  e.set('display_position', p)
  e.set('type', '')
  if link?
    s = new window.beats.ScenarioElement({type:'link', id:link.ident()})
    t = new window.beats.TargetElements({scenarioelement: [s]})
    e.set('targetelements', t)
  e

window.beats.Event::display_point = ->
  display_position = @get('display_position')
  if not display_position
    display_position = new window.beats.Display_position()
    p = new window.beats.Point()
    display_position.get('point').push(p)

    pos_elt = null
    if @has('link')
      pos_elt = @get('link').get('begin').get('node')
    else if @has('node')
      pos_elt = @get('node')
    else if @has('network')
      pos_elt = @get('network')

    if pos_elt
      elt_pt = pos_elt.get('position').get('point')[0]
      p.set 'lat', elt_pt.get('lat')
      p.set 'lng', elt_pt.get('lng')
    else
      p.set 'lat', 0
      p.set 'lng', 0

  display_position.get('point')[0]

window.beats.Event::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
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
    #
    # if @get('targetreferences').length == 0
    #    throw "Event must have target elements defined"

window.beats.Event::encode_references = ->
  # TODO : do we to encode references? All the data will be written back via scenarioElements
  # @set('node_id', @get('node').id) if @has('node')
  # @set('link_id', @get('link').id) if @has('link')
  # @set('network_id', @get('network').id) if @has('network')
  
# Return list of target elements
window.beats.Event::get_target_elements = ->
  @get('targetelements')

window.beats.Event::add = ->
  window.beats.models.events().push(@)  

window.beats.Event::remove = ->
  events = window.beats.models.events()
  events = _.reject(events, (e) => e is @)
  window.beats.models.set_events(events)

window.beats.Event::updatePosition = (pos) ->
  @display_point().set({'lat':pos.lat(), 'lng':pos.lng()})