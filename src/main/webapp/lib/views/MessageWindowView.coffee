# This creates a modal message window, used for Ajax calls you wish to be synchronous
# Or error messages on callback (set OK button to true)
class window.beats.MessageWindowView extends Backbone.View
  $a = window.beats

  # The options hash contains the the model
  # associated with the dialog, and templateData
  # used to inject into the html template
  initialize: (@options) ->
    displayText  = $a.Util.toStandardCasing(@options.text)  # eg. node -> Node
    @$el.attr 'title', "Message Box"
    @$el.attr 'id', "message-dialog"
    @template = _.template($("#message-window-template").html())
    @$el.html(@template({text: displayText}))  
    $a.broker.on("app:loading_complete", @close)
    @render(@options.okButton)
    @$el.dialog('open')

  # render the dialog box.
  # it as well as calling el.tabs and el.diaload('open')
  render: (okButton) ->
    @$el.dialog
      autoOpen: false,
      modal: true,
      closeOnEscape: false,
      minHeight: 100,
      open: ->
        $('.ui-state-default').blur() #hack to get ui dialog focus bug
      close: =>
        @$el.remove()
      buttons:
        # add Ok Button if OkButton parameter is true
        if okButton
          "Ok": () ->
            $a.broker.trigger('app:loading_complete')
    $('.ui-dialog-titlebar-close').css('visibility', 'hidden')


  # Close dialog box after loading
  close: ->
    $('#message-dialog').remove()