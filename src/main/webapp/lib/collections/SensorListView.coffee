# This manages the views for the sensor collection
class window.beats.SensorListView extends Backbone.Collection
  $a = window.beats
  views : []
  
  broker_events : {
    'map:clear_map' : 'clear'
    'map:init' :  'render'
  }
  
  collection_events : {
    'add' : 'addSensorView'
    'remove' : 'removeSensor'
  }
  
  view_events : {
   'sensors:selectSelfAndConnected' : 'selectSelfAndConnected'
   'sensors:clearSelfAndConnected' : 'clearSelfAndConnected'
  }

  # render all the sensors upon map:init and set up the add and remove event
  # for the collection
  initialize: (@collection) ->
    $a.Util.publishEvents($a.broker, @broker_events, @)
    $a.Util.publishEvents(@collection, @collection_events, @)
    $a.Util.publishEvents(@, @view_events, @)
  
  # create sensor view object and render it when a new sensor is added to the
  # map
  addSensorView: (sensor) ->
    msv = new $a.MapSensorView(sensor)
    msv.render()
    @views.push(msv)
    msv
  
  #this method clears the collection upon a clear map
  clear: ->
    $a.Util.unpublishEvents(@, @view_events, @)
    $a.Util.unpublishEvents(@collection, @collection_events, @)
    $a.Util.unpublishEvents($a.broker, @broker_events, @)
    $a.sensorListView = {}
  
  # renders all the sensors in the collection by calling addSensorView
  render: ->
    @collection.forEach(@addSensorView, @)
    @
  
  # this removes the sensor from the views array upon removal from collection
  removeSensor: (sensor) ->
    @views = _.reject(@views, (view) => view.model.id is sensor.id)
  
  # this first finds the view object and then calls the method to set the 
  # sensor selected and its links
  selectSelfAndConnected: (sID) ->
    sView = _.find(@views, (view) -> view.model.cid is sID)
    sView.selectSelfandMyLinks()
    
  # this first finds the view object and then calls the method to de-select the
  # sensor and its links
  clearSelfAndConnected: (sID) ->
    sView = _.find(@views, (view) -> view.model.cid is sID)
    sView.clearSelfandMyLinks()