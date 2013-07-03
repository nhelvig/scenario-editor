# This class renders the Layers Menu. It's menu items can be found in
# menu-data.coffee. In combination with LayersMenuViewItemit will
# recursively render a menu and its submenus if they are defined
# in the data file correctly.
class window.beats.LayersMenuView extends Backbone.View
  $a = window.beats
  tagName : 'ul'
  
  # used to create hover effects on the submenus
  events : {
      "mouseenter .submenu"   : "hoverSubOn",
      "mouseleave .submenu"   : "hoverSubOff",
      "mouseleave"            : "displayOff",
      "mouseenter"            : "displayOn"
  }
  
  # crete itself, render it and then iterate to create its menu items
  initialize: (@options)->
    @menuItems = @options.menuItems
    @$el.attr 'class', @options.className if @options.className
    @$el.attr 'id', @options.id if @options.id
    @$el.attr 'role', 'menu'
    @render()
    _.each(@menuItems, (item) => new $a.LayersMenuViewItem(@id, item))
    $("##{@options.parentId}").on('click', ((e) => @toggleOpen(e)))
    $a.broker.on("map:clear_map",@_clear, @)
  
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
    elems = $(".btn-group").find(".bottom-up")
    _.each(elems, (elem) -> $(elem).removeClass "open")
    @$el.addClass "open"
  
  toggleOpen: (e) ->
    if @$el.hasClass "open"
      @displayOff()
    else
      @displayOn()
    e.stopPropagation()
  
  # hover events that open and close submenus
  hoverSubOn: ->
    ul = $("##{e.currentTarget.id}").children("ul")
    ul.removeClass("submenu-hide").addClass "submenu-show"

  hoverSubOff: ->
    ul = $("##{e.currentTarget.id}").children("ul")
    ul.removeClass("submenu-show").addClass "submenu-hide"