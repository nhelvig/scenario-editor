class window.sirius.NodeListView extends Backbone.Collection
  $a = window.sirius
  views : []
  
  initialize: (@collection, @network) ->
    $a.broker.on('map:init', @render, @)
    @collection.on('add', @addAndRender, @)
  
  addNodeView: (node) ->
    mnv = new $a.MapNodeView(node, @network)
    mnv.render()
    @views.push(mnv)
    mnv
    
  addAndRender: (node) ->
    @addNodeView(node)
  
  render: ->
    @collection.forEach(@addNodeView, @)
    @