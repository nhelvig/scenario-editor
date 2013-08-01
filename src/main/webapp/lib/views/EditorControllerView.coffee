# This creates the editor dialogs for controller elements
class window.beats.EditorControllerView extends window.beats.EditorView 
  $a = window.beats
  
  events : {
    'blur #controller_type' : 'save' 
    'blur #controller_hour, #controller_minute, #controller_second' : 'saveTime'
    'click #display-at-pos' : 'displayAtPos'
    'click #target-editor' : 'editTargets' 
    'click #feedback-editor' : 'editFeedback'
  }    
  
  # the options argument has the Controller model and type of dialog to
  # create('controller')
  initialize: (options) ->
    options.templateData = @_getTemplateData(options.models)
    # create target list of first selected controller
    # first check if a controller is defined
    controller = options.models[0]
    target = null
    feedback = null
    if controller
      target = controller.get_target_elements()
      feedback = controller.get_target_elements()
    @targetList = new $a.ScenarioElementCollection(target?.get('scenarioElement') || [])
    @feedbackList = new $a.ScenarioElementCollection(feedback?.get('scenarioElement') || [])
    super options

  # call the super class to set up the dialog box and then set select boxes
  # and setup datatables
  render: ->
    super @elem
    @_setSelectedType()
    @renderTargetTable()
    @renderFeedbackTable()
    @_checkMode()
    # Add event to map target table
    @
  
  # Set selected type element for controller type and controller format
  _setSelectedType: ->
    type = @models[0].get('type')
    $("#controller_type > option[value='#{type}']").attr('selected','selected')

  # Draw Table which lists target elements 
  renderTargetTable: ->
    @conTable = $('#controller-target-table').dataTable( {
        "aaData": @_getFeedbackData,
        "aoColumns": [
            { "sTitle": "Id","sWidth": "50%"},
            { "sTitle": "Type","sWidth": "50%"},
        ],
        "aaSorting": [[ 0, "desc" ]]
        "bPaginate": false,
        "bLengthChange": true,
        "bFilter": false,
        "bSort": true,
        "bInfo": false,
        "bAutoWidth": false,
        "bJQueryUI": true,
    })

  # Draw Controller Feedback Table 
  renderFeedbackTable: ->
    @feedbackTable = $('#controller-feedback-table').dataTable( {
        "aaData": @_getTargetData,
        "aoColumns": [
            { "sTitle": "Id","sWidth": "50%"},
            { "sTitle": "Type","sWidth": "50%"},
        ],
        "aaSorting": [[ 0, "desc" ]]
        "bPaginate": false,
        "bLengthChange": true,
        "bFilter": false,
        "bSort": true,
        "bInfo": false,
        "bAutoWidth": false,
        "bJQueryUI": true,
    })

  # Draw Controller Parameters Table 
  renderParameterTable: ->
    @paramTable = $('#controller-parameter-table').dataTable( {
        "aaData": [["test", "test"]],
        "aoColumns": [
            { "sTitle": "Name","sWidth": "50%"},
            { "sTitle": "Value","sWidth": "50%"},
        ],
        "aaSorting": [[ 0, "desc" ]]
        "bPaginate": false,
        "bLengthChange": true,
        "bFilter": false,
        "bSort": true,
        "bInfo": false,
        "bAutoWidth": false,
        "bJQueryUI": true,
    })


  # set up a hash of values from the model and inserted into the html template
  _getTemplateData: (models) ->
    #dt = models[0].get('data_sources').get('data_source')[0].get('dt')
    { 
      #description: $a.Util.getDesc(models)
      #lat: $a.Util.getGeometry({models:models, geom:'lat'})
      #lng: $a.Util.getGeometry({models:models, geom:'lng'})
      #elev: $a.Util.getGeometry({models:models, geom:'elevation'})
      #url: _.map(models, (m) -> 
      #        m.get('data_sources').get('data_source')[0].get('url')).join('; ')
      #url_desc: URL_DESC
      dt: $a.Util.convertSecondsToHoursMinSec(cp?.get('dt') || 0)
      #links: _.map(models, (m) -> m.get('link_reference').get('id')).join('; ')
    }
  
  # these are callback events for various elements in the interface
  # This is used to save the all the fields when focus is lost from
  # the element
  save: (e) ->
    id = e.currentTarget.id
    fieldId = @_getFieldId(id)
    _.each(@models, (m) -> m.set(fieldId, $("##{id}").val()))
  
  # saves the dt field -- first converts h, m, s to seconds
  saveTime: (e) ->
    dt = {
      'h': $("#controller_hour").val()
      'm': $("#controller_minute").val()
      's': $("#controller_second").val()
    }
    _.each(@models, (m) ->
                      p = m.get('data_sources').get('data_source')[0]
                      p?.set('dt', $a.Util.convertToSeconds(dt))
    )
  
  _getFieldId: (id) ->
    id = id[7...] if id.indexOf("controller") is 0
    id
  
  # grab the target table column data
  _getTargetData: () ->
    @targetList.getEditorColumnData()

  # grab the feedback table column data for the 
  _getFeedbackData: () ->
    @feedbackList.getEditorColumnData()

  # grab the column data for the browser table  
  _getParameterData: () ->
    $a.controllerSet.getEditorParameterColumnData

  displayAtPos: (e) ->
    e.p#reventDefault()

  # Edit Target Scenario Elements
  editTargets: () ->
    # Triggers event to minimize the editor or browser window 
    # to bottom of parent window
    $a.broker.trigger('app:minimize-dialog')
    # clear all selected/highlighted scenario elements 
    $a.broker.trigger('app:unselect_links')

    # highlight selected scenario elements
    _.each(@targetElements, (targetElement) ->
      targetElement.selectScenarioElements()
    )
    # turn on event listener which adds elements when selected 
    # and removed when not selected
    

  # Edit Feedback Scenario Elements
  editFeedback: () ->
    # Triggers event to minimize the editor or browser window 
    # to bottom of parent window
    $a.broker.trigger('app:minimize-dialog')
    # clear all selected/highlighted scenario elements 
    $a.broker.trigger('app:unselect_links')
    # highlight selected scenario elements
    