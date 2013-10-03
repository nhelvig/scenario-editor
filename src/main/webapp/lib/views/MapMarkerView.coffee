# MapMarkerView is base class for scenario elements represented by a
# single latitude and longitude on the Map
class window.beats.MapMarkerView extends Backbone.View
  @IMAGE_PATH: '/scenario-editor-0.4-SNAPSHOT/app/images/'
  $a = window.beats

  broker_events : {
    'map:open_view_mode' : 'viewMode'
    'map:open_network_mode' : 'networkMode'
    'map:open_scenario_mode' : 'scenarioMode'
    'map:init' : 'render'
    'map:clear_selected' : 'clearSelected'
  }
  
  initialize: (@model) ->
    # get the position, we only draw if the position is defined
    # TODO deal with getting a position if it is not defined
    @latLng = $a.Util.getLatLng(@model)
    @draw()
    gevent = google.maps.event
    gevent.addListener(@marker, 'dragend', => @dragMarker())
    gevent.addListener(@marker, 'click', (event) => @manageMarkerSelect())
    gevent.addListener(@marker, 'dblclick', (mouseEvent) => @_editor())
    $a.broker.on("map:select_item:#{@model.cid}", @makeSelected, @)
    $a.broker.on("map:clear_item:#{@model.cid}", @clearSelected, @)
    $a.broker.on("map:open_editor:#{@model.cid}", @_editor, @)
    $a.Util.publishEvents($a.broker, @broker_events, @)

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
    @getMarkerImage img

  getMarkerImage: (img) ->
    new google.maps.MarkerImage("#{MapMarkerView.IMAGE_PATH}#{img}.png",
      new google.maps.Size(32, 32),
      new google.maps.Point(0,0),
      new google.maps.Point(16, 16)
    )

  # in order to remove an element you need to unpublish the events,
  # hide the marker and set it to null
  removeElement: ->
    $a.Util.unpublishEvents($a.broker, @broker_events, @)
    $a.broker.off("map:select_item:#{@model.cid}")
    $a.broker.off("map:clear_item:#{@model.cid}")
    $a.broker.off("map:open_editor:#{@model.cid}")
    @hideMarker() if @marker?
    @marker = null

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
    new $a.ContextMenuHandler(args)
  
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
    @marker.setIcon(@getMarkerImage(img))

  # This method swaps the icon for the selected icon
  makeSelected: (img) ->
    @model.set('selected', true)
    @_setSelected img

  # This method swaps the icon for the de-selected icon
  clearSelected: (img) ->
    @model.set('selected', false)
    @_setSelected img