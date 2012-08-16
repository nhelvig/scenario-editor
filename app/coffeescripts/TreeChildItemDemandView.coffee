class window.sirius.TreeChildItemDemandView extends window.sirius.TreeChildItemLinkView
  initialize: (model, targets, name, element) ->
    super(model, targets, name, element)
    @model.set('contextMenu', $a.demand_context_menu)

  setUpEvents: ->
    window.sirius.broker.on("demand:show_dialog:#{@model.id}", @render, @)
    super(@model.link)

  render: (demandView) ->
    console.log(demandView.model)