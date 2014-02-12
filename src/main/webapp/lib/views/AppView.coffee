# AppView is main organizing view for the application
# It handles all the application level elements as well as
# instantiating and triggering the Network to be drawn
class window.beats.AppView extends Backbone.View
  $a = window.beats
  $evt = google.maps.event
  @INITIAL_ZOOM_LEVEL = 16
  @NAME_SAVE_MSG = "Please name your scenario/network, close this form and save again"
  @PROJECT_SAVE_MSG = "Please give your scenario a project id, close this form and save again"
  
  @start: ->
    new window.beats.AppView().render()
  
  broker_events: {
    'map:open_view_mode' : 'viewMode'
    'map:open_network_mode' : 'networkMode'
    'map:open_scenario_mode' : 'scenarioMode'
    'map:open_route_mode' : 'routeMode'
    'map:upload_complete' :  'displayMap'
    'map:clear_map' : 'clearMap'
    'app:new_scenario' : 'newScenario'
    'app:open_scenario' : 'openScenario'
    'app:save_scenario' : 'saveScenario'
    'map:alert' : 'showAlert'
    'app:open_network_browser_db' : '_openNetworkBrowser'
    'app:open_scenario_browser_db' : '_openScenarioBrowser'
    'app:load_network' : '_loadNetwork'
    'app:import_network_db' : '_importNetwork'
    'app:save_network_db' : '_saveNetwork'
    'app:load_scenario' : '_loadScenario'
    'app:load_pems' : '_loadPEMS'
    'app:import_scenario_db' : '_importScenario'
    'app:save_scenario_db' : '_saveScenario'
    'map:show_satellite' : '_showSatelliteTiles'
    'map:hide_satellite' : '_showSatelliteTiles'
    'map:import_pems' : '_importPems'
  }
  
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
    @_messagePanel()
    @newScenario() if $a.Environment.DEV is false
    # Wait for idle map so that we can get projection
    google.maps.event.addListener($a.map, 'idle', =>
      @displayMap($a.fileText) if $a.Environment.DEV is true
      google.maps.event.clearListeners($a.map, 'idle')
    )
    # add click event on log in screen
    $('#login-nav-container').click(@_login)
    
    $evt.addDomListener(window, 'keydown', (event) => @_setKeyDownEvents(event))
    $evt.addDomListener(window, 'keyup', (event) => @_setKeyUpEvents(event))
    $evt.addListener($a.map, 'mouseover', (mouseEvent) => @fadeIn())
    $a.Util.publishEvents($a.broker, @broker_events, @)
    @_publishGoogleEvents()
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
    # Enable the visual refresh (new maps)
    google.maps.visualRefresh = true
    #attach the map to the namespace
    $a.map = new google.maps.Map $("#map_canvas")[0], mapOpts
    
  # This creates the context menu as well as adds the listeners for map area
  # of the application.Currently we have zoom in and zoom out as well as center
  # the map.
  _contextMenu: (evt) ->
    items = []
    items = $a.main_context_menu
    # right-clicking on the map when node is selected
    isOneSelected = $a.nodeList? and $a.nodeList.isOneSelected()
    items = _.union(items, $a.node_selected) if isOneSelected
    
    contextMenuOptions =
      class: 'context_menu'
      id: "main-context-menu"
    args = 
      element: $a.map 
      items: items
      options: contextMenuOptions
    $a.ContextMenuHandler.createMenu(args, evt.latLng)

  # publish/unpublish map google events
  _publishGoogleEvents: ->
    gme = google.maps.event
    lambda = ((evt) => @_contextMenu(evt))
    @rClickListener = gme.addListener($a.map,'rightclick', lambda)
  
  _unpublishGoogleEvents: ->
    gme = google.maps.event
    gme.removeListener(@rClickListener)
  
  # This creates the main navigation bar menu
  _navBar: () ->
    attrs = { name: 'localNetwork', id: 'uploadField', attach: '#main-nav div' }
    @fuv = new $a.FileUploadView(attrs)

    attrs = { menuItems: $a.nav_bar_menu_items, attach: '#main-nav div' }
    @nbv = new $a.NavBarView(attrs)

  # This begins the ImportPems Polygon creation
  _importPems: () ->
    new $a.PolygonDynamicView()
  
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
      # Set save mode to file, so that database relevent information is parsed out
        $a.fileSaveMode = true
        attrs =
          xml: $a.models.to_xml(doc)
        $a.Util.writeAndDownloadXML(attrs)
     else
        $a.broker.trigger("app:show_message:info", "No scenario loaded")

  openScenario: ->
    $("#uploadField").click()
  
  newScenario: ->
    $a.broker.trigger('map:clear_map')
    $a.broker.trigger('app:tree_clear')
    $a.map.setZoom(AppView.INITIAL_ZOOM_LEVEL)
    $a.models = new $a.Scenario()
    network = $a.models.network()
    # set default position to be at berkeley
    $a.models.network().set_position($a.DefaultPosition.Lat, $a.DefaultPosition.Long)
    $a.mapNetworkView = new $a.MapNetworkView $a.models
    $a.settings = new $a.Settings()

  # Creates Log in screen
  _login: () ->
    # Check if user session exists and is authenticated, if so by pass login
    if $a.usersession and $a.usersession.isAuthenticated()
       # do nothing
    else
      # Create login pop up
      attrs = { title : "Log In"}
      @login = new $a.LogInView(attrs)
  
  # displayMap takes the uploaded file or serialized model object from database and parses the
  # xml into backbone model objects, and creates the MapNetworkView
  displayMap: (fileText) ->
    $a.broker.trigger("map:clear_map")
    try
      xml = $.parseXML(fileText)
      $a.models = $a.Scenario.from_xml($(xml).children())
      $a.mapNetworkView = new $a.MapNetworkView $a.models
    catch error
      console.log error.stack
      if error.message then errMessage = error.message else errMessage = error
      messageBox = new $a.MessageWindowView( {text: "Data file is badly formatted. " + errMessage, okButton: true} )

  
  clearMap: ->
    #$a.models = {}
    $a.broker.trigger('map:toggle_tree', false)
    $a.broker.trigger('app:tree_clear')
    $a.broker.trigger('app:show_message:success', 'Cleared map')

  viewMode: ->
    $a.Util.setMode('view')

  networkMode: ->
    $a.Util.setMode('network')

  scenarioMode: ->
    $a.Util.setMode('scenario')
    
  routeMode: ->
    $a.Util.setMode('route')
  
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

  # shows and hides satellite tiles
  _showSatelliteTiles: (flag) ->
    if(flag)
      $a.map.setMapTypeId(google.maps.MapTypeId.SATELLITE)
    else
      $a.map.setMapTypeId(google.maps.MapTypeId.ROADMAP)
  
  # Open network browser to choose newtork to load from DB
  _openNetworkBrowser: () ->
    options = { title: 'Network List' }
    $a.networkbrowser = new $a.NetworkBrowserView(options)

  # Open scenario browser to choose scenario to load from DB
  _openScenarioBrowser: () ->
    options = { title: 'Scenario List' }
    $a.scenariobrowser = new $a.ScenarioBrowserView(options)
  
  #check if network is named
  _isNetworkNamed: (network) ->
    name = network.name()
    return name? and not (name is '');

  #check if scenario is named
  _isScenarioNamed: (scenario) ->
    name = scenario.name()
    return name? and not (name is '');

  #check if scenario has project id
  _isScenarioProject: (scenario) ->
    projectId = scenario.project_id()
    return projectId? and not (projectId is '') and not (projectId is '0');
  
  #open the network editor when trying to save and network is not named
  _openNetworkEditor: (msg) ->
    $a.broker.trigger("map:open_network_editor", msg)

  #open the scenario editor when trying to save and scenario is not named
  _openScenarioEditor: (msg) ->
    $a.broker.trigger("map:open_scenario_editor", msg)
    
  # Load Network From DB
  _loadNetwork: (networkId) ->
    # add overlay to disable screen
    messageBox = new $a.MessageWindowView( {text: "Loading Network...", okButton: false} ) 
    # one off ajax request to get network from DB in XML form
    # TODO: Implement backbone parse in each model to cascade model creadtion 
    # and pass in JSON instead of XML
    $.ajax(
      url: '/via-rest-api/project/1/scenario/1/network/' + networkId
      type: 'GET'
      beforeSend: (xhrObj) ->
        xhrObj.setRequestHeader('Authorization', $a.usersession.getHeaders()['Authorization'])
        xhrObj.setRequestHeader('DB', $a.usersession.getHeaders()['DB'])

      success: (data) =>
        # remove modal message which disabled screen
        $a.broker.trigger('app:loading_complete')
        if data.success == true
          # TODO: Change this to use JSON ( backbone model parse methods instead of XML)
          beginning = '<?xml version="1.0" encoding="UTF-8"?> <scenario> <settings/> <NetworkSet>'
          data = data.resource.replace('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>', beginning)
          end = '</NetworkSet> <SignalSet/> <SensorSet/> <EventSet/> <ControllerSet/> </scenario>'
          data = data + end
          @displayMap(data)
        else
          # Display Error Message
          messageBox = new $a.MessageWindowView( {text: data.message, okButton: true} )

      error: (xhr, textStatus, errorThrown) =>
        # Remove modal message which disabled screen
        $a.broker.trigger('app:loading_complete')
        # Display Error Message
        messageBox = new $a.MessageWindowView( {text: "Error Loading Network, " + errorThrown, okButton: true} )

      contentType: 'text/json'
      dataType: 'json'
    )

  # Import Network into DB
  _importNetwork: () ->
    if(not @_isNetworkNamed($a.models.network()))
      @_openNetworkEditor AppView.NAME_SAVE_MSG
    else
      # add overlay to disable screen
      messageBox = new $a.MessageWindowView( {text: "Importing Network...", okButton:false} )
      doc = document.implementation.createDocument(null, null, null)
      # Set save mode to db
      $a.fileSaveMode = false

      # one off ajax request to get network from DB in XML form
      # TODO: Implement backbone parse in each model to cascade model creadtion
      # and pass in JSON instead of XML
      $.ajax(
        url: '/via-rest-api/project/1/scenario/1/network/'
        type: 'POST'
        beforeSend: (xhrObj) ->
          xhrObj.setRequestHeader('Authorization', $a.usersession.getHeaders()['Authorization'])
          xhrObj.setRequestHeader('DB', $a.usersession.getHeaders()['DB'])

        success: (data) =>
          # remove modal message which disabled screen
          $a.broker.trigger('app:loading_complete')
          if data.success == true
            # TODO: Change this to use JSON ( backbone model parse methods instead of XML)
            beginning = '<?xml version="1.0" encoding="UTF-8"?> <scenario> <settings/> <NetworkSet>'
            data = data.resource.replace('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>', beginning)
            end = '</NetworkSet> <SignalSet/> <SensorSet/> <EventSet/> <ControllerSet/> </scenario>'
            data = data + end
            @displayMap(data)
          else
            # Display Error Message
            messageBox = new $a.MessageWindowView( {text: data.message, okButton: true} )

        error: (xhr, textStatus, errorThrown) =>
          # Remove modal message which disabled screen
          $a.broker.trigger('app:loading_complete')
          # Display Error Message
          messageBox = new $a.MessageWindowView( {text: "Error Importing Network, " + errorThrown, okButton: true} )

        contentType: 'text/json'
        dataType: 'json'
        # TODO: Data should be changed to be JSON
        data: new XMLSerializer().serializeToString($a.models.network().to_xml(doc))
      )
  
  # Save Network into DB
  _saveNetwork: () ->
    if(not @_isNetworkNamed($a.models.network()))
      @_openNetworkEditor AppView.NAME_SAVE_MSG
    else
      # add overlay to disable screen
      messageBox = new $a.MessageWindowView( {text: "Saving Network...", okButton:false} )
      doc = document.implementation.createDocument(null, null, null)
      # Set save mode to db, so that xml is formatted with CRUDFlag and modstamps
      $a.fileSaveMode = false

      # one off ajax request to get network from DB in XML form
      # TODO: Implement backbone parse in each model to cascade model creadtion
      # and pass in JSON instead of XML
      $.ajax(
        url: '/via-rest-api/project/1/scenario/1/network/' +  $a.models.network().get('id')
        type: 'PUT'
        beforeSend: (xhrObj) ->
          xhrObj.setRequestHeader('Authorization', $a.usersession.getHeaders()['Authorization'])
          xhrObj.setRequestHeader('DB', $a.usersession.getHeaders()['DB'])

        success: (data) =>
          # remove modal message which disabled screen
          $a.broker.trigger('app:loading_complete')
          if data.success == true
            # TODO: Change this to use JSON ( backbone model parse methods instead of XML)
            beginning = '<?xml version="1.0" encoding="UTF-8"?> <scenario> <settings/> <NetworkSet>'
            data = data.resource.replace('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>', beginning)
            end = '</NetworkSet> <SignalSet/> <SensorSet/> <EventSet/> <ControllerSet/> </scenario>'
            data = data + end
            @displayMap(data)
          else
            # Display Error Message
            messageBox = new $a.MessageWindowView( {text: data.message, okButton: true} )

        error: (xhr, textStatus, errorThrown) =>
          # Remove modal message which disabled screen
          $a.broker.trigger('app:loading_complete')
          # Display Error Message
          messageBox = new $a.MessageWindowView( {text: "Error Saving Network, " + errorThrown, okButton: true} )

        contentType: 'text/json'
        dataType: 'json'
        # TODO: Data should be changed to be JSON
        data: new XMLSerializer().serializeToString($a.models.network().to_xml(doc))
      )

  # Load Scenario From DB
  _loadScenario: (scenarioId) ->
    # add overlay to disable screen
    messageBox = new $a.MessageWindowView( {text: "Loading Scenario...", okButton: false} )
    # one off ajax request to get scenario from DB in XML form
    # TODO: Implement backbone parse in each model to cascade model creadtion
    # and pass in JSON instead of XML
    $.ajax(
      url: '/via-rest-api/project/1/scenario/' + scenarioId
      type: 'GET'
      beforeSend: (xhrObj) ->
        xhrObj.setRequestHeader('Authorization', $a.usersession.getHeaders()['Authorization'])
        xhrObj.setRequestHeader('DB', $a.usersession.getHeaders()['DB'])

      success: (data) =>
        # remove modal message which disabled screen
        $a.broker.trigger('app:loading_complete')
        if data.success == true
          @displayMap(data.resource)
        else
          # Display Error Message
          messageBox = new $a.MessageWindowView( {text: data.message, okButton: true} )

      error: (xhr, textStatus, errorThrown) =>
        # Remove modal message which disabled screen
        $a.broker.trigger('app:loading_complete')
        # Display Error Message
        messageBox = new $a.MessageWindowView( {text: "Error Loading Scenario, " + errorThrown, okButton: true} )

      contentType: 'text/json'
      dataType: 'json'
    )

  # Load PEMS From DB
  _loadPEMS: (pos) ->
    # add overlay to disable screen
    doc = document.implementation.createDocument(null, null, null)
    msg = {text: "Loading PEMS...", okButton: false}
    messageBox = new $a.MessageWindowView(msg)
    # one off ajax request to get pems from DB in JSON form
    $.ajax(
      url: '/via-rest-api/project/0/scenario/0/pems'
      type: 'POST'
      beforeSend: (xhrObj) ->
        auth = $a.usersession.getHeaders()['Authorization']
        xhrObj.setRequestHeader('Authorization', auth)
        xhrObj.setRequestHeader('DB', $a.usersession.getHeaders()['DB'])

      success: (data) =>
        # remove modal message which disabled screen
        $a.broker.trigger('app:loading_complete')
        if data.success == true
          # First check if sensor set already exists
          set = $a.models.sensor_set()
          # set crud flag to update
          set.set_crud_flag(window.beats.CrudFlag.UPDATE)
          moSensors = $($.parseXML(data.resource)).children()
          set = $a.SensorSet.from_xml1(moSensors, set)
          set.sensors().forEach((sensor) => 
            flag = $a.models.sensor_set().containsPemsSensor(sensor)
            if(!flag)
              sensor.id = sensor.sensor_id_original()
              $a.sensorList.addSensor(sensor)
          )
        else
          # Display Error Message
          msg = {text: data.message, okButton: true}
          messageBox = new $a.MessageWindowView(msg)

      error: (xhr, textStatus, errorThrown) =>      
        # Remove modal message which disabled screen
        $a.broker.trigger('app:loading_complete')
        # Display Error Message
        msg = {text: "Error Loading PEMS, " + errorThrown, okButton: true}
        messageBox = new $a.MessageWindowView(msg)
      
      contentType: 'application/json'
      dataType: 'json'
      data: new XMLSerializer().serializeToString(pos.to_xml(doc))
    )

  # Save scenario set information one by one to DB
  _saveScenario: () ->
    scenario = $a.models
    if(not @_isScenarioNamed(scenario))
      @_openScenarioEditor AppView.NAME_SAVE_MSG
    else if(not @_isNetworkNamed(scenario.network()))
      @_openNetworkEditor AppView.NAME_SAVE_MSG
    else
      # make sure all sets have a name, description and project id
      scenario.copy_info_to_sets()

      # set up ajax request handler to save modified scenario sets
      ajaxRequests = new $a.AjaxRequestHandler()
      fdSet = scenario.fundamentaldiagram_set()
      splitRatioSet = scenario.splitratio_set()
      demandSet = scenario.demand_set()
      sensorSet = scenario.sensor_set()

      # if there is a fd set add to request
      if fdSet?
        ajaxRequests.createSaveFDSetRequest(fdSet)

      # if there is a split ratio set add to request
      if splitRatioSet?
        ajaxRequests.createSaveSplitRatioSetRequest(splitRatioSet)

      # if there is a demand set, add to request
      if demandSet?
        ajaxRequests.createSaveDemandSetRequest(demandSet)

      # if there is a sensor set, add to request
      if sensorSet? and sensorSet.sensors().length != 0
        ajaxRequests.createSaveSensorSetRequest(sensorSet)

      # ensure any changes to scenario's attributes are updated
      ajaxRequests.createSaveScenarioRequest(scenario)
      
      # now process queue of ajax requests
      if ajaxRequests.requestQueue.length > 0
        ajaxRequests.processRequests()
      else
        message = new $a.MessageWindowView( {text: "No scenario changes to save.", okButton: true} )

  # Import new scenario
  _importScenario: () ->
    # if scenario does not have a name or a project id
    if(not @_isScenarioNamed($a.models))
      @_openScenarioEditor AppView.NAME_SAVE_MSG
    else if (not @_isScenarioProject($a.models))
      @_openScenarioEditor AppView.PROJECT_SAVE_MSG
    else
      scenario = $a.models
      # make sure all sets have a name, description and project id
      scenario.copy_info_to_sets()

      # set up ajax request handler to import whole senario
      ajaxRequest = new $a.AjaxRequestHandler()
      ajaxRequest.createImportScenarioRequest(scenario)
      ajaxRequest.processRequests()
