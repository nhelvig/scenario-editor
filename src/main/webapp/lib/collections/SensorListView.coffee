# This manages the views for the sensor collection
class window.beats.SensorListView extends Backbone.Collection
  $a = window.beats
  views : []
  
  # render all the sensors upon map:init and set up the add and remove event
  # for the collection
  initialize: (@collection) ->
    $a.broker.on("map:clear_map", @clear, @)
    $a.broker.on('map:init', @render, @)
    @collection.on('add', @addSensorView, @)
    @collection.on('remove', @removeSensor, @)
  
  # create sensor view object and render it when a new sensor is added to the
  # map
  addSensorView: (sensor) ->
    msv = new $a.MapSensorView(sensor)
    msv.render()
    @views.push(msv)
    msv
  
  #this method clears the collection upon a clear map
  clear: ->
    $a.sensorListView = {}
  
  # renders all the sensors in the collection by calling addSensorView
  render: ->
    @collection.forEach(@addSensorView, @)
    @
  
  # this removes the sensor from the views array upon removal from collection
  removeSensor: (sensor) ->
    @views = _.reject(@views, (view) => view.model is sensor)