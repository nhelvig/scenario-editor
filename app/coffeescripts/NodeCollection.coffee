class window.sirius.NodeCollection extends Backbone.Collection
  $a = window.sirius
  model: $a.Node
  
  initialize:(@models) ->
    @models.forEach((node) -> node.set('selected', false))
  
  getBrowserColumnData: () ->
    @models.map((node) -> [node.get('id'), node.get('name'),node.get('type')])
  
  setSelected: (nodes) ->
    _.each(nodes, (node) ->
      node.set('selected', true) if !node.get('selected')
    )