# Creates nodes by overriding getIcon from MapMarkerView and registering
# show/hide events from the node layer. It also adds itself to and holds a static
# array of nodes
class window.beats.MapNodeView extends window.beats.MapMarkerView
  @ICON: 'dot'
  @SELECTED_ICON: 'reddot'
  @TERMINAL_ICON: 'square'
  @SELECTED_TERMINAL_ICON: 'red-square'
  @TERMINAL_TYPE: 'Terminal'
  $a = window.beats
  
  initialize: (model, @network) ->
    super model
    @model.on('change:selected', @toggleSelected, @)
    @model.on('change:type', @changeIconType, @)
    @model.on('remove', @removeElement, @)
    @_contextMenu()
    $a.broker.on("map:select_neighbors:#{@model.cid}", @selectSelfandMyLinks, @)
    $a.broker.on("map:select_neighbors_out:#{@model.cid}", @selectMyOutLinks, @)
    $a.broker.on("map:select_neighbors_in:#{@model.cid}", @selectMyInLinks, @)
    $a.broker.on("map:clear_neighbors:#{@model.cid}", @clearSelfandMyLinks, @)
    $a.broker.on('map:show_node_layer', @showMarker, @)
    $a.broker.on('map:hide_node_layer', @hideMarker, @)
    $a.broker.on("map:nodes:show_#{@model.type_name()?.toLowerCase()}", @showMarker, @)
    $a.broker.on("map:nodes:hide_#{@model.type_name()?.toLowerCase()}", @hideMarker, @)
    $a.broker.on("map:select_network:#{@network.cid}", @makeSelected, @)
    $a.broker.on("map:clear_network:#{@network.cid}", @clearSelected, @)

  getIcon: ->
    super @_getTypeIcon false

  # Context Menu
  # Create the Node Context Menu. Call the super class method to create the 
  # context menu
  _contextMenu: () ->
    super 'node', $a.node_context_menu

  # creates the editor for this marker
  _editor: ->
    @makeSelected()
    env = new $a.EditorNodeView(elem: 'node', models: [@model], width: 300)
    $('body').append(env.el)
    env.render()
    $(env.el).tabs()
    $(env.el).dialog('open')

  # This method overrides MapMarkerView to unpublish specific events to this type
  # and then calls super to set itself to null, unpublish the general events, 
  # and hide itself
  removeElement: ->
    @model.off('change:selected', @toggleSelected)
    @model.off('change:type', @changeIconType)
    @model.off('remove', @removeElement)
    $a.broker.off("map:select_neighbors:#{@model.cid}")
    $a.broker.off("map:select_neighbors_out:#{@model.cid}")
    $a.broker.off("map:select_neighbors_in:#{@model.cid}")
    $a.broker.off("map:clear_neighbors:#{@model.cid}")
    $a.broker.off('map:show_node_layer')
    $a.broker.off('map:hide_node_layer')
    $a.broker.off("map:nodes:show_#{@model.type_name().toLowerCase()}")
    $a.broker.off("map:nodes:hide_#{@model.type_name().toLowerCase()}")
    $a.broker.off("map:select_network:#{@network.cid}")
    $a.broker.off("map:clear_network:#{@network.cid}")
    $a.broker.off("map:remove_node:#{@model.cid}")
    super

  # set up the response for each mode
  networkMode: ->
    @marker.setDraggable(true)

  scenarioMode: ->
    @marker.setDraggable(false)
    
  ################# select events for marker
  # Callback for the markers click event. It decided whether we are selecting
  # or de-selecting and triggers appropriately
  manageMarkerSelect: () ->
    iconName = MapNodeView.__super__._getIconName.apply(@, [])
    if iconName == "#{@_getTypeIcon(false)}.png"
      @_triggerClearSelectEvents()
      @makeSelected()
    else
      @_triggerClearSelectEvents()
      @clearSelected() # you call clearSelected in case the Shift key is down and you are deselecting yourself

  # This function triggers the events that make the selected tree and map items to de-selected
  _triggerClearSelectEvents: () ->
    $a.broker.trigger('map:clear_selected') unless $a.SHIFT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.SHIFT_DOWN

  # remove myself from the map
  
  # This method is called from the context menu and selects itself and all the nodes links.
  # Note: The links references are from the output and input attributes on the node.
  selectSelfandMyLinks: () ->
    # de-select everything unless SHIFT is down
    @_triggerClearSelectEvents()
    @makeSelected()
    _.each(@model.ios(), @selectLink)

  # This method is called from the context menu and clears itself and all the nodes links.
  # Note: The links references are from the output and input attributes on the node.
  clearSelfandMyLinks: () ->
    @clearSelected()
    $a.broker.trigger("app:tree_remove_highlight:#{@model.cid}")
    _.each(@model.ios(), (link) ->
      $a.broker.trigger("map:clear_item:#{link.get('link').cid}")
      $a.broker.trigger("app:tree_remove_highlight:#{link.get('link').cid}"))

  # This method is called from the context menu to select this nodes output or input links.
  # The type parameter determins whether we are grabbing output or input attributes on the node.
  # de-select everything unless SHIFT is down
  selectMyOutLinks: ->
    @_triggerClearSelectEvents()
    _.each(@model.outputs(), @selectLink)

  selectMyInLinks: ->
    @_triggerClearSelectEvents()
    _.each(@model.inputs(), @selectLink)

  selectLink: (io) ->
    $a.broker.trigger("map:select_item:#{io.get('link').cid}")
    $a.broker.trigger("app:tree_highlight:#{io.get('link').cid}")
    $a.broker.trigger("app:tree_show_item:#{io.get('link').cid}")

  # This method toggles the selection of the node
  toggleSelected: () ->
    if(@model.selected() is true)
      @makeSelected()
    else
      @clearSelected()
  
  # This method swaps the icon for the selected icon
  makeSelected: () ->
    $a.broker.trigger("app:tree_highlight:#{@model.cid}")
    super @_getTypeIcon true

  # This method swaps the icon for the de-selected icon
  clearSelected: () ->
    super @_getTypeIcon false
  
  # This method is called when the type attribute changes
  changeIconType: ->
    @marker.setIcon(@getMarkerImage(@_getTypeIcon @model.get('selected')))
  
  # This returns the appropriate icon for terminals and selected or not
  _getTypeIcon : (selected) ->
    switch @model.type_name()
      when MapNodeView.TERMINAL_TYPE
        if selected
          MapNodeView.SELECTED_TERMINAL_ICON
        else
          MapNodeView.TERMINAL_ICON
      else
        if selected
          MapNodeView.SELECTED_ICON
        else
          MapNodeView.ICON