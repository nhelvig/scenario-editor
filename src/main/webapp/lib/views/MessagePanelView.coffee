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
    'app:close_display_message' : 'closeDisplay'
  }
 
  initialize: ->
    @template = _.template($('#message-panel-template').html())
    $a.Util.publishEvents($a.broker, @broker_events, @)
    @render()

  render: ->
    $('#map_canvas').append(@el)
  
  _message: (message, type) -> 
    @$el.addClass "#{type}"
    @$el.html(@template({message: message})) 
    
  show: (message, type) ->
    @_message(message, type)
    @$el.fadeIn(3000, () => @$el.fadeOut(3000))
  
  display: (message, type) ->
    @_message(message, type)
    @$el.fadeIn(3000)
  
  closeDisplay: ->
    @$el.html(@template({message: 'Closing Mode ...'})) 
    @$el.fadeOut(3000)
  
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