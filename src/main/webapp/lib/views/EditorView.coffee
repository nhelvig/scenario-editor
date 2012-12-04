# This is the super class for the editor dialogs for all elements
class window.beats.EditorView extends Backbone.View
  $a = window.beats

  # The options hash contains the type of dialog(eg. 'node'), the model
  # associated with the dialoag, and templateData
  # used to inject into the html template
  initialize: (@options) ->
    @elem = @options.elem
    @models = @options.models
    title  = $a.Util.toStandardCasing(@elem)  # eg. node -> Node
    subtitle = if (typeof @models[0].road_names == 'function') then @models[0].road_names() else ""
    @$el.attr 'title', "#{title} Editor: #{subtitle}"
    @$el.attr 'id', "#{@elem}-dialog-form-#{@models[0].cid}"
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
    $a.broker.on('click', @minimize, @)
    @ 

  # Return the editor view DOM element
  getEditorElement: ->
    @$el

    # Remove on-click event from browser header to maximize window
    @$el.dialog.off('click')

  # Called after edit button on target or feedback scenario element
  # tables has been clicked - Allows for scenario elements to be
  # added or deleted
  editScenarioElements: () ->
    @minimize()
    @