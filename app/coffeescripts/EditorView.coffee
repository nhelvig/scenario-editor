# This creates the editor dialogs for all elements
class window.sirius.EditorView extends Backbone.View
  $a = window.sirius
    
  initialize: (options) ->
    @elem = options.elem
    @model = options.model
    title = (word[0].toUpperCase() + word[1..].toLowerCase() for word in @elem.split /\s+/).join ' '
    @$el.attr 'title', "#{title} Editor: #{@model.get('name')}"
    @$el.attr 'id', "#{@elem}-dialog-form-#{@model.cid}"
    # the options.template is only used during testing
    @template = _.template(options.template || $("##{@elem}-editor-dialog-template").html())
    @$el.html(@template(options.templateData))
  
  render: ->
    @$el.dialog({
          autoOpen: false,
          height: 360,
          width: 275,
          modal: false,
          close: =>
            @$el.remove()
          
        })
    @
    