# Creates the links of the network. A link consists of a
# Polyline drawn between two steps in the route as well as
# an arrow head pointing in the appropriate direction if the
# Polyline is sufficiently long.
class window.beats.MapLinkView extends Backbone.View
  @LINK_COLOR: 'blue'
  @SELECTED_LINK_COLOR: 'red'

  @STROKE_WEIGHT_THIN: 2
  @STROKE_WEIGHT_THINNER: 1

  $a = window.beats
  model_events : {
    'remove': 'removeLink'
    'change:selected': 'toggleSelected'
    'change:lane_offset': 'drawLink'
    'change:lanes': 'setStrokeWeight'
    'change:hide': 'hideShowLink'
    'change:editor_show': 'editor'
    'change:show_demands': 'viewDemands'
  }
  
  broker_events: {
    'map:init': 'render'
  }

  initialize: (@model) ->
    @model.view = @
    @iWindow = new google.maps.InfoWindow()
    # Gets the encoded path line string if it is not already been set
    if(@model.position()? and @model.position().length > 0)
      @_createEncodedPath @model.position()
      @_saveEncodedPath()
    @drawLink()
    # only calculates and then updates link length if it not already set
    if !model.length()?
      @_saveLinkLength()
    @model.poly = @link
    @_publishEvents()
  
  render: ->
    @link.setMap($a.map) if @link?
    @

  # this method reads the path of MO points converting them into Google Points
  # and then encodes the using googles
  # geomtry package in order to save the path to models shape field
  _createEncodedPath: (pts) ->
    gPath = $a.Util.convertPointsToGoogleLatLng(pts)
    @encodedPath = google.maps.geometry.encoding.encodePath gPath

  # save the encoded path to the model
  _saveEncodedPath: ->
    @model.set_geometry @encodedPath
  
  # Creates the Polyline to rendered on the map
  # The Polyline map attribute is set immediately so the user can see that the
  # lines are being drawn
  # We set listeners up in drawLink because they need to be re-attached anytime
  # the link is re-drawn
  drawLink: ->
    @hideLink() if @link? #if you are applying offset to existing line
    linkGeom = @model.geometry()
    enc = google.maps.geometry.encoding
    pathVertices = @applyOffset(enc.decodePath(linkGeom))
    @link = new google.maps.Polyline({
      path: pathVertices
      map: $a.map
      strokeColor: @_getStrokeColor()
      icons: [{
          icon: { path: @getLinkIconPath() }
          fillColor: 'blue'
          offset: '60%'
        }]
      strokeOpacity: 0.9
      strokeWeight: @getLinkStrokeWeight()
    })
    @_publishGoogleEvents()
    @_createInfoWindow()

  # publish polyline google events
  _publishGoogleEvents: ->
    gme = google.maps.event
    @dblclckHandler = gme.addListener(@link, 'dblclick', (evt) =>
      @model.set_editor_show(true)
      evt.stop()
    )
    @clickHandler = gme.addListener(@link, 'click', =>
      selected = @model.selected()
      $a.broker.trigger('map:clear_selected') unless $a.ALT_DOWN
      @model.set_selected(!selected)
    )
    lambda = (evt) => @_contextMenu(evt)
    @rClickListener = gme.addListener(@link, 'rightclick', lambda)
  
  _unpublishGoogleEvents: ->
    gme = google.maps.event
    gme.removeListener(@zoomListener)
    gme.removeListener(@dblclckHandler)
    gme.removeListener(@clickHandler)
    gme.removeListener(@rClickListener)
  
  # this is the rollover window for the link
  _createInfoWindow: ->
    gme = google.maps.event
    @mOHandler = gme.addListener(@link, 'mouseover', (e) =>
      if(not @_isInfoWindowOpen())
        @iWindow.setContent(@getLinkRollOverInfo())
        l = e.latLng
        @iWindow.setPosition(new google.maps.LatLng(l.lat(),l.lng()+0.0001))
        trackMouseoverTimeout = setTimeout(( => @iWindow.open($a.map)), 1000)
        gme.addListenerOnce(@link, 'mouseout', (e) =>
          window.clearTimeout(trackMouseoverTimeout);
          @iWindow.close()
        );
    );
  
  _isInfoWindowOpen : ->
    @iWindow.getMap()?
  
  # this information is displays when you mouse over a polyline
  getLinkRollOverInfo: () ->
    str = "Id: " + @model.id + "</br>"
    str += "Name: " + @model.link_name() + "</br>"
    str += "Type: " + @model.type_name() + "</br>"
    str += "Number of Lanes: " + @model.lanes() + "</br>"
    str += "Length: " + @model.length()
    str
     
  # Context Menu
  # Create the link Context Menu. The menu items are stored with their events
  # in an array and con be configired in the menu-data.coffee file.  We create
  # a dependency with the ContextMenuView here. There may a better way to do
  # this. I also add the contextMenu itself to the model so the same menu can
  # be added to the tree items for this link
  _contextMenu: (evt) ->
    menuItems = $a.Util.copy($a.link_context_menu)
    #if it has demand profile then we push the Visualize demand item
    if @model.get('demand')?
      menuItems.push $a.Util.copy($a.link_context_menu_demand_item)[0]

    @contextMenuOptions =
      class: 'context_menu'
      id: "context-menu-link-#{@model.id}"
    args = 
      element: @link
      items: $a.Util.copy(menuItems)
      options: @contextMenuOptions 
      model:@model
    $a.ContextMenuHandler.createMenu(args, evt.latLng)
  
  _getStrokeColor: ->
    strokeColor = MapLinkView.LINK_COLOR
    strokeColor = MapLinkView.SELECTED_LINK_COLOR if @model.selected() is true
    strokeColor
  
  setStrokeWeight: ->
    nLanes = @model.lanes()
    @link.setOptions(options: {strokeWeight: @getLinkStrokeWeight(nLanes)})
  
  # creates the editor for a link
  editor:  ->
    if @model.editor_show() is true
      @linkSelect()
      env = new $a.EditorLinkView(elem: 'link', models: [@model], width: 375)
      $('body').append(env.el)
      env.render()
      $(env.el).tabs()
      $(env.el).dialog('open')

  viewDemands: ->
    if(@model.show_demands() is true)
      dv = new $a.DemandVisualizer(@model.demand())
      $('body').append(dv.el)
      dv.render()
      $(dv.el).dialog('open')

  # The following handles the show/hide of links and arrow heads
  # hideShow is called when a change to view state on model occurs
  hideShowLink: ->
    if(@model.hide() is 'hide')
      @hideLink()
    else
      @showLink()
    
  hideLink: ->
    @link.setMap(null)

  showLink: ->
    @link.setMap($a.map)

  # in order to remove an element you need to unpublish the events, hide the
  # marker and set it to null
  removeLink: ->
    $a.Util.unpublishEvents(@model, @model_events, @)
    $a.Util.unpublishEvents($a.broker, @broker_events, @)
    @_unpublishGoogleEvents()
    @hideLink() if @link?
    @link = null
  
  # This method swaps the icon for the selected color
  linkSelect: ->
    @link?.setOptions(options: { strokeColor: MapLinkView.SELECTED_LINK_COLOR })

  # This method swaps the icon for the de-selected color
  clearSelected: ->
    @link?.setOptions(options: { strokeColor: MapLinkView.LINK_COLOR })

  # This method toggles the selection of the link
  toggleSelected: () ->
    if(@model.selected())
      @linkSelect()
    else
      @clearSelected()

  # these events are set up during initialization of the object
  _publishEvents: () ->
    $a.Util.publishEvents(@model, @model_events, @)
    $a.Util.publishEvents($a.broker, @broker_events, @)

  # Calculates and returns Link Length, path must be set otherwise length is 0
  # Length is always in meters
  _calculateLinkLength: ->
    length = 0
    pathArr = @link.getPath().getArray()
    try
      length = google.maps.geometry.spherical.computeLength(pathArr)
    catch error
      # Display Error message to screen
      $a.broker.trigger('app:show_message:info', "Error Calculating Link Length" )
    length

  # Saves Link Length Should be called when either:
  # 1) link has no length attribute on load so it is added to model,
  # 2) New link is added or 3) If link is changed
  _saveLinkLength: ->
    # get length in meters of link
    length = @_calculateLinkLength()
    # convert to units set in settings files if in miles or km
    units = $a.models.units_text()
    if units == $a.Util.UNITS_US
      length = $a.Util.convertSIToMiles(length)
    else if units == $a.Util.UNITS_METRIC
      length = $a.Util.convertSIToKilometers(length)
    @model.set_length(length)
  
  # this method offsets this link from the original(center) polyline
  # the offset is determined by user setting the lane_offset attribute
  # of the link -- this can be modified in the editor
  applyOffset: (vertices) ->
    offset = @model.get('lane_offset') || 0
    prj = $a.map.getProjection()
    if offset is 0 then return vertices
    
    newPts = []
    verts = vertices
    for i in [0..verts.length-1]
      cv = verts[i]
      vBehind = if i is 0 then null else verts[i-1]
      vFront = if i is verts.length-1 then null else verts[i+1]
      vBehind = verts[i-2] if(vBehind? and vBehind.equals(cv) and i-2 >= 0)
      vFront = verts[i+2] if(vFront? and vFront.equals(cv) and i+2 < verts.length)
      v = @_vertexOffset(cv, offset, vBehind, vFront, prj)
      newPts.push v
    newPts
  
  # we call this method above for every vertex along the polyline path
  # offsetting the origin point(cv) by the offset indicated
  _vertexOffset: (cv, offset, v0, v1, prj) -> 
    cp = prj.fromLatLngToPoint(cv)
    p0 = @_subtract(prj.fromLatLngToPoint(v0), cp) if not(v0 is null)
    p1 = @_subtract(prj.fromLatLngToPoint(v1), cp) if not(v1 is null)
    p0 = new google.maps.Point(-p1.x, -p1.y) if v0 is null
    p1 = new google.maps.Point(-p0.x, -p0.y) if v1 is null
    p0 = @_normalize(p0)
    p1 = @_normalize(p1)
    det = p0.x * p1.y - p1.x * p0.y
    if det is 0
      x2 = -p0.y
      y2 = p0.x
    else
      detSign = det / Math.abs(det)
      x2 = detSign * (p0.x + p1.x) / 2
      y2 = detSign * (p0.y + p1.y) / 2
    p2 = new google.maps.Point(x2,y2)
    v2 = prj.fromPointToLatLng(@_add(p2, cp))
    d2 = google.maps.geometry.spherical.computeDistanceBetween(cv, v2)
    dist = offset * 3.0
    k = dist/d2
    p3 = new google.maps.Point(k * x2,k * y2)
    v = prj.fromPointToLatLng(@_add(p3, cp))
    v
  
  # determine strokeweight for zoom based both on number of lines and the
  # zoom level
  getLinkStrokeWeight: ()->
    numLines = @model.lanes()
    zoomLevel = $a.map.getZoom()
    if (zoomLevel >= 17)
      return 7
    else if (zoomLevel >= 16)
      return 4
    else if (zoomLevel >= 15)
      return 3
    else
      return 2

  # determine whether arrow should be drawn or not based on
  # zoom level
  getLinkIconPath: () ->
    zoomLevel = $a.map.getZoom()
    if (zoomLevel >= 14)
      return google.maps.SymbolPath.FORWARD_OPEN_ARROW
    else
      return null
  
  # these 4 methods are all used to deal with the lane offset
  _distance: (p1, p2) ->
    Math.sqrt(Math.pow(p1.x - p2.x,2) + Math.pow(p1.y - p2.y,2)) 
  
  _add: (p1, p2) -> 
    new google.maps.Point(p1.x + p2.x, p1.y + p2.y)
      
  _subtract: (p1, p2) -> 
    new google.maps.Point(p1.x - p2.x, p1.y - p2.y)
  
  # we normalize to a unit length(1)
  _normalize: (p) ->
    unitDist = @_distance(p, new google.maps.Point(0,0))
    new google.maps.Point(p.x/unitDist, p.y/unitDist)