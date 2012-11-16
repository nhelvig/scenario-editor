# This manages the views for the node collection
class window.beats.NodeListView extends Backbone.Collection
  $a = window.beats
  views : []
  
  # render all the nodes upon map:init and set up the add event
  # for the collection
  initialize: (@collection, @network) ->
    $a.broker.on('map:init', @render, @)
    @collection.on('add', @addNodeView, @)
    @collection.on('remove', @removeNode, @)
  
  # create node view object and render it when a new node is added to the
  # map
  addNodeView: (node) ->
    mnv = new $a.MapNodeView(node, @network)
    mnv.render()
    @views.push(mnv)
    mnv
  
  # renders all the nodes in the collection by calling addNodeView
  render: ->
    @collection.forEach(@addNodeView, @)
    @
  
  # this removes the node from the views array upon removal from collection
  removeNode: (node) ->
    @views = _.reject(@views, (view) => view.model is node)
