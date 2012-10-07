class window.sirius.NodeListView extends Backbone.Collection
  $a = window.sirius
  
  initialize: (@collection, @network) ->
    @collection.on('add', @addOne, @)
  
  addOne: (node) ->
    new $a.MapNodeView(node, @network)
    
  render: ->
    @collection.forEach(@addOne, @)