window.beats.Sensor::defaults =
  type: ''
  parameters: {}

window.beats.Sensor::initialize = ->
  @set('display_position', new window.beats.DisplayPosition)

# called by sensor editor to save individual lat, lng, elevation fields
window.beats.Sensor::set_display_position = (pointField, val) -> 
  @get('display_position').get('point')[0].set(pointField, val)

window.beats.Sensor::updatePosition = (pos) ->
  @display_point().set({'lat':pos.lat(), 'lng':pos.lng()})

window.beats.Sensor::point = ->
  p = @get('display_position').get('point')
  p.push(new window.beats.Point) unless p[0]
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

window.beats.Sensor::display_lat = -> @display_point().get('lat')
window.beats.Sensor::display_lng = -> @display_point().get('lng')
window.beats.Sensor::display_elev = -> @display_point().get('elevation')

window.beats.Sensor::parameters = -> @get('parameters')
window.beats.Sensor::set_parameters = (p) -> @set('parameters', p)

window.beats.Sensor::table = -> @get('table')
window.beats.Sensor::set_table = (t) -> @set('table', t)

window.beats.Sensor::ident = -> @get('id')
window.beats.Sensor::set_id = (id) -> @set('id', id)

window.beats.Sensor::crud = -> @get 'crudFlag'
window.beats.Sensor::set_crud = (flag) ->
  if @crud() != window.beats.CrudFlag.CREATE
    @set 'crudFlag', flag

window.beats.Sensor::sensor_type = -> @get("sensor_type")
window.beats.Sensor::type_id = -> @get("sensor_type").ident() if @get("sensor_type")?
window.beats.Sensor::type_name = -> @get("sensor_type").name() if @get("sensor_type")?
window.beats.Sensor::set_type = (id, name) ->
  @set('sensor_type', new window.beats.SensorType)  if not @get('sensor_type')?
  @get("sensor_type").set_name(name)
  @get("sensor_type").set_id(id)
  @defaults['sensor_type'] = id

window.beats.Sensor::link_position = -> @get('link_position')
window.beats.Sensor::set_link_position = (lp) -> @set('link_position',lp)

window.beats.Sensor::link_id = -> @get('link_id')
window.beats.Sensor::set_link_id = (lid) -> @set('link_id',lid)
window.beats.Sensor::link_reference = -> @get('link_reference')
window.beats.Sensor::set_link_reference = (link) ->
  @set('link_reference', link)

window.beats.Sensor::resolve_references = (deferred, object_with_id) ->
  if object_with_id.link?
    deferred.push =>
      link = object_with_id.link[@link_id()]
      @set('link_reference', link)
window.beats.Sensor::road_names = -> @get('link_reference')?.link_name() || ''

window.beats.Sensor::sensor_id_original = -> @get('sensor_id_original')
window.beats.Sensor::set_sensor_id_original = (sid) -> 
  @set('sensor_id_original', sid)

window.beats.Sensor::data_feed_id = -> @get('data_feed_id')
window.beats.Sensor::set_data_feed_id = (did) -> 
  @set('data_feed_id', did)

window.beats.Sensor::lane_number = -> @get('lane_number')
window.beats.Sensor::set_lane_number = (num) -> @set('lane_number',num)

window.beats.Sensor::link_offset = -> @get('link_offset')
window.beats.Sensor::set_link_offset = (offset) -> @set('link_offset', offset)

window.beats.Sensor::health_status = -> @get('health_status')
window.beats.Sensor::set_health_status = (stat) -> @set('health_status', stat)

window.beats.Sensor::selected = -> @get('selected')

window.beats.Sensor::from_position = (position, link) ->
  s = new window.beats.Sensor
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
  s.set('display_position', p)
  # if link reference is passed in, set link id
  if link?
    s.set('link_id', link.ident())
    s.set('link_reference', link)
  s

window.beats.Sensor.from_station_row = (row) ->
  sensor = new window.beats.Sensor
    description: new window.beats.Description(text: row.description)
    type: row.type
    link_type: row.link_type
    links: null
    lat: row.lat
    lng: row.lng
    elevation: 0
    display_position: new window.beats.DisplayPosition()

  sensor.set('link_type', 'HOV') if row.link_type is 'HV'
  sensor.set('link_type', 'FW') if row.link_type is 'ML'

  sensor.set('lat', row.lat)
  sensor.set('lng', row.lng)
  sensor.set('elevation', 0)
  ### TODO set display_position and parameters ###
  sensor

window.beats.Sensor::remove = ->
  sensors = window.beats.models.sensors()
  sensors = _.reject(sensors, (s) => s is @)
  window.beats.models.set_sensors(sensors)
  window.beats.models.sensor_set().set_crud(window.beats.CrudFlag.UPDATE)

window.beats.Sensor::add = ->
  window.beats.models.sensors().push(@)
  window.beats.models.sensor_set().set_crud(window.beats.CrudFlag.UPDATE)

window.beats.Sensor::set_generic = (id, val) -> 
  @set(id, val)
  @defaults[id] = val

window.beats.Sensor::editor_show = ->
  @get('editor_show')

window.beats.Sensor::set_editor_show = (flag) ->
  @set('editor_show', flag)