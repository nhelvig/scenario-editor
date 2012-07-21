class window.sirius.NodesCollection extends Backbone.Collection
  $a = window.sirius
  model : $a.Node
  
  initialize: ->
    $a.broker.on('scenario:save', @save, @)
  
  save: ->
    _.each(@models, (model) -> model.to_xml())