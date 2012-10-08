class window.sirius.NodeListView extends Backbone.Collection
  $a = window.sirius
  views : []
  
  initialize: (@collection, @network) ->
    @collection.on('add', @addAndRender, @)
  
  addOne: (node) ->
    mnv = new $a.MapNodeView(node, @network)
    @views.push(mnv)
    mnv
    
  addAndRender: (node) ->
    @addOne(node).render()
  
  render: ->
    @collection.forEach(@addOne, @)
    @