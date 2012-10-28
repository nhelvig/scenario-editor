# This manages the views for the node collection
class window.sirius.NodeListView extends Backbone.Collection
  $a = window.sirius
  views : []
  
  # render all the nodes upon map:init and set up the add event
  # for the collection
  initialize: (@collection, @network) ->
    $a.broker.on('map:init', @render, @)
    @collection.on('add', @addNodeView, @)
  
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