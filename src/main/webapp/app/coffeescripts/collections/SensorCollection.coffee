class window.sirius.SensorCollection extends Backbone.Collection
  $a = window.sirius
  model: $a.Sensor
  
  initialize:(@models) ->
    @models.forEach((sensor) -> sensor.set('selected', false))
  
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
  
  setSelected: (sensors) ->
    _.each(sensors, (sensor) ->
      sensor.set('selected', true) if !sensor.get('selected')
    )