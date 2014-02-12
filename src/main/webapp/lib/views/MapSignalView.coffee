# Creates signals by overriding getIcon from MapMarkerView and registering
# show/hide events from the signals layer. It also adds itself to and holds a
# static array of signals
class window.beats.MapSignalView extends window.beats.MapMarkerView
  @ICON: 'green-triangle'
  @SELECTED_ICON: 'red-triangle'
  $a = window.beats

  initialize: (model) ->
    super  model
    @_contextMenu()
    $a.broker.on("map:select_neighbors:#{@model.cid}", @selectSelfandMyNodes, @)
    $a.broker.on("map:clear_neighbors:#{@model.cid}", @clearSelfandMyNodes, @)
    $a.broker.on('map:hide_signal_layer', @hideMarker, @)
    $a.broker.on('map:show_signal_layer', @showMarker, @)

  getIcon: ->
    super MapSignalView.ICON
  
  # This method overrides MapMarkerView to unpublish specific events to this
  # type and then calls super to set itself to null, unpublish the general 
  # events, and hide itself
  removeElement: ->
    $a.broker.off("map:select_neighbors:#{@model.cid}")
    $a.broker.off("map:clear_neighbors:#{@model.cid}")
    $a.broker.off('map:hide_signal_layer')
    $a.broker.off('map:show_signal_layer')
    super

  # Context Menu
  # Create the Signal Context Menu. Call the super class method to create the
  # context menu
  _contextMenu: () ->
    super 'signal', $a.signal_context_menu
  
  ################# select events for marker
  # Callback for the markers click event. It decided whether we are selecting 
  # or de-selecting and triggers appropriately 
  manageMarkerSelect: () ->
    iconName = MapSignalView.__super__._getIconName.apply(@, []) 
    if iconName == "#{MapSignalView.ICON}.png"
      @_triggerClearSelectEvents()
      $a.broker.trigger("app:tree_highlight:#{@model.cid}")
      @makeSelected()
    else
      @_triggerClearSelectEvents()
      @clearSelected() # Shift key is down and you are deselecting yourself

  # This function triggers the events that make the selected tree and map items
  # to de-selected
  _triggerClearSelectEvents: () ->
    $a.broker.trigger('map:clear_selected') unless $a.ALT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.ALT_DOWN

  # This method is called from the context menu and selects itself and all
  # the nodes. The inputs and output can be used in the future but test
  # data was not configured correctly
  selectSelfandMyNodes: () ->
    @_triggerClearSelectEvents()
    @makeSelected()
    $a.broker.trigger("map:select_item:#{@model.get('node').cid}")
    $a.broker.trigger("app:tree_highlight:#{@model.get('node').cid}")

  # This method is called from the context menu and de-selects itself and all
  # the signal's nodes.
  clearSelfandMyNodes: () ->
    @clearSelected()
    $a.broker.trigger("map:clear_item:#{@model.get('node').cid}")
    $a.broker.trigger("app:tree_remove_highlight:#{@model.get('node').cid}")

  # This method swaps the icon for the selected icon
  makeSelected: () ->
    super MapSignalView.SELECTED_ICON

  # This method swaps the icon for the de-selected icon
  clearSelected: () ->
    super MapSignalView.ICON