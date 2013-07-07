# This class creates the warnings panel and controls its display
class window.beats.MessagePanelView extends Backbone.View
  $a = window.beats
  className: 'alert alert-bottom close'
  
  broker_events : {
    'app:show_message:success' : 'success'
    'app:show_message:error' : 'error'
    'app:show_message:info' : 'info'
    'app:display_message:success' : 'displaySuccess'
    'app:display_message:error' : 'displayError'
    'app:display_message:info' : 'displayInfo'
  }
 
  initialize: ->
    @fadeMessages = []
    @staticMessage = {}
    @template = _.template($('#message-panel-template').html())
    $a.Util.publishEvents($a.broker, @broker_events, @)
    @render()

  render: ->
    $('#map_canvas').append(@el)
  
  _message: (message, type) -> 
    @$el.addClass "#{type}"
    @$el.html(@template({message: message})) 
  
  _fadeInStaticMessage : () ->
    @_message( @staticMessage.message,  @staticMessage.type)
    @$el.fadeIn(3000)
  
  _showHelper : ->
    @$el.fadeOut(3000, =>
      if(@fadeMessages.length > 0)
        @_message( @fadeMessages[0].message,  @fadeMessages[0].type)
        @fadeMessages.splice(0,1)
        @$el.fadeIn(3000, =>  @_showHelper())
      else
        @_fadeInStaticMessage()
    )
  
  show: (message, type) ->
   @fadeMessages.push {message: message, type: type}
   @_showHelper()
  
  display: (message, type) ->
    @staticMessage = {message: message, type: type}
    @_showHelper()
  
  success: (message) ->
    @show message, 'alert-success'
  
  error: (message) ->
    @show message, 'alert-error'
  
  info: (message) ->
    @show message, 'alert-info'
    
  displaySuccess: (message) ->
    @display message, 'alert-success'
    
  displayError: (message) ->
    @display message, 'alert-error'
  
  displayInfo: (message) ->
    @display message, 'alert-info'