# This class renders the Layers Menu. It's menu items can be found in
# menu-data.coffee. In combination with LayersMenuViewItemit will
# recursively render a menu and its submenus if they are defined
# in the data file correctly.
class window.sirius.LayersMenuView extends Backbone.View
  $a = window.sirius
  tagName : 'ul'
  # used to create hover effects on the submenus
  events : {
      "mouseenter .submenu"   : "hoverSubOn",
      "mouseleave .submenu"   : "hoverSubOff",
      "mouseleave"            : "displayOff",
      "mouseenter"            : "displayOn",
  }
  
  # crete itself, render it and then iterate to create its menu items
  initialize: (@options) ->
    @menuItems = @options.menuItems
    @$el.attr 'class', @options.className if @options.className
    @$el.attr 'id', @options.id if @options.id
    @render()
    _.each(@menuItems, (item) => new $a.LayersMenuViewItem(@id, item))
  
  render: ->
    $("##{@options.parentId}").append(@el)
    @
  
  #these open and close the Layers Menu itself
  displayOff: (e) ->
    @$el.removeClass "open"
    
  displayOn: (e) ->
    @$el.addClass "open"
  
  # hover events that open and close submenus
  hoverSubOn: (e) ->
    ul = $("##{e.currentTarget.id}").children("ul")
    ul.removeClass("submenu-hide").addClass "submenu-show"

  hoverSubOff: (e) =>
    ul = $("##{e.currentTarget.id}").children("ul")
    ul.removeClass("submenu-show").addClass "submenu-hide"
