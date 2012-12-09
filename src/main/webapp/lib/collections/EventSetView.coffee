# This manages the views for the event collection
class window.beats.EventSetView extends Backbone.Collection
  $a = window.beats
  views : []
  
  # render all the events upon map:init and set up the add and remove event
  # for the collection
  initialize: (@collection) ->
    $a.broker.on("map:clear_map", @clear, @)
    $a.broker.on('map:init', @render, @)
    @collection.on('add', @addEventView, @)
    @collection.on('remove', @removeEvent, @)
  
  # create event view object and render it when a new event is 
  # added to the map
  addEventView: (event) ->
    mev = new $a.MapEventView(event)
    mev.render()
    @views.push(mev)
    mev
  
  #this method clears the collection upon a clear map
  clear: ->
    $a.eventSetView = {}
  
  # renders all the event in the collection by calling addEventView
  render: ->
    @collection.forEach(@addEventView, @)
    @
  
  # this removes the event from the views array upon removal from collection
  removeEvent: (event) ->
    @views = _.reject(@views, (view) => view.model is event)