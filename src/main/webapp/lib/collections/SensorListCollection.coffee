# This class is used to manage our sensor models.
class window.sirius.SensorListCollection extends Backbone.Collection
  $a = window.sirius
  model: $a.Sensor
  
  # when initialized go through the models and set selected to false
  initialize:(@models) ->
    @models.forEach((sensor) -> sensor.set('selected', false))
  
  # the sensor browser calls this to gets the column data for the table
  getBrowserColumnData: () ->
    @models.map((sensor) -> 
            [
              sensor.get('id'), 
              sensor.get('type'), 
              sensor.get('link_type'),
              sensor.get('link_reference').get('id'),
              sensor.get('description').get('text')
            ]
    )
  
  # this sets all the passed in sensors' selected field to true. It syncs
  # the map sensors selected with selected sensors in the table
  setSelected: (sensors) ->
    _.each(sensors, (sensor) ->
      sensor.set('selected', true) if !sensor.get('selected')
    )