# This handles all Ajax Requests to Via REST API for nested backbone models since
# no backbone functionality exists to sync nested models to the database without
# sending multiple ajax requests which will result in non-transactional save
# attempts.  Hence, here we define a generic jquery ajax request which can be used on
# backbone nested model entities (Network, FD Set, Split Ratio Set, Sensor Set, Demand Set, etc.)
# which for saves we assume CrudFlag has been properly set for all changed models.
# Note: For performance reasons saving a scenario will execute one Ajax request per set entity which
# has changed (CRUDFlag)
class window.beats.AjaxRequestHandler

  $a = window.beats

  # Contructor, sets message box to null and allows for queue of
  # request(s) to processed by first calling relevent createRequest
  # methods below and then processRequest method
  constructor: () ->
    # initialize class global message box variable to null
    @messageBox = null
    # Array of request queue
    @requestQueue = []

  # Processes ajax request
  processRequests : () ->
    instance = @
    # first check if user is logged in
    if $a.usersession? and $a.usersession.isAuthenticated()
      # if request still exists in queue
      if @requestQueue.length > 0
        request = @requestQueue.pop()
        # add overlay message to disable screen if not already added
        if @messageBox is null
          @messageBox = new $a.MessageWindowView( {text: request.messageText, okButton: false} )
        # otherwise add text to existing message box
        else
          @messageBox.addToMessage(request.messageText)
        # one off ajax request to save FDSet to DB from XML model
        # TODO: Implement backbone parse in each model to cascade model creation
        # and pass in JSON instead of XML
        $.ajax(
          url: request.url
          type: request.type
          beforeSend: (xhrObj) ->
            xhrObj.setRequestHeader('Authorization', $a.usersession.getHeaders()['Authorization'])
            xhrObj.setRequestHeader('DB', $a.usersession.getHeaders()['DB'])
          success: (data) =>
            if data.success == true
              # Set save mode to db, so that xml is formatted with CRUDFlag and modstamps
              $a.fileSaveMode = false
              request.success(data.resource)
              @messageBox.addToMessage(data.message)
            else
              # Display Error Message
              @messageBox.addToMessage(request.errorMessage + data.message)

          error: (xhr, textStatus, errorThrown) =>
            # Display Error Message
            @messageBox.addToMessage(request.errorMessage + errorThrown)
          contentType:'application/json'
          dataType: 'json'
          data: request.data
        # After ajax Request, try and execute next one in queue on success and failure
        ).then(
          () ->
            instance.processRequests()
          ,() ->
            instance.processRequests()
        )
      # otherwise no requests left to be processed, add ok button to message box
      else
        @messageBox.addOKButton()
    # otherwise user is not logged in, show error message
    else
      @messageBox = new $a.MessageWindowView( {text: "Error must be logged in to Save to Via.", okButton: true} )

  # Creates Request object for FDSet Request and adds it to request queue
  createSaveFDSetRequest : (fdSet) ->
    # only create request if FD set has changed
    if fdSet.crud() == $a.CrudFlag.UPDATE or fdSet.crud() == $a.CrudFlag.CREATE
      # get project id of fd set otherwise from senario
      projectId = if fdSet.project_id()? then fdSet.project_id() else $a.models.project_id()
      scenarioId = if $a.models.ident()? then $a.models.ident() else 0
      fdSet.set_project_id(projectId)
      request = {}

      # Choose which REST API method based on CRUD Flag
      if fdSet.crud() == $a.CrudFlag.CREATE
        request.url = $a.RESTURL + '/project/' + projectId + '/scenario/' + scenarioId + '/fdset/'
        request.type = 'POST'
      else if fdSet.crud() == $a.CrudFlag.UPDATE
        request.url = $a.RESTURL + '/project/' + projectId + '/scenario/' + scenarioId + '/fdset/' + fdSet.ident()
        request.type = 'PUT'

      request.errorMessage = '<span style="color: red;">Error saving FD Set:</span> '
      request.messageText = '<b>Saving FD Set...</b> '
      # Define Success callback method, which updateds FD Set in backbone models with new DB ids
      request.success = (resource) ->
        xml = $.parseXML(resource)
        $a.models.set_fundamentaldiagram_set($a.FundamentalDiagramSet.from_xml1($(xml).children(), $a.models.object_with_id))
      # Serialize FDSet to xml to pass to rest API
      doc = document.implementation.createDocument(null, null, null)
      request.data = new XMLSerializer().serializeToString(fdSet.to_xml(doc))

      @requestQueue.push(request)

  # Creates Request object for Split Ratio Set Request and adds it to request queue
  createSaveSplitRatioSetRequest : (splitSet) ->
    # only create request if Split Ratio set has changed
    if splitSet.crud() == $a.CrudFlag.UPDATE or splitSet.crud() == $a.CrudFlag.CREATE
      # get project id of split ratio set otherwise from senario
      projectId = if splitSet.project_id()? then splitSet.project_id() else $a.models.project_id()
      scenarioId = if $a.models.ident()? then $a.models.ident() else 0
      splitSet.set_project_id(projectId)
      request = {}

      # Choose which REST API method based on CRUD Flag
      if splitSet.crud() == $a.CrudFlag.CREATE
        request.url = $a.RESTURL + '/project/' + projectId + '/scenario/' + scenarioId + '/splitratioset/'
        request.type = 'POST'
      else if splitSet.crud() == $a.CrudFlag.UPDATE
        request.url = $a.RESTURL + '/project/' + projectId + '/scenario/' + scenarioId + '/splitratioset/' + splitSet.ident()
        request.type = 'PUT'

      request.errorMessage = '<span style="color: red;">Error Saving Split Ratio Set:</span> '
      request.messageText = '<b>Saving Split Ratio Set...</b> '
      # Define Success callback method, which updateds Split Ratio Set in backbone models with new DB ids
      request.success = (resource) ->
        xml = $.parseXML(resource)
        $a.models.set_splitratio_set($a.SplitRatioSet.from_xml1($(xml).children(), $a.models.object_with_id))
      # Serialize Split Ratio Set to xml to pass to rest API
      doc = document.implementation.createDocument(null, null, null)
      request.data = new XMLSerializer().serializeToString(splitSet.to_xml(doc))

      @requestQueue.push(request)

  # Creates Request object for Demand Set Request and adds it to request queue
  createSaveDemandSetRequest : (demandSet) ->
    # only create request if Demand set has changed
    if demandSet.crud() == $a.CrudFlag.UPDATE or demandSet.crud() == $a.CrudFlag.CREATE
      # get project id of demand set otherwise from senario
      projectId = if demandSet.project_id()? then demandSet.project_id() else $a.models.project_id()
      scenarioId = if $a.models.ident()? then $a.models.ident() else 0
      demandSet.set_project_id(projectId)
      request = {}

      # Choose which REST API method based on CRUD Flag
      if demandSet.crud() == $a.CrudFlag.CREATE
        request.url = $a.RESTURL + '/project/' + projectId + '/scenario/' + scenarioId + '/demandset/'
        request.type = 'POST'
      else if demandSet.crud() == $a.CrudFlag.UPDATE
        request.url = $a.RESTURL + '/project/' + projectId + '/scenario/' + scenarioId + '/demandset/' + demandSet.ident()
        request.type = 'PUT'

      request.errorMessage = '<span style="color: red;">Error Saving Demand Set:</span> '
      request.messageText = '<b>Saving Demand Set...</b> '
      # Define Success callback method, which updateds Demand  Set in backbone models with new DB ids
      request.success = (resource) ->
        xml = $.parseXML(resource)
        $a.models.set_demand_set($a.DemandSet.from_xml1($(xml).children(), $a.models.object_with_id))
      # Serialize Demand  Set to xml to pass to rest API
      doc = document.implementation.createDocument(null, null, null)
      request.data = new XMLSerializer().serializeToString(demandSet.to_xml(doc))

      @requestQueue.push(request)

  # Creates Request object for Sensor Set Request and adds it to request queue
  createSaveSensorSetRequest : (sensorSet) ->
    # only create request if Sensor set has changed
    if sensorSet.crud() == $a.CrudFlag.UPDATE or sensorSet.crud() == $a.CrudFlag.CREATE
      # get project id of Sensor set otherwise from senario
      projectId = if sensorSet.project_id()? then sensorSet.project_id() else $a.models.project_id()
      scenarioId = if $a.models.ident()? then $a.models.ident() else 0
      sensorSet.set_project_id(projectId)
      request = {}

      # Choose which REST API method based on CRUD Flag
      if sensorSet.crud() == $a.CrudFlag.CREATE
        request.url = $a.RESTURL + '/project/' + projectId + '/scenario/' + scenarioId + '/sensorset/'
        request.type = 'POST'
      else if sensorSet.crud() == $a.CrudFlag.UPDATE
        request.url = $a.RESTURL + '/project/' + projectId + '/scenario/' + scenarioId + '/sensorset/' + sensorSet.ident()
        request.type = 'PUT'

      request.errorMessage = '<span style="color: red;">Error Saving Sensor Set:</span> '
      request.messageText = '<b>Saving Sensor Set...</b> '
      # Define Success callback method, which updateds Demand  Set in backbone models with new DB ids
      request.success = (resource) ->
        xml = $.parseXML(resource)
        $a.models.set_sensor_set($a.SensorSet.from_xml1($(xml).children(), $a.models.object_with_id))
        # clear old sensor list collection and sensors from map, add new ones
        $a.sensorList.clear()
        $a.sensorListView.clear()
        $a.sensorList = new $a.SensorListCollection($a.models.sensors())
        $a.sensorListView = new $a.SensorListView($a.sensorList)
        $a.sensorListView.render()

      # Serialize Sensor Set to xml to pass to rest API
      doc = document.implementation.createDocument(null, null, null)
      request.data = new XMLSerializer().serializeToString(sensorSet.to_xml(doc))

      @requestQueue.push(request)

  # Creates Request object to update scenario and adds it to request queue
  createSaveScenarioRequest : (scenario) ->
    request = {}
    projectId = scenario.project_id()
    sId = scenario.ident()

    # request URL
    request.url = $a.RESTURL + '/project/' + projectId + '/scenario/'  + sId
    request.type = 'PUT'
    # request messaging
    request.errorMessage = '<span style="color: red;">Error Saving Scenario ' +
      'Attributes:</span> '
    request.messageText = '<b>Saving Scenario...</b> Note: This may timeout ' + 
      'if scenario is quite large. Check back later by trying to open ' +
      'scenario from DB.'
      
    # Define Success callback method, which updateds Scenario in backbone 
    # models with new DB ids
    request.success = (resource) ->
      # reload scenario
      $a.models = {}
      xml = $.parseXML(resource)
      $a.models = $a.Scenario.from_xml($(xml).children())

    # Serialize Scenario to xml to pass to rest API
    doc = document.implementation.createDocument(null, null, null)
    request.data = new XMLSerializer().serializeToString(scenario.to_xml(doc))

    @requestQueue.push(request)
  
  # Creates Request object to import scenario and adds it to request queue
  createImportScenarioRequest : (scenario) ->
    request = {}
    projectId = scenario.project_id()

    # request URL
    request.url = $a.RESTURL + '/project/' + projectId + '/scenario/'
    request.type = 'POST'
    # request messaging
    request.errorMessage = '<span style="color: red;">Error Saving New Scenario:</span> '
    request.messageText = '<b>Saving New Scenario...</b> Note: This may timeout if scenario is quite large. ' +
      'Check back later by trying to open scenario from DB.'
    # Define Success callback method, which updateds Scenario in backbone models with new DB ids
    request.success = (resource) ->
      # reload scenario
      $a.models = {}
      xml = $.parseXML(resource)
      $a.models = $a.Scenario.from_xml($(xml).children())

    # Serialize Scenario to xml to pass to rest API
    doc = document.implementation.createDocument(null, null, null)
    request.data = new XMLSerializer().serializeToString(scenario.to_xml(doc))

    @requestQueue.push(request)