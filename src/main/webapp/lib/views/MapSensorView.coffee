# Creates sensors by overriding getIcon from MapMarkerView and registering
# show/hide events from the sensors layer. It also adds itself to and holds a
# static array of sensors
class window.beats.MapSensorView extends window.beats.MapMarkerView
  @ICON: 'camera-orig'
  @SELECTED_ICON: 'camera-selected'
  $a = window.beats
  
  initialize: (model) ->
    super model
    @_contextMenu()
    gevent = google.maps.event
    gevent.addListener(@marker, 'drag', => @snapMarker())
    $a.broker.on("map:select_neighbors:#{@model.cid}", @selectSelfandMyLinks, @)
    $a.broker.on("map:clear_neighbors:#{@model.cid}", @clearSelfandMyLinks, @)
    $a.broker.on('map:hide_sensor_layer', @hideMarker, @)
    $a.broker.on('map:show_sensor_layer', @showMarker, @)
    @model.on('remove', @removeElement, @)

  getIcon: ->
    super MapSensorView.ICON
    
  # creates the editor for this marker
  _editor: ->
    @makeSelected()
    env = new $a.EditorSensorView(elem: 'sensor', models: [@model], width: 300)
    $('body').append(env.el)
    env.render()
    $(env.el).tabs()
    $(env.el).dialog('open')

  # This method overrides MapMarkerView to unpublish specific events to this
  # type and then calls super to set itself to null, unpublish the general 
  # events, and hide itself
  removeElement: ->
    $a.broker.off("map:select_neighbors:#{@model.cid}")
    $a.broker.off("map:clear_neighbors:#{@model.cid}")
    $a.broker.off('map:hide_sensor_layer')
    $a.broker.off('map:show_sensor_layer')
    super

  # called by drag event to see if any link is within proximity and
  # the marker should snap to it
  snapMarker: ->
    # TODO: Uncomment once checkSnap function is EditorLinkView stops throwing errors
    #$a.broker.trigger("links:check_proximinity", @)
  
  # Context Menu
  # Create the Sensor Context Menu. Call the super class method to create the
  # context menu
  _contextMenu: () ->
    super 'sensor', $a.sensor_context_menu

  # Callback for the markers click event. It decided whether we are selecting
  # or de-selecting and triggers appropriately 
  manageMarkerSelect: () ->
    iconName = MapSensorView.__super__._getIconName.apply(@, [])
    if iconName == "#{MapSensorView.ICON}.png"
      @_triggerClearSelectEvents()
      @makeSelected()
    else
      @_triggerClearSelectEvents()
      @clearSelected() #Shift key is down and you are deselecting yourself

  # This function triggers the events that make the selected tree and map 
  # items to de-selected
  _triggerClearSelectEvents: () ->
    $a.broker.trigger('map:clear_selected') unless $a.SHIFT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.SHIFT_DOWN

  # This method is called from the context menu and selects itself and all the 
  # sensor links. Note we filter the Network links for all links with this
  # node attached.
  selectSelfandMyLinks: () ->
    @_triggerClearSelectEvents()
    @makeSelected()
    $a.broker.trigger("app:tree_highlight:#{@model.link_reference().cid}")
    $a.broker.trigger("map:select_item:#{@model.link_reference().cid}")
   
  # This method is called from the context menu and de-selects itself and all
  # the sensor links.
  clearSelfandMyLinks: () ->
    @clearSelected()
    $a.broker.trigger("map:clear_item:#{@model.link_reference().cid}")
    $a.broker.trigger("app:tree_remove_highlight:#{@model.link_reference().cid}")
 
  # This method swaps the icon for the selected icon
  makeSelected: () ->
    $a.broker.trigger("app:tree_highlight:#{@model.link_reference()?.cid}") if @model.link_reference()?
    super MapSensorView.SELECTED_ICON

  # This method swaps the icon for the de-selected icon
  clearSelected: () ->
    super MapSensorView.ICON