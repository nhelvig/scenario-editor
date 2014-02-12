# Creates events by overriding getIcon from MapMarkerView and registering
# show/hide events from the event layer. It also adds itself to and holds a 
# static array of events
class window.beats.MapEventView extends window.beats.MapMarkerView
  @ICON: 'event'
  @SELECTED_ICON: 'event-sel'
  $a = window.beats

  initialize: (model) ->
    super model
    $a.broker.on('map:hide_event_layer', @hideMarker, @)
    $a.broker.on('map:show_event_layer', @showMarker, @)
    @model.on('remove', @removeElement, @)
  
  getIcon: ->
    super @getMarkerImageIcons MapEventView.ICON
  
  # This method overrides MapMarkerView to unpublish specific events to this
  # type and then calls super to set itself to null, unpublish the general
  # events, and hide itself
  removeElement: ->
    $a.broker.off('map:hide_event_layer')
    $a.broker.off('map:show_event_layer')
    super
    
  # Events have their own names as opposed to nodes and sensors 
  _getTitle: ->
    title = "Name: #{@model.name()}\n"
    title += "Latitude: #{@latLng.lat()}\n"
    title += "Longitude: #{@latLng.lng()}"
    title
     
  ################# select events for marker
  # Callback for the markers click event. It decided whether we are selecting 
  # or de-selecting and triggers appropriately 
  manageMarkerSelect: () ->
    iconName = MapEventView.__super__._getIconName.apply(@, []) 
    if iconName == "#{MapEventView.ICON}.svg"
      @_triggerClearSelectEvents()
      $a.broker.trigger("app:tree_highlight:#{@model.cid}")
      @makeSelected()
    else
      @_triggerClearSelectEvents()
      @clearSelected() # Shift key is down and you are deselecting yourself

  # This function triggers the events that make the selected tree and 
  # map items to de-selected
  _triggerClearSelectEvents: () ->
    $a.broker.trigger('map:clear_selected') unless $a.ALT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.ALT_DOWN

  # Context Menu
  # Create the Event Context Menu. Call the super class method to create the
  # context menu
  _contextMenu: (evt) ->
    args= super 'event', $a.event_context_menu
    $a.ContextMenuHandler.createMenu(args, evt.latLng)
  
  # This method swaps the icon for the selected icon
  makeSelected: () ->
    _.each(@model.get('targetreferences'), (link) => 
          $a.broker.trigger("map:select_item:#{link.cid}")
          $a.broker.trigger("app:tree_highlight:#{link.cid}")
        )
    super @getMarkerImageIcons MapEventView.SELECTED_ICON

  # This method swaps the icon for the de-selected icon
  clearSelected: () ->
    super @getMarkerImageIcons MapEventView.ICON