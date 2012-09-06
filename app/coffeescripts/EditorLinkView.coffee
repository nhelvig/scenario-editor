# This creates the editor dialogs for node elements
class window.sirius.EditorLinkView extends window.sirius.EditorView
  $a = window.sirius
  events : {
    'blur #link_name, #road_name, #link_type' : 'save'
    'blur #lanes, #lane_offset, #length, #queue_limit' : 'save'
    'blur #capacity, 
      #capacity_drop,
      #jam_density,
      #free_flow_speed,
      #congestion_speed,
      #std_dev_capacity,
      #std_dev_free_flow_speed': 'saveFD'
    'blur #knob, #text': 'saveDP'
    'blur #link_demand_start_hour, 
      #link_demand_start_minute, 
      #link_demand_start_second,
      #link_demand_sample_hour, 
      #link_demand_sample_minute, 
      #link_demand_sample_second' : 'saveDPTime'
    'blur #capacity_profile': 'saveCP'
    'blur #link_capacity_start_hour, 
      #link_capacity_start_minute, 
      #link_capacity_start_second,
      #link_capacity_sample_hour, 
      #link_capacity_sample_minute, 
      #link_capacity_sample_second' : 'saveCPTime'
    'blur #description' : 'saveDesc'
    'click #record' : 'saveRecord'
    'click #do-subdivide' : 'subDivide'
    'click #do-split': 'doSplit'
    'click #add-lt' : 'addLeftTurn'
    'click #add-rt' : 'addRightTurn'
    'click #choose-name' : 'chooseName'
    'click #reverse-link' : 'reverseLink'
    'click #geom-line' : 'geomLine'
    'click #geom-road' : 'geomRoad'
  }

  # the options argument has the Node model and type of dialog to create('node')
  initialize: (options) ->
    window.test = options.model
    options.templateData = @_getTemplateData(options.model)
    super options
    @_setSelectedType()

  # call the super class to set up the dialog box and tabs
  # upon initializations of tabs you disable tabs that are not needed
  render: ->
    super @elem
    @_checkDisableTabs()
    @
  
  #set selected type element
  _setSelectedType: ->
    elem = _.filter($(@$el[0]).find("select option"), (item) =>
              $(item).val() is @model.get('type')
            )
    $(elem[0]).attr('selected', true)
  
  # if tab doesn't have one of the profiles disable it
  _checkDisableTabs: ->
    disable = []
    disable.push(2) if !@model.get('fundamentaldiagramprofile')?
    disable.push(4) if !@model.get('capacityprofile')?
    disable.push(3) if !@model.get('demand')?
    @$el.tabs({ disabled: disable })

  # creates a hash of values taken from the model for the html template
  # I could have just passed the model but I did it this way because 
  # I didn't want the long retrieval lines in the html.
  _getTemplateData: (model) ->
    fdp = model.get('fundamentaldiagramprofile')
    fd = fdp?.get('fundamentaldiagram')[0] || null
    cp = model.get('capacity') || null
    dp = model.get('demand') || null
    
    name: model.get('name')
    description: model.get('description').get('text')
    roadName: model.get('road_name')
    record: if model.has('record') and model.get('record') then 'checked' else ''
    lanes: model.get('lanes')
    laneOffset: model.get('lane_offset')
    length: model.get('length')
    freeFlowSpeed: fd?.get('free_flow_speed') || ''
    capacity: fd?.get('capacity') || ''
    jamDensity: fd?.get('jam_density') || ''
    capacityDrop: fd?.get('capacity_drop') || ''
    congestionSpeed: fd?.get('congestion_speed') || ''
    capacityStandardDev: fd?.get('std_dev_capacity') || ''
    freeFlowStandardDev: fd?.get('std_dev_free_flow') || ''
    cpStartTime: $a.Util.convertSecondsToHoursMinSec(cp?.get('start_time') || 0)
    cpSampleTime: $a.Util.convertSecondsToHoursMinSec(cp?.get('dt') || 0)
    capacityProfile: cp?.get('text') || ''
    knob: dp?.get('knob') || ''
    dpStartTime: $a.Util.convertSecondsToHoursMinSec(dp?.get('start_time') || 0)
    dpSampleTime: $a.Util.convertSecondsToHoursMinSec(dp?.get('dt') || 0)
    demandProfile: dp?.get('text') || ''

  # these are callback events for various elements in the interface
  # This is used to save the name, type and description when focus is
  # lost from the element. Note: in order to avoid id conflicts with other
  # editors I append the type some ids -- it needs to be stripped off
  # in the fieldId
  save: (e) ->
    id = e.currentTarget.id
    fieldId = id
    fieldId = id[5...] if id.indexOf("link") is 0
    @model.set(fieldId, $("##{id}").val())

  # this method saves the description
  saveDesc: (e) ->
    id = e.currentTarget.id
    @model.get('description').set('text', $("##{id}").val())

  # This saves the checkbox indicating the state of the link's record field
  saveRecord: (e) ->
    id = e.currentTarget.id
    @model.set(id, $("##{id}").prop('checked'))
    
  # this saves fields in the fundamental diagram
  saveFD: (e) ->
    id = e.currentTarget.id
    ps = @model.get('fundamentaldiagramprofile')
    p = ps?.get('fundamentaldiagram')[0]
    p?.set(id, $("##{id}").val())
  
  # this saves fields in the demand profiles
  saveDP: (e) ->
    args = {
        id: e.currentTarget.id
        profile: 'demand'
      }
    @_saveProfileData(args)
  
  saveDPTime: ->
    args = {profile: 'demand'}
    @_saveProfileTimeData(args)
  
  # this saves fields in the capacity profiles
  saveCP: (e) ->
    args = {
        id: e.currentTarget.id
        profile: 'capacity'
      }
    @_saveProfileData(args)
  
  saveCPTime: ->
    args = {profile: 'capacity'}
    @_saveProfileTimeData(args)
  
  # save profile data
  _saveProfileData: (args) ->
    id = args.id
    p = @model.get(args.profile)
    p?.set(id, $("##{id}").val())
    
  _saveProfileTimeData: (args) ->
    p = @model.get(args.profile)
    start = {
      'h': $("#link_#{args.profile}_start_hour").val()
      'm': $("#link_#{args.profile}_start_minute").val()
      's': $("#link_#{args.profile}_start_second").val()
    }
    sample = {
      'h': $("#link_#{args.profile}_sample_hour").val()
      'm': $("#link_#{args.profile}_sample_minute").val()
      's': $("#link_#{args.profile}_sample_second").val()
    }

    p?.set('start_time', $a.Util.convertToSeconds(start))
    p?.set('dt', $a.Util.convertToSeconds(sample))
  
  # These methods below will be configured to launch functions
  # in future phases
  doSplit: (e) ->
    e.preventDefault()

  addLeftTurn: (e) ->
    e.preventDefault()

  addRightTurn: (e) ->
    e.preventDefault()

  chooseName: (e) ->
    e.preventDefault()

  reverseLink: (e) ->
    e.preventDefault()

  geomLine: (e) ->
    e.preventDefault()

  geomRoad: (e) ->
    e.preventDefault()
