# This class renders the menu items for the Mode Menu
# The isShowing field is used for items in the menu that
# toggle show/hide on the map.
class window.beats.ModeMenuViewItem extends Backbone.View
  $a = window.beats
  tagName : 'li'
  
  events : {
    'click': 'toggleMapMode'
  }

  broker_events : {
    'mode_menu:hide': 'hideIcon'
  }
  
  initialize: (@parent, @values) ->
    @triggerShow = @values.triggerShow
    @template = _.template($('#child-item-menu-template').html())
    displayText = values.label
    @$el.html @template({text: displayText})
    $a.Util.publishEvents($a.broker, @broker_events, @)
    @render()
    @check(@values.initiallyChecked)
    @isShowing = @values.initiallyChecked

  render: ->
    $("##{@parent}").append(@el)
    @

  # adds the checkmark to the item or takes it aways
  check: (show) ->
    if show
      @$el.addClass "icon-ok"
    else
      @$el.removeClass "icon-ok"

  # this removes the icon and sets isShowing to false
  hideIcon : ->
    @$el.removeClass "icon-ok"
    @isShowing = false
  
  # This maintains the state of mode menu
  toggleMapMode: (e) ->
    elems = $("##{@parent}").find("li")
    _.each(elems, (elem) -> $(elem).removeClass "icon-ok")
    $a.broker.trigger(@triggerShow, @event_arg)
    @isShowing = true
    @check(true)
    e.stopPropagation()