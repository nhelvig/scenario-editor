# This creates the editor dialogs for node elements
class window.sirius.EditorLinkView extends window.sirius.EditorView
  $a = window.sirius
  events : {
    'blur #name, #description, #type' : 'save'
    'blur #lat, #lng, #elevation' : 'saveGeo'
    'click #lock' : 'saveLocked'
    'click #edit-signal' : 'signalEditor'
    'click #choose-name' : 'chooseName'
    'click #remove-join-links' : 'removeJoinLinks'
  }
  
  # the options argument has the Node model and type of dialog to create('node')
  initialize: (options) ->
    console.log options.model

    options.templateData = @_getTemplateData(options.model)
    super options
    #set selected type element
    elem = _.filter($(@$el[0]).find("select option"), (item) =>
              $(item).val() is options.model.get('type')
            )
    $(elem[0]).attr('selected', true)

  # call the super class to set up the dialog box
  render: ->
    super @elem
    @

  # creates a hash of values taken from the model for the html template
  _getTemplateData: (model) ->
    fd = model.get('fundamentaldiagramprofile').get('fundamentaldiagram')[0]
    cp = model.get('capacity')?.get('capacity')[0] || null
    dp = model.get('demand')?.get('demand')[0] || null
    
    name: model.get('name')
    description: model.get('description').get('text')
    roadName: model.get('road_name')
    record: if model.has('record') and model.get('record') then 'checked' else ''
    lanes: model.get('lanes')
    laneOffset: model.get('lane_offset')
    length: model.get('length')
    queue: model.get('queue') || ''
    capacity: fd?.get('capacity') || ''
    jamDensity: fd?.get('jam_density') || ''
    capacityDrop: fd?.get('capacity_drop') || ''
    criticalDensity: fd?.get('critical_density') || ''
    capacityStartHour: cp?.get('start_hour') || ''
    capacityStartMinute: cp?.get('start_min') || ''
    capacityStartSecond: cp?.get('start_sec') || ''
    capacitySampleHour: cp?.get('sample_hour') || ''
    capacitySampleMinute: cp?.get('sample_min') || ''
    capacitySampleSecond: cp?.get('sample_sec') || ''
    capacityProfile: cp?.get('text') || ''
    coefficient: dp?.get('coefficient') || ''
    demandStartHour: dp?.get('start_hour') || ''
    demandStartMinute: dp?.get('start_min') || ''
    demandStartSecond: dp?.get('start_sec') || ''
    demandSampleHour: dp?.get('sample_hour') || ''
    demandSampleMinute: dp?.get('sample_min') || ''
    demandSampleSecond: dp?.get('sample_sec') || ''
    demandProfile: dp?.get('text') || ''
    

  # these are callback events for various elements in the interface
  # This is used to save the name, type and description when focus is
  # lost from the element
  save: (e) ->
    id = e.currentTarget.id
    @model.set(id, $("##{id}").val())

  # This is used to save the latitude, longitude and elevation when focus is
  # lost from the element
  saveGeo: (e) ->
    id = e.currentTarget.id
    @model.get('position').get('point')[0].set(id, $("##{id}").val())

  # This saves the checkbox indicating the node is locked
  saveLocked: (e) ->
    id = e.currentTarget.id
    @model.set(id, $("##{id}").prop('checked'))

  # These three methods below will be configured to launch various
  # editors in future phases
  signalEditor: (e) ->
    e.preventDefault()

  chooseName: (e) ->
    e.preventDefault()

  removeJoinLinks: (e) ->
    e.preventDefault()
