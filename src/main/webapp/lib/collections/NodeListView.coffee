# This manages the views for the node collection
class window.beats.NodeListView extends Backbone.Collection
  $a = window.beats
  views : []
  
  broker_events : {
    'map:clear_map' : 'clear'
    'map:init' : 'render'
  }
  
  collection_events : {
    'add' : 'addNodeView'
    'remove' : 'removeNode'
  }
  
  # render all the nodes upon map:init and set up the add event
  # for the collection
  initialize: (@collection, @network) ->
    google.maps.event.addListener($a.map, 'zoom_changed', => @setNodeSize())
    $a.Util.publishEvents($a.broker, @broker_events, @)
    $a.Util.publishEvents(@collection, @collection_events, @)
  
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
    $a.Util.unpublishEvents($a.broker, @broker_events, @)
    $a.Util.unpublishEvents(@collection, @collection_events, @)
  
  # renders all the nodes in the collection by calling addNodeView
  render: ->
    @collection.forEach(@addNodeView, @)
    @
  
  # this removes the node from the views array upon removal from collection
  removeNode: (node) ->
    @views = _.reject(@views, (view) => view.model.id is node.id)

  # set the size of all node icons based on the zoom level
  setNodeSize: ->
    _.each(@views, (view) -> 
      view.marker.setIcon(view.icon()) if view.marker?
    )