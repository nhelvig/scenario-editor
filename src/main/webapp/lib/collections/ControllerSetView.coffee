# This manages the views for the controller collection
class window.beats.ControllerSetView extends Backbone.Collection
  $a = window.beats
  views : []
  
  # render all the controllers upon map:init and set up the add and remove event
  # for the collection
  initialize: (@collection) ->
    $a.broker.on("map:clear_map", @clear, @)
    $a.broker.on('map:init', @render, @)
    @collection.on('add', @addControllerView, @)
    @collection.on('remove', @removeController, @)
  
  # create controller view object and render it when a new controller is 
  # added to the map
  addControllerView: (controller) ->
    mcv = new $a.MapControllerView(controller)
    mcv.render()
    @views.push(mcv)
    mcv
  
  #this method clears the collection upon a clear map
  clear: ->
    $a.controllerSetView = {}
  
  # renders all the controllers in the collection by calling addControllerView
  render: ->
    @collection.forEach(@addControllerView, @)
    @
  
  # this removes the controller from the views array upon removal from collection
  removeController: (controller) ->
    @views = _.reject(@views, (view) => view.model is controller)