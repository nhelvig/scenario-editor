# Creates nodes by overriding getIcon from MapMarkerView and registering
# show/hide events from the node layer. It also adds itself to and holds a static
# array of nodes
class window.beats.MapNodeView extends window.beats.MapMarkerView
  @ICON: google.maps.SymbolPath.CIRCLE
  @SELECTED_ICON_COLOR: 'blue'
  @SELECTED_STROKE_COLOR: 'red'
  @STROKE_COLOR: 'blue'
  @ICON_COLOR: 'white'
  @TERMINAL_ICON: 'M -1,-1 1,-1 1,1 -1,1 z'
  @TERMINAL_TYPE: 'Terminal'
  $a = window.beats
  
  initialize: (model, @network) ->
    super model
    @model.on('change:selected', @toggleSelectedView, @)
    @model.on('change:type', @changeIconType, @)
    @model.on('remove', @removeElement, @)
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
    super @icon()
  
  _getIconFillColor: ->
    if @model.selected()
      return MapNodeView.SELECTED_ICON_COLOR
    else
      return MapNodeView.ICON_COLOR
  
  _getStrokeFillColor: ->
    if @model.selected()
      return MapNodeView.SELECTED_STROKE_COLOR
    else
      return MapNodeView.STROKE_COLOR
  
  # This returns the appropriate icon for terminals and selected or not
  _getTypeIcon: ->
    if @model.type_name() is MapNodeView.TERMINAL_TYPE
        return MapNodeView.TERMINAL_ICON
    else
        return MapNodeView.ICON
  
  # determine marker size based the zoom level
  getScaledSize: ->
    zoomLevel = $a.map.getZoom()
    if (zoomLevel >= 17)
      return 8
    else if (zoomLevel >= 15)
      return 6
    else if (zoomLevel >= 14)
      return 4
    else
      return 2
  
  # determine marker stroke weight based the zoom level
  getStrokeWeightOnZoom: ->
    zoomLevel = $a.map.getZoom()
    if (zoomLevel >= 16)
      return 4
    else if (zoomLevel >= 14)
      return 3
    else
      return 2
  
  # This method is called when the type attribute changes
  changeIconType: ->
    @marker.setIcon(@icon())
  
  icon: ->
    {
      strokeColor: @_getStrokeFillColor()
      fillColor : @_getIconFillColor()
      strokeWeight: @getStrokeWeightOnZoom()
      strokeOpacity: 1
      fillOpacity : 1
      path: @_getTypeIcon()
      scale: @getScaledSize()
    }
  
  # Context Menu
  # Create the Node Context Menu. Call the super class method to create the 
  # context menu. This method also populates the menu items by checking the 
  # context, whether or not another node is selected and ensuring that the
  # other node is not itself.
  _contextMenu: (event) ->
    items = []
    items = $a.node_context_menu
    isOneSelected = $a.nodeList? and $a.nodeList.isOneSelected()
    isDrawLink = isOneSelected  and !@model.selected()
    items = _.union(items, $a.node_selected_node_clicked) if isDrawLink
    
    args = super 'node', items
    $a.ContextMenuHandler.createMenu(args, event.latLng)

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
    @model.off('change:selected', @toggleSelectedView)
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
    @_triggerClearSelectEvents()
    @model.toggle_selected() 

  # This function triggers the events that make the selected tree and map items to de-selected
  _triggerClearSelectEvents: () ->
    $a.broker.trigger('map:clear_selected') unless $a.ALT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.ALT_DOWN
  
  # This method is called from the context menu and selects itself and all the nodes links.
  # Note: The links references are from the output and input attributes on the node.
  selectSelfandMyLinks: () ->
    # de-select everything unless SHIFT is down
    @_triggerClearSelectEvents()
    @model.toggle_selected()
    @toggleSelectedView()
    _.each(@model.ios(), @selectLink)

  # This method is called from the context menu and clears itself and all the nodes links.
  # Note: The links references are from the output and input attributes on the node.
  clearSelfandMyLinks: () ->
    @model.toggle_selected()
    @toggleSelectedView()
    $a.broker.trigger("app:tree_remove_highlight:#{@model.cid}")
    _.each(@model.ios(), (ioLink) ->
      ioLink.link().set_selected(false)
      $a.broker.trigger("app:tree_remove_highlight:#{ioLink.link().cid}"))

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
    io.link().set_selected(true)
    $a.broker.trigger("app:tree_highlight:#{io.get('link').cid}")
    $a.broker.trigger("app:tree_show_item:#{io.get('link').cid}")

  # This method toggles the selection of the node
  toggleSelectedView: ->
    if(@model.selected())
      @makeSelected()
    else
      @clearSelected()
  
  # This method swaps the icon for the selected icon
  makeSelected: () ->
    $a.broker.trigger("app:tree_highlight:#{@model.cid}")
    super @icon()

  # This method swaps the icon for the de-selected icon
  clearSelected: () ->
    super @icon()