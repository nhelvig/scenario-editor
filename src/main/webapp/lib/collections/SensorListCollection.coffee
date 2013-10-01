# This class is used to manage our sensor models.
class window.beats.SensorListCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Sensor
  
  # when initialized go through the models and set selected to false
  initialize:(@models) ->
    @models.forEach((sensor) => @_setUpEvents(sensor))
    $a.broker.on("map:clear_map", @clear, @)
    $a.broker.on('sensors:add', @addSensorWithPositionLink, @)
    $a.broker.on('sensors:add_sensor', @addSensor, @)
    @on('sensors:attach_to_link', @attachToLink, @)
    @on('sensors:remove', @removeSensor, @)
  
  # the sensor browser calls this to gets the column data for the table
  getBrowserColumnData: () ->
    @models.map((sensor) -> 
            [
              sensor.ident(), 
              sensor.type_name(),
              sensor.link_reference()?.type_name(),
              sensor.link_reference()?.ident() || ''
            ]
    )
  
  # this sets all the passed in sensors' selected field to true. It syncs
  # the map sensors selected with selected sensors in the table
  setSelected: (sensors) ->
    _.each(sensors, (sensor) ->
      sensor.set('selected', true) if !sensor.get('selected')
    )
  
  # removeSensor removes this sensor from the collection and takes it off the 
  # map.
  removeSensor: (sID) ->
    sensor = @getByCid(sID) 
    @remove(sensor)
  
  # addSensorWithPositionLink creates a sensor at the position passed in and
  # adds it to the collection as well as to the models schema. 
  # It is called from the context menu's add sensor event as well as triggered
  # when a sensor is added to a link. If link is null it will add sensor
  # at position with no link attached; otherwise it attaches the link to the 
  # sensor
  addSensorWithPositionLink: (position, link) ->
    s = new $a.Sensor().from_position(position, link)
    # set crudflag to indicate sensor has been added
    s.set_crud_flag($a.CrudFlag.CREATE)
    @_setUpEvents(s)
    @add(s)
    s

  # addSensor add this sensor model object to the SensorCollection as well as 
  # to the model's schema. It is placed on the map using the display_position.
  # The function can be used whenever a sensor is already encapsulated as a 
  # Sensor Model Object needs to placed on the map 
  addSensor: (sensor) ->
    # set crudflag to indicate sensor has been added
    sensor.set_crud_flag($a.CrudFlag.CREATE)
    @_setUpEvents(sensor)
    @add(sensor)
    sensor
    
  # Attach Sensor to Link on map
  attachToLink: (sID) ->
    # get selected sensor
    sensor = @getByCid(sID)
    # now find selected link
    link = $a.linkList.getSelected()
    # if a link was selected, set it as reference
    if link
      sensor.set_link_reference(link)
      sensor.set_link_id(link.ident())


  # This method sets up the events each sensor should listen too
  _setUpEvents: (sensor) ->
    sensor.bind('remove', =>
                            sensor.remove()
                            @destroy
                      )
    sensor.bind('add', => sensor.add())
    sensor.set('selected', false)
  
  #this method clears the collection upon a clear map
  clear: ->
    @remove(@models)
    $a.sensorList = {}
    $a.broker.off('sensors:add')
    @off(null, null, @)