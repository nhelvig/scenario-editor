class window.sirius.NodeListView extends Backbone.Collection
  $a = window.sirius
  
  initialize: (@collection, @network) ->
    @collection.on('add', @addAndRender, @)
  
  addOne: (node) ->
    @mnv = new $a.MapNodeView(node, @network)
    
  addAndRender: (node) ->
    @addOne(node)
    @mnv.render()
  
  render: ->
    @collection.forEach(@addOne, @)
    @