class window.sirius.NodeCollection extends Backbone.Collection
  $a = window.sirius
  model: $a.Node
  
  getBrowserColumnData: () ->
    @models.map((node) -> [node.get('id'), node.get('name'),node.get('type')] )