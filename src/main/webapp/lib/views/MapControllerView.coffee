# Creates contollers by overriding getIcon from MapMarkerView and registering
# show/hide events from the controller layer. It also adds itself to and 
# holds a static array of controllers  
class window.beats.MapControllerView extends window.beats.MapMarkerView
  @ICON: 'controller'
  @SELECTED_ICON: 'controller-sel'
  $a = window.beats

  initialize: (model) ->
    super  model
    $a.broker.on('map:hide_controller_layer', @hideMarker, @)
    $a.broker.on('map:show_controller_layer', @showMarker, @)
    @model.on('remove', @removeElement, @)

  getIcon: ->
    super @getMarkerImageIcons MapControllerView.ICON

  # This method overrides MapMarkerView to unpublish specific events to this 
  # type and then calls super to set itself to null, unpublish the general 
  # events, and hide itself
  removeElement: ->
    $a.broker.off('map:hide_controller_layer')
    $a.broker.off('map:show_controller_layer')
    super
  
  ################# select events for marker
  # Callback for the markers click event
  # Callback for the markers click event. It decided whether we are selecting 
  # or de-selecting and triggers appropriately 
  manageMarkerSelect: () ->
    iconName = MapControllerView.__super__._getIconName.apply(@, []) 
    if iconName == "#{MapControllerView.ICON}.svg"
      @_triggerClearSelectEvents()
      $a.broker.trigger("app:tree_highlight:#{@model.cid}")
      @makeSelected()
    else
      @_triggerClearSelectEvents()
      @clearSelected() #Shift key is down and you are deselecting yourself
  
  # Controllers have their own names as opposed to nodes and sensors 
  _getTitle: ->
    title = "Name: #{@model.name()}\n"
    title += "Latitude: #{@latLng.lat()}\n"
    title += "Longitude: #{@latLng.lng()}"
    title
  
  # Context Menu
  # Create the Controller Context Menu. Call the super class method to create the
  # context menu
  _contextMenu: (evt) ->
    args  = super 'controller', $a.controller_context_menu
    $a.ContextMenuHandler.createMenu(args, evt.latLng)
  
  # This function triggers the events that make the selected tree and map 
  # items to de-selected
  _triggerClearSelectEvents: () ->
    $a.broker.trigger('map:clear_selected') unless $a.ALT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.ALT_DOWN

  # This method swaps the icon for the selected icon
  makeSelected: () ->
    _.each(@model.get('targetreferences'), (link) -> 
          $a.broker.trigger("map:select_item:#{link.cid}")
          $a.broker.trigger("app:tree_highlight:#{link.cid}")
        )
    super @getMarkerImageIcons MapControllerView.SELECTED_ICON

  # This method swaps the icon for the de-selected icon
  clearSelected: () ->
    super @getMarkerImageIcons MapControllerView.ICON