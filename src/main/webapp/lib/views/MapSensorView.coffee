# Creates sensors by overriding getIcon from MapMarkerView and registering
# show/hide events from the sensors layer. It also adds itself to and holds a
# static array of sensors
class window.beats.MapSensorView extends window.beats.MapMarkerView
  @ICON: 'sensor'
  @SELECTED_ICON: 'sensor-sel'
  $a = window.beats
  
  broker_events : {
    'map:hide_sensor_layer' : 'hideMarker'
    'map:show_sensor_layer' : 'showMarker'
  }
  
  initialize: (model) ->
    super model
    $a.Util.publishEvents($a.broker, @broker_events, @)
  
  getIcon: ->
    super @getMarkerImageIcons @_getImage()
  
  _getImage: ->
    if(not @model.selected())
      return MapSensorView.ICON
    else
      return MapSensorView.SELECTED_ICON
    
  _getTitle: ->
    title = super + "\n"
    title += "PeMS VDS ID: #{@model.sensor_id_original()}\n"
    title += "Original Link Type: #{@model.link_type_original()}"
    title
  
  # creates the editor for this marker
  _editor: ->
    @model.set_selected(true)
    env = new $a.EditorSensorView(elem: 'sensor', models: [@model], width: 300)
    $('body').append(env.el)
    env.render()
    $(env.el).tabs()
    $(env.el).dialog('open')

  # This method overrides MapMarkerView to unpublish specific events to this
  # type and then calls super to set itself to null, unpublish the general 
  # events, and hide itself
  removeElement: ->
    $a.Util.unpublishEvents($a.broker, @broker_events, @)
    super

  # publish/unpublish map google events
  _publishGoogleEvents: ->
    gme = google.maps.event
    @dragListener = gme.addListener(@marker, 'drag', => @snapMarker())
    super

  _unpublishGoogleEvents: ->
    gme = google.maps.event
    gme.removeListener(@dragListener)
    super
  
  # called by drag event to see if any link is within proximity and
  # the marker should snap to it
  snapMarker: ->
    # TODO: Uncomment once checkSnap function is EditorLinkView stops throwing errors
    #$a.broker.trigger("links:check_proximinity", @)
  
  # Context Menu
  # Create the Sensor Context Menu. Call the super class method to create the
  # context menu
  _contextMenu: (evt) ->
    items = []
    items = $a.sensor_context_menu
    isOneSelected = $a.linkList? and $a.linkList.isOneSelected()
    items = _.union(items, $a.sensor_cm_link_selected) if isOneSelected
    
    args = super 'sensor', items
    $a.ContextMenuHandler.createMenu(args, evt.latLng)
  
  # This method is called from the context menu and selects itself and all the 
  # sensor links. Note we filter the Network links for all links with this
  # node attached.
  selectSelfandMyLinks: ->
    @_triggerClearSelectEvents()
    @model.set_selected(true)
    @model.link_reference().set_selected(true) if @model.link_reference()?
   
  # This method is called from the context menu and de-selects itself and all
  # the sensor links.
  clearSelfandMyLinks: ->
    @model.set_selected(false)
    @model.link_reference().set_selected(false) if @model.link_reference()?
  
  # This method swaps the icon for the selected icon
  makeSelected: () ->
    super @getMarkerImageIcons MapSensorView.SELECTED_ICON

  # This method swaps the icon for the de-selected icon
  clearSelected: () ->
    super @getMarkerImageIcons MapSensorView.ICON