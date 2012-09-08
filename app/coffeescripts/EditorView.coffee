# This is the super class for the editor dialogs for all elements
class window.sirius.EditorView extends Backbone.View
  $a = window.sirius

  # The options hash contains the type of dialog(eg. 'node'), the model
  # associated with the dialoag, and templateData
  # used to inject into the html template
  initialize: (@options) ->
    @elem = @options.elem
    @model = @options.model
    title  = $a.Util.toStandardCasing(@elem)  # eg. node -> Node
    @$el.attr 'title', "#{title} Editor: #{@model.get('name')}"
    @$el.attr 'id', "#{@elem}-dialog-form-#{@model.cid}"
    @template = _.template($("##{@elem}-editor-dialog-template").html())
    @$el.html(@template(options.templateData))

  # render the dialog box. The calling function has responsability for appending
  # it as well as calling el.tabs and el.diaload('open')
  render: ->
    @$el.dialog
      autoOpen: false,
      width: @options.width,
      modal: false,
      close: =>
        @$el.remove()
    @