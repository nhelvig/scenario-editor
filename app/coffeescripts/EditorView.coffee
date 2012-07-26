# This is the super class for the editor dialogs for all elements
class window.sirius.EditorView extends Backbone.View
  $a = window.sirius
  
  # The options hash contains the type of dialog(eg. 'node'), the model
  # associated with the dialoag, and templateData
  # used to inject into the html template 
  initialize: (options) ->
    @elem = options.elem
    @model = options.model
    # takes the options.elem (eg. 'node','signal', 'link') and capitalizes
    # the first letter, lower cases the rest and will handle multiple words if needed
    # It is used to create the title for dialog box
    title = (word[0].toUpperCase() + word[1..].toLowerCase() for word in @elem.split /\s+/).join ' '
    @$el.attr 'title', "#{title} Editor: #{@model.get('name')}"
    @$el.attr 'id', "#{@elem}-dialog-form-#{@model.cid}"
    @template = _.template($("##{@elem}-editor-dialog-template").html())
    @$el.html(@template(options.templateData))
  
  # render the dialog box. The calling function has responsability for appending it as well as
  # calling el.tabs and el.diaload('open')
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
    