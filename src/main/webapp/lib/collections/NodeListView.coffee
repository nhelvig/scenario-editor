# This manages the views for the node collection
class window.beats.NodeListView extends Backbone.Collection
  $a = window.beats
  views : []
  
  # render all the nodes upon map:init and set up the add event
  # for the collection
  initialize: (@collection, @network) ->
    $a.broker.on("map:clear_map", @clear, @)
    $a.broker.on('map:init', @render, @)
    google.maps.event.addListener($a.map, 'zoom_changed', => @setNodeSize())
    @collection.on('add', @addNodeView, @)
    @collection.on('remove', @removeNode, @)
  
  # create node view object and render it when a new node is added to the
  # map
  addNodeView: (node) ->
    mnv = new $a.MapNodeView(node, @network)
    mnv.render()
    @views.push(mnv)
    mnv
  
  #this method clears the collection upon a clear map
  clear: ->
    $a.nodeListView = {}
  
  # renders all the nodes in the collection by calling addNodeView
  render: ->
    @collection.forEach(@addNodeView, @)
    @
  
  # this removes the node from the views array upon removal from collection
  removeNode: (node) ->
    @views = _.reject(@views, (view) => view.model is node)

  # set the size of all node icons based on the zoom level
  setNodeSize: ->
    _.each(@views, (view) -> 
      view.marker.setOptions(icon: {scaledSize:view.getScaledSize()}) if view.marker?
    )