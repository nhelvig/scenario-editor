# MapMarkerView is base class for scenario elements represented by a
# single latitude and longitude on the Map
class window.beats.MapMarkerView extends Backbone.View
  @IMAGE_PATH: '/scenario-editor-0.101-SNAPSHOT/app/images/'
  $a = window.beats

  broker_events : {
    'map:open_view_mode' : 'viewMode'
    'map:open_network_mode' : 'networkMode'
    'map:open_scenario_mode' : 'scenarioMode'
    'map:init' : 'render'
  }
  
  model_events : {
    'change:selected': 'toggleSelectedView'
    'change:editor': 'editor'
    'remove': 'removeElement'
  }
  
  initialize: (@model) ->
    # get the position, we only draw if the position is defined
    # TODO deal with getting a position if it is not defined
    @latLng = $a.Util.getLatLng(@model)
    @draw()
    @_publishGoogleEvents()
    $a.Util.publishEvents($a.broker, @broker_events, @)
    $a.Util.publishEvents(@model, @model_events, @)

  render: ->
    @marker.setMap($a.map)
    @

  # Draw the marker by determining the type of icon
  # is used for each type of element. The default is the
  # our standard dot.png. Each subclasses overrides get_icon
  # to pass the correct icon
  draw: ->
    @marker = new google.maps.Marker
        position: @latLng
        draggable: true
        icon: @getIcon()
        title: @_getTitle()

  _getTitle: ->
    title = "Name: #{@model.road_names()}\n"
    title += "Id: #{@model.id}\n"
    title += "Latitude: #{@latLng.lat()}\n"
    title += "Longitude: #{@latLng.lng()}"
    title

  getIcon: (img) ->
    img
  
  getMarkerImageIcons: (img) ->
    zoom = @getScaledSizeOnZoomIcons()
    anchorSize = zoom.height / 2
    {
        url: "#{MapMarkerView.IMAGE_PATH}#{img}.svg",
        size: zoom,
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(anchorSize, anchorSize),
        scaledSize: zoom
    }
  
  # determine marker size based the zoom level
  getScaledSizeOnZoomIcons: ()->
    zoomLevel = $a.map.getZoom()
    if (zoomLevel >= 17)
      return new google.maps.Size(48, 48)
    else if (zoomLevel >= 16)
      return new google.maps.Size(32, 32)
    else if (zoomLevel >= 15)
      return new google.maps.Size(24, 24)
    else if (zoomLevel >= 14)
      return new google.maps.Size(16, 16)
    else
      return new google.maps.Size(12, 12)
  
  # re-render the marker when the zoom changes
  setMarkerSize: ->
    @marker.setIcon(@getIcon())
  
  # in order to remove an element you need to unpublish the events,
  # hide the marker and set it to null
  removeElement: ->
    $a.Util.unpublishEvents($a.broker, @broker_events, @)
    $a.Util.unpublishEvents(@model, @model_events, @)
    @_unpublishGoogleEvents()
    @hideMarker() if @marker?
    @marker = null
    
  # publish/unpublish map google events
  _publishGoogleEvents: ->
    gme = google.maps.event
    @dragEndListener = gme.addListener(@marker, 'dragend', => @dragMarker())
    @clickListener = gme.addListener(@marker, 'click', (event) => @manageMarkerSelect())
    @dblClickListener = gme.addListener(@marker, 'dblclick', (mouseEvent) => @_editor())
    lambda = (event) => @_contextMenu(event)
    @rClickListener = gme.addListener(@marker, 'rightclick', lambda)
    @zoomListener = google.maps.event.addListener($a.map, 'zoom_changed', => @setMarkerSize())

  _unpublishGoogleEvents: ->
    gme = google.maps.event
    gme.removeListener(@rClickListener)
    gme.removeListener(@dragEndListener)
    gme.removeListener(@clickListener)
    gme.removeListener(@dblClickListener)
    gme.removeListener(@zoomListener)
  
  # Context Menu
  #
  # Create the Marker Context Menu.
  #
  # This class is always called by it overridden subclass method. The
  # menu items are stored with their events in an array and can be
  # configired in the menu-data.coffee file. We create a dependency
  # with the ContextMenuView here. There may a better way to do
  # this. I also add the contextMenu itself to the model so the same
  # menu can be added to the tree items for this node
  _contextMenu: (type, menuItems) ->
    @contextMenuOptions =
      class: 'context_menu'
      id: "context-menu-#{type}-#{@model.id}"
    args = 
      element: @marker
      items: $a.Util.copy(menuItems)
      options: @contextMenuOptions 
      model:@model
    args
  
  # events used to move the marker and update its position
  dragMarker: ->
    @latLng = @marker.getPosition()
    @marker.setTitle @_getTitle()
    @model.updatePosition(@latLng)
 
   # set up the response for each mode
  viewMode: ->
    @marker.setDraggable(false)

  networkMode: ->
    @marker.setDraggable(false)

  scenarioMode: ->
    @marker.setDraggable(true)
  
  ################# The following handles the show and hide of node layers
  hideMarker: ->
    @marker.setMap(null)

  showMarker: ->
    @marker.setMap($a.map)

  # Used by subclasses to get name of image in order to swap between selected
  # and not selected
  _getIconName: () ->
    tokens = @marker.get('icon').url.split '/'
    lastIndex =  tokens.length - 1
    tokens[lastIndex]

  _setSelected: (img) ->
    @marker.setIcon(img)

  # Callback for the markers click event. This function sets the model's
  # selected attribute to its opposite. We save the current state
  # before clearing in case the user is de-selecting the current marker.
  # The setting of the model's selected attribute triggers a series of
  # events to make sure the icon is correct.
  manageMarkerSelect: () ->
    current = @model.selected()
    @_triggerClearSelectEvents()
    @model.set_selected(!current)
  
  # This function triggers the events that make the selected tree and map 
  # items to de-selected
  _triggerClearSelectEvents: () ->
    $a.broker.trigger('map:clear_selected') unless $a.ALT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.ALT_DOWN
  
  # This method toggles the selection of the node
  toggleSelectedView: ->
    if(@model.selected())
      @makeSelected()
    else
      @clearSelected()
  
  # This method swaps the icon for the selected icon
  makeSelected: (img) ->
    @_setSelected img

  # This method swaps the icon for the de-selected icon
  clearSelected: (img) ->
    @_setSelected img