# ContextMenuView is creates context menus. It is heavily based off
# of the work done by Martin Pearman at 
# http://code.martinpearman.co.uk/googlemapsapi/contextmenu/
# We ported most of it to jQuery, coffeesript and Backbone and abstracted 
# to work for any context menu. Notice it extends google's OverlayView. 
# The specification requires onAdd, draw, and onRemove
# to be overridden. See document on Google OverlayView for details on rendering:
# developers.google.com/maps/documentation/javascript/reference#OverlayView
class window.beats.ContextMenuView extends google.maps.OverlayView
  $a = window.beats
  el: {}

  constructor: (@options) ->
    @template = _.template($('#context-menu-template').html())
    @el =  @template({elemId: @options.id, elemClass: @options.class})
    @pixelOffset = @options.pixelOffset || new google.maps.Point(0, 0)
    @isVisible = false
    @position = new google.maps.LatLng(0, 0);
    #hides the context menu if you click anywhere else on the map
    google.maps.event.addDomListener(window, 'click', (() => @hide()))
    $a.broker.on('map:hide_context_menus', @hide, @)


  draw: () ->
    if @isVisible
      oWidth = $("##{@options.id}").offsetWidth
      oHeight =  $("##{@options.id}").offsetHeight
      mapSize = new google.maps.Size(oWidth, oHeight)
      menuSize = new google.maps.Size(oWidth, oHeight)
      # If @position comes from the google map it will be of type 
      # google.maps.LatLng otherwise it will be from the tree view and will 
      # simply be the x and y position of the item
      if @position instanceof google.maps.LatLng
        mousePosition = @getProjection().fromLatLngToContainerPixel(@position)
      else
        mousePosition = @position

      left = mousePosition.x
      top = mousePosition.y

      if(mousePosition.x>mapSize.width-menuSize.width-@pixelOffset.x)
         left=left-menuSize.width-@pixelOffset.x
      else
         left+=@pixelOffset.x

      if(mousePosition.y>mapSize.height-menuSize.height-@pixelOffset.y)
        top=top-menuSize.height-@pixelOffset.y
      else
        top+=@pixelOffset.y

      $("##{@options.id}").css({ top: "#{top}px", left: "#{left}px"})

  hide: () ->
    @setMap(null)
    if @isVisible
      $("##{@options.id}").hide()
      @isVisible=false

  show: (position) ->
    # This ensures no other context menus are on the screen
    $a.broker.trigger('map:hide_context_menus')
    $("body").append(@el)
    @position = position
    @setMap($a.map)
    if(!@isVisible)
      $("##{@options.id}").show()
      @isVisible = true

  onAdd: () ->
    _.each(@options.menuItems, (item) =>
      item.model = @options.model
      item.view = new $a.ContextMenuItemView(@options.id, item, @position)
    )

  onRemove: () ->
    $("##{@options.id}").remove()
  
  getVisible: () ->
    @isVisible