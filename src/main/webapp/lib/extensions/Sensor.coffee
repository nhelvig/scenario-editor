window.beats.Sensor::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    link = object_with_id.link[@get('link_reference').get('id')]
    @set('link', link)

window.beats.Sensor::point = ->
  p = @get('position').get('point')
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


  sensor.set('lat', row.lat)
  sensor.set('lng', row.lng)
  sensor.set('elevation', 0)

window.beats.Sensor::lat = -> @get('point').get('lat')
window.beats.Sensor::lng = -> @get('point').get('lng')
window.beats.Sensor::elevation = -> @get('point').get('elevation')
window.beats.Sensor::display_lat = -> @display_point().get('lat')
window.beats.Sensor::display_lng = -> @display_point().get('lng')
window.beats.Sensor::road_names = -> @get('link').road_names()

window.beats.Sensor::initialize = ->
  @set('position', new window.beats.Position)

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

  ### TODO set display_position and parameters ###
  sensor