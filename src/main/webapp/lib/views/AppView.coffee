# AppView is main organizing view for the application
# It handles all the application level elements as well as
# instantiating and triggering the Network to be drawn
class window.beats.AppView extends Backbone.View
  $a = window.beats
  $evt = google.maps.event
  @INITIAL_ZOOM_LEVEL = 17

  @start: ->
    new window.beats.AppView().render()
    
  initialize: ->
    #change underscores symbols for handling interpolation to {{}}
    _.templateSettings =
      evaluate: /{%([\s\S]+?)%}/g,
      interpolate: /\{\{(.+?)\}\}/g
    $a.broker = _.clone(Backbone.Events)
    @

  render: ->
    @_initializeMap()
    @_navBar()
    @_contextMenu()
    @_messagePanel()
    @newScenario() if $a.Environment.DEV is false
    # Wait for idle map so that we can get projection
    google.maps.event.addListener($a.map, 'idle', =>
      @_displayMap($a.fileText) if $a.Environment.DEV is true
      google.maps.event.clearListeners($a.map, 'idle')
    )
    
    $evt.addDomListener(window, 'keydown', (event) => @_setKeyDownEvents(event))
    $evt.addDomListener(window, 'keyup', (event) => @_setKeyUpEvents(event))
    $evt.addListener($a.map, 'mouseover', (mouseEvent) => @fadeIn())
    $a.broker.on('map:upload_complete', @_displayMap, @)
    $a.broker.on("map:clear_map", @clearMap, @)
    $a.broker.on("app:new_scenario", @newScenario, @)
    $a.broker.on('app:open_scenario', @openScenario, @)
    $a.broker.on("app:save_scenario", @saveScenario, @)
    $a.broker.on("map:alert", @showAlert, @)
    $a.broker.on("app:login", @_login, @)
    $a.broker.on("app:open_network_browser", @_openNetworkBrowser, @)
    $a.broker.on("app:load_network", @_loadNetwork, @)
    @

  # create the landing map. The latitude and longitude our arbitarily pointing
  # to the I80/Berkeley area
  _initializeMap: ->
    mapOpts = {
      center: new google.maps.LatLng(37.85794730789898, -122.29954719543457)
      zoom: AppView.INITIAL_ZOOM_LEVEL
      mapTypeId: google.maps.MapTypeId.ROADMAP
      mapTypeControl: false
      zoomControl: true
      zoomControlOptions:
        style: google.maps.ZoomControlStyle.DEFAULT,
        position: google.maps.ControlPosition.TOP_LEFT
    }
    #attach the map to the namespace
    $a.map = new google.maps.Map $("#map_canvas")[0], mapOpts
    
  # This creates the context menu as well as adds the listeners for map area
  # of the application.Currently we have zoom in and zoom out as well as center
  # the map.
  _contextMenu: () ->
    contextMenuOptions =
      class: 'context_menu'
      id: "main-context-menu"
    args = 
      element: $a.map 
      items: $a.main_context_menu
      options: contextMenuOptions
    new $a.ContextMenuHandler(args)

  # This creates the main navigation bar menu
  _navBar: () ->
    attrs = { name: 'localNetwork', id: 'uploadField', attach: '#main-nav div' }
    @fuv = new $a.FileUploadView(attrs)

    attrs = { menuItems: $a.nav_bar_menu_items, attach: '#main-nav div' }
    @nbv = new $a.NavBarView(attrs)

  # creates a DOM document for the models xml to written to.
  # if no scenario has been loaded show a message indicating this.
  # The two files passed to the writeAndDownloadXML method are scenario.php
  # and scenario-download-php. This will change when we know what we are
  # running on the backend. The first file taks the xml string
  # generated from the models and saves it to a file. The second parameter
  # creates the correct headers to download this file to the client
  saveScenario: ->
    if $a.models?
        doc = document.implementation.createDocument(null, null, null)
        center = $a.map.getCenter()
        $a.models.set_position(center.lat(), center.lng())
        attrs =
          xml: $a.models.to_xml(doc)
        $a.Util.writeAndDownloadXML(attrs)
     else
        $a.broker.trigger("app:show_message:info", "No scenario loaded")

  openScenario: ->
    $("#uploadField").click()
  
  newScenario: ->
    $a.broker.trigger('map:clear_map')
    $a.map.setZoom(AppView.INITIAL_ZOOM_LEVEL)
    $a.models = new $a.Scenario()
    $a.models.networklist().set('network',[new $a.Network()])
    network = $a.models.network()
    $a.nodeList = new $a.NodeListCollection([])
    $a.nodeListView = new $a.NodeListView($a.nodeList, network)
    $a.linkList = new $a.LinkListCollection([])
    $a.linkListView = new $a.LinkListView($a.linkList, network)
    $a.sensorList = new $a.SensorListCollection([])
    $a.sensorListView = new $a.SensorListView($a.sensorList, network)
    $a.controllerSet = new $a.ControllerSetCollection([])
    $a.controllerSetView = new $a.ControllerSetView($a.controllerSet, network)
    $a.eventSet = new $a.EventSetCollection([])
    $a.eventSetView = new $a.EventSetView($a.eventSet, network)
    $a.settings = new $a.Settings()

  # Creates Log in screen
  _login: () ->
    # Create login pop up
    attrs = { title : "Log In"}
    @login = new $a.LogInView(attrs)

  
  # displayMap takes the uploaded file data parses the xml into the model
  # objects, and creates the MapNetworkView
  _displayMap: (fileText) ->
    $a.broker.trigger("map:clear_map")
    try
      xml = $.parseXML(fileText)
      $a.models = $a.Scenario.from_xml($(xml).children())
    catch error
      $a.broker.trigger("app:show_message:error", "Data file is badly formatted.")
    new $a.MapNetworkView $a.models

  clearMap: ->
    #$a.models = {}
    $a.broker.trigger('map:toggle_tree', false)
    $a.broker.trigger('app:tree_clear')
    $a.broker.trigger('app:show_message:success', 'Cleared map')

  _messagePanel: ->
    @mpv = new $a.MessagePanelView()

  _setKeyDownEvents: (e) ->
    # Open Local Network ALT-A
    # Save Local Network ALT-S
    # We set ALT_DOWN to false here because
    # the click event is preventing key up from being called
    if $a.ALT_DOWN and e.keyCode == 65
      $("#uploadField").click()
      $a.ALT_DOWN = false

    # Save Local Network
    if $a.ALT_DOWN and e.keyCode == 83
      $("#save-local-network").click()
      $a.ALT_DOWN = false

    # Set multi-select of map elements with the shift key
    $a.SHIFT_DOWN = true if e.keyCode == 16

    # Set alt key down in order to set up quick key for opening files
    $a.ALT_DOWN = true if e.keyCode == 18

  _setKeyUpEvents: (e) ->
    # Turn off shift and alt down flags where appropriate
    $a.SHIFT_DOWN = false if e.keyCode == 16
    $a.ALT_DOWN = false  if e.keyCode == 18

  fadeIn: ->
    $('.container').fadeIn(200)
    $('#lh').fadeIn(200)
    $('#mh').fadeIn(200)

  # Open network browser to choose newtork to load from DB
  _openNetworkBrowser: () ->
    # open network browser
    options = { title: 'Network List' }
    if not $a.newtorkbrowser? then $a.networkbrowser = new $a.NetworkBrowserView(options) 

  # Load Network
  _loadNetwork: (networkId) ->
    # add overlay to disable screen
    messageBox = new $a.MessageWindowView( {text: "Loading Network..."} )
    # one off ajax request to get network from DB in XML form
    # TODO: Implement backbone parse in each model to cascade model creadtion 
    # and pass in JSON instead of XML
    $.ajax(
      url: "/via-rest-api/project/1/scenario/1/network/" + networkId
      type: 'GET'
      beforeSend: (xhrObj) ->
        xhrObj.setRequestHeader('Authorization', $a.usersession.getHeaders()['Authorization'])
      success: (data) =>
        # remove modal message which disabled screen
        $a.broker.trigger('app:loading_complete')
        # TODO: Change this to use JSON ( backbone model parse methods instead of XML)
        beginning = '<?xml version="1.0" encoding="UTF-8"?> <scenario> <settings/> <NetworkList>'
        data = data.replace('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>', beginning)
        end = '</NetworkList> <SignalList/> <SensorList/> <EventSet/> <ControllerSet/> </scenario>'
        data = data + end
        @_displayMap(data)
      dataType: 'text'
    )

