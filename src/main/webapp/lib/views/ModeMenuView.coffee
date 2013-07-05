# This class renders the Mode Menu. It's menu items can be found in
# menu-data.coffee. In combination with ModeMenuViewItem it will
# recursively render a menu and its submenus if they are defined
# in the data file correctly.
class window.beats.ModeMenuView extends Backbone.View
  $a = window.beats
  tagName : 'ul'
  
  # used to create hover effects on the submenus
  events : {
      'mouseleave'            : 'displayOff',
      'mouseenter'            : 'displayOn'
  }
  
  broker_events: {
    'map:clear_map' : '_clear'
  }
  
  # create itself, render it and then iterate to create its menu items
  initialize: (@options)->
    @menuItems = @options.menuItems
    @$el.attr 'class', @options.className if @options.className
    @$el.attr 'id', @options.id if @options.id
    @$el.attr 'role', 'menu'
    @render()
    _.each(@menuItems, (item) => new $a.ModeMenuViewItem(@id, item))
    $a.Util.publishEvents($a.broker, @broker_events, @)
    $("##{@options.parentId}").click((e) => @toggleOpen(e))
  
  render: ->
    $("##{@options.parentId}").append(@el)
    @
  
  _clear: ->
    $("##{@id}").remove()
    
  #these open and close the Layers Menu itself
  displayOff: ->
    @$el.removeClass "open"
    
  #first close the other menu if it is open
  displayOn: ->
    @$el.addClass "open"
  
  toggleOpen: (e) ->
    $("#l_list").removeClass "open"
    if @$el.hasClass "open" then @displayOff() else @displayOn()
    e.stopPropagation()