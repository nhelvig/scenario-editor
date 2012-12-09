window.beats.Sensor::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    link = object_with_id.link[@get('link_reference').get('id')]
    @set('link', link)

window.beats.Sensor::point = ->
  p = @get('display_position').get('point')
  p.push(new Point) unless p[0]
  p[0]

window.beats.Sensor::display_point = ->
  if @has('display_position')
    p = @get('display_position').get('point')[0]
    if not p
      p = new window.beats.Point
      p.set('lat', @get('lat'))
      p.set('lng', @get('lng'))
      @get('display_position').get('point').push(p)
    p
  else
    @get('point')

window.beats.Sensor::ident = -> @get('id')
window.beats.Sensor::type = -> @get('type')
window.beats.Sensor::link = -> @get('link')
window.beats.Sensor::link_reference = -> @get('link_reference')
window.beats.Sensor::selected = -> @get('selected')
window.beats.Sensor::lat = -> @get('point').get('lat')
window.beats.Sensor::lng = -> @get('point').get('lng')
window.beats.Sensor::elevation = -> @get('point').get('elevation')
window.beats.Sensor::display_lat = -> @display_point().get('lat')
window.beats.Sensor::display_lng = -> @display_point().get('lng')
window.beats.Sensor::display_elev = -> @display_point().get('elevation')
window.beats.Sensor::road_names = -> @get('link')?.road_names() || ''

window.beats.Sensor::set_link_reference = (id) -> 
  @get('link_reference').set('id', id)

# called by sensor editor to save individual lat, lng, elevation fields
window.beats.Sensor::set_display_position = (pointField, val) -> 
  @get('display_position').get('point')[0].set(pointField, val)

window.beats.Sensor::initialize = ->
  @set('display_position', new window.beats.Display_position)

window.beats.Sensor::from_position = (position, link) ->
  s = new window.beats.Sensor
  p = new window.beats.Display_position()
  pt = new window.beats.Point()
  pt.set(
          { 
            'lat':position.lat(),
            'lng':position.lng(),
            'elevation':NaN
          }
        )
  p.set('point', []) 
  p.get('point').push(pt)
  s.set('display_position', p)
  s.set('type', 'static_point')
  s.set('link', link || null)
  id = link?.ident() || null
  s.set('link_reference', new window.beats.Link_reference().set('id', id))
  s

window.beats.Sensor::defaults =
  parameters: {}

window.beats.Sensor.from_station_row = (row) ->
  sensor = new window.beats.Sensor
    description: new window.beats.Description(text: row.description)
    type: row.type
    link_type: row.link_type
    links: null
    lat: row.lat
    lng: row.lng
    elevation: 0
    display_position: new window.beats.Display_position()

  sensor.set('link_type', 'HOV') if row.link_type is 'HV'
  sensor.set('link_type', 'FW') if row.link_type is 'ML'

  sensor.set('lat', row.lat)
  sensor.set('lng', row.lng)
  sensor.set('elevation', 0)
  ### TODO set display_position and parameters ###
  sensor

window.beats.Sensor::updatePosition = (pos) ->
  @display_point().set({'lat':pos.lat(), 'lng':pos.lng()})

window.beats.Sensor::remove = ->
  sensors = window.beats.models.sensors()
  sensors = _.reject(sensors, (s) => s is @)
  window.beats.models.set_sensors(sensors)

window.beats.Sensor::add = ->
  window.beats.models.sensors().push(@)