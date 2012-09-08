# Creates the links of the network. A link consists of a
# Polyline drawn between two steps in the route as well as
# an arrow head pointing in the appropriate direction if the
# Polyline is sufficiently long.
class window.sirius.MapLinkView extends Backbone.View
  @LINK_COLOR: 'blue'
  @SELECTED_LINK_COLOR: 'red'

  $a = window.sirius

  initialize: (@model, @network, @legs) ->
    @_createEncodedPath @legs
    @_saveEncodedPath()
    @_drawLink()
    @_contextMenu()
    $a.broker.on('map:init', @render, @)
    $a.broker.on('map:hide_link_layer', @hideLink, @)
    $a.broker.on('map:show_link_layer', @showLink, @)
    $a.broker.on("map:links:show_#{@model.get('type')}", @showLink, @)
    $a.broker.on("map:links:hide_#{@model.get('type')}", @hideLink, @)
    $a.broker.on("map:select_item:#{@model.cid}", @linkSelect, @)
    $a.broker.on("map:clear_item:#{@model.cid}", @clearSelected, @)
    $a.broker.on("map:select_neighbors:#{@model.cid}", @selectSelfandMyNodes, @)
    $a.broker.on("map:clear_neighbors:#{@model.cid}", @clearSelfandMyNodes, @)
    $a.broker.on('map:clear_selected', @clearSelected, @)
    $a.broker.on("map:clear_map", @removeLink, @)
    $a.broker.on("map:select_network:#{@network.cid}", @linkSelect, @)
    $a.broker.on("map:clear_network:#{@network.cid}", @clearSelected, @)
    google.maps.event.addListener(@link, 'click', (evt) => @manageLinkSelect())
    google.maps.event.addListener(@link, 'dblclick', (evt) => @_editor(evt))

  render: ->
    @link.setMap($a.map)
    @

  # this method reads the path of points contained in the legs, joins them
  # into one array with no duplicates and then encodes the using googles
  # geomtry package in order to save the path to models linkgeometry field
  _createEncodedPath: (legs) ->
    smPath = []
    for leg in legs
      for step in leg.steps
        for pt in step.path
          if !(pt in smPath)
            smPath.push pt
    @encodedPath = google.maps.geometry.encoding.encodePath smPath

  # save the encoded path to the model
  _saveEncodedPath: ->
    lg = new $a.LinkGeometry()
    ep = new $a.EncodedPolyline()
    pts = new $a.Points()
    pts.set(text:@encodedPath)
    ep.set(points: pts)
    lg.set(encodedpolyline:ep)
    @model.set(linkgeometry: lg)

  # Creates the Polyline to rendered on the map
  # The Polyline map attribute will be null until render is called
  _drawLink: ->
    linkGeom = @model.get('linkgeometry')
    polyPath = linkGeom.get('encodedpolyline').get('points').get('text')
    @link = new google.maps.Polyline({
      path: google.maps.geometry.encoding.decodePath polyPath
      map: $a.map
      strokeColor:  MapLinkView.LINK_COLOR
      icons: [{
          icon: { path: google.maps.SymbolPath.FORWARD_OPEN_ARROW }
          fillColor: 'blue'
          offset: '50%'
        }]
      strokeOpacity: 0.6
      strokeWeight: 4
    })

  # Context Menu
  # Create the link Context Menu. The menu items are stored with their events
  # in an array and con be configired in the menu-data.coffee file.  We create
  # a dependency with the ContextMenuView here. There may a better way to do
  # this. I also add the contextMenu itself to the model so the same menu can
  # be added to the tree items for this link
  _contextMenu: ->
    contextMenuOptions = {}
    contextMenuOptions.menuItems = []
    contextMenuOptions.menuItems = $a.Util.copy($a.link_context_menu)
    #set this id for the select item so we know what event to call
    _.each(contextMenuOptions.menuItems, (item) => item.id = "#{@model.cid}")
    contextMenuOptions.class = 'context_menu'
    contextMenuOptions.id = "context-menu-link-#{@model.cid}"
    contextMenu = new $a.ContextMenuView(contextMenuOptions)

    google.maps.event.addListener(@link, 'rightclick', (mouseEvent) =>
      contextMenu.show mouseEvent.latLng
    )
    @model.set('contextMenu', contextMenu)

  # creates the editor for a link
  _editor: (evt) ->
    env = new $a.EditorLinkView(elem: 'link', model: @model, width: 375)
    $('body').append(env.el)
    env.render()
    $(env.el).tabs()
    $(env.el).dialog('open')
    evt.stop()

  # The following handles the show/hide of links and arrow heads
  hideLink: ->
    @link.setMap(null)

  showLink: ->
    @link.setMap($a.map)

  # in order to remove an element you need to unpublish the events, hide the
  # marker and set it to null
  removeLink: ->
    $a.broker.off('map:init')
    $a.broker.off('map:hide_link_layer')
    $a.broker.off('map:show_link_layer')
    $a.broker.off("map:links:show_#{@model.get('type')}",)
    $a.broker.off("map:links:hide_#{@model.get('type')}")
    $a.broker.off("map:select_item:#{@model.cid}")
    $a.broker.off("map:clear_item:#{@model.cid}")
    $a.broker.off("map:select_neighbors:#{@model.cid}")
    $a.broker.off("map:clear_neighbors:#{@model.cid}")
    $a.broker.off("map:select_network:#{@network.cid}")
    $a.broker.off("map:clear_network:#{@network.cid}")
    @hideLink() if @link
    @link = null

  # Select events for link
  # Unless the Shift key is held down, this function clears any other selected
  # items on the map and in the tree after we determine if this link is to
  # be selected or deselected. You need to call @_triggerClearSelectEvents
  # from within the conditional so that you appropriately select or de-select
  # the current link and corresponding tree item
  manageLinkSelect: ->
    if @link.get('strokeColor') == MapLinkView.LINK_COLOR
      @_triggerClearSelectEvents()
      $a.broker.trigger("app:tree_highlight:#{@model.cid}")
      @linkSelect()
    else
      @_triggerClearSelectEvents()
      @clearSelected()

  # This function triggers the events that make the selected tree and map items
  # to de-selected. Called by other events to help
  _triggerClearSelectEvents: ->
    $a.broker.trigger('map:clear_selected') unless $a.SHIFT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.SHIFT_DOWN

  # This method swaps the icon for the selected color
  linkSelect: ->
    @link.setOptions(options: { strokeColor: MapLinkView.SELECTED_LINK_COLOR })

  # This method swaps the icon for the de-selected color
  clearSelected: ->
    @link.setOptions(options: { strokeColor: MapLinkView.LINK_COLOR })

  # This method is called from the context menu and selects itself and all
  # the links nodes as the higlighted tree items
  selectSelfandMyNodes: ->
    # First see if everthing should be de-selected; if shift down will not occur
    @_triggerClearSelectEvents()
    @linkSelect()
    beginNode = @model.get("begin").get("node")
    endNode = @model.get("end").get("node")
    $a.broker.trigger("app:tree_highlight:#{@model.cid}")
    $a.broker.trigger("app:tree_highlight:#{beginNode.cid}")
    $a.broker.trigger("app:tree_highlight:#{endNode.cid}")
    $a.broker.trigger("map:select_item:#{beginNode.cid}")
    $a.broker.trigger("map:select_item:#{endNode.cid}")

  # called from the context menu as well. It clears itself and its nodes as
  # well as the higlighted tree items
  clearSelfandMyNodes: ->
    @clearSelected()
    beginNode = @model.get("begin").get("node")
    endNode = @model.get("end").get("node")
    $a.broker.trigger("map:clear_item:#{beginNode.cid}")
    $a.broker.trigger("map:clear_item:#{endNode.cid}")
    $a.broker.trigger("app:tree_remove_highlight:#{@model.cid}")
    $a.broker.trigger("app:tree_remove_highlight:#{beginNode.cid}")
    $a.broker.trigger("app:tree_remove_highlight:#{endNode.cid}")