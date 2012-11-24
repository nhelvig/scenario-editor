# This class is used to manage our sensor models.
class window.beats.SensorListCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Sensor
  
  # when initialized go through the models and set selected to false
  initialize:(@models) ->
    @models.forEach((sensor) => @_setUpEvents(sensor))
    $a.broker.on("map:clear_map", @clear, @)
    $a.broker.on('sensors:add', @addSensor, @)

  
  # the sensor browser calls this to gets the column data for the table
  getBrowserColumnData: () ->
    @models.map((sensor) -> 
            [
              sensor.get('id'), 
              sensor.get('type'), 
              sensor.get('link_type'),
              sensor.get('link_reference')?.get('id') || ''
            ]
    )
  
  # this sets all the passed in sensors' selected field to true. It syncs
  # the map sensors selected with selected sensors in the table
  setSelected: (sensors) ->
    _.each(sensors, (sensor) ->
      sensor.set('selected', true) if !sensor.get('selected')
    )
  
  # addSensor creates a sensor of type and the at the position passed in and adds
  # it to the collection as well as to the models schema. 
  # It is called from the context menu's add sensor event
  addSensor: (position, type) ->
    s = new $a.Sensor()
    p = new $a.Position()
    pt = new $a.Point()
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
    s.set('type', type || 'static_point')
    @add(s)
    $a.models.sensors().push(s)
    @_setUpEvents(s)
    s
    
  # This method sets up the events each sensor should listen too
  _setUpEvents: (sensor) ->
    sensor.bind('remove', => @destroy)
    sensor.set('selected', false)
  
  #this method clears the collection upon a clear map
  clear: ->
    $a.sensorList = {}