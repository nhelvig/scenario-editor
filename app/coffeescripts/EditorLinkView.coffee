# This creates the editor dialogs for node elements
class window.sirius.EditorLinkView extends window.sirius.EditorView
  $a = window.sirius
  events : {
    'blur #link_name, #road_name, #link_type' : 'save'
    'blur #lanes, #lane_offset, #length' : 'save'
    'blur #capacity, 
      #capacity_drop,
      #jam_density,
      #free_flow_speed,
      #congestion_speed,
      #std_dev_capacity,
      #std_dev_free_flow_speed': 'saveFD'
    'blur #knob, #dp_text': 'saveDP'
    'blur #link_demand_start_hour, 
      #link_demand_start_minute, 
      #link_demand_start_second,
      #link_demand_sample_hour, 
      #link_demand_sample_minute, 
      #link_demand_sample_second' : 'saveDPTime'
    'blur #cp_text': 'saveCP'
    'blur #link_capacity_start_hour, 
      #link_capacity_start_minute, 
      #link_capacity_start_second,
      #link_capacity_sample_hour, 
      #link_capacity_sample_minute, 
      #link_capacity_sample_second' : 'saveCPTime'
    'blur #description' : 'saveDesc'
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
    options.templateData = @_getTemplateData(options.models)
    super options
  
  # call the super class to set up the dialog box and tabs
  # upon initializations of tabs you disable tabs that are not needed
  render: ->
    super @elem
    @_checkDisableTabs()
    @_checkDisableFields()
    @_setSelectedType()
    @
  
  #set selected type element
  _setSelectedType: ->
    type = @models[0].get('type');
    $(@$el[0]).find("select option[value='#{type}']").attr('selected','selected')
  
  # if tab doesn't have one of the profiles disable it
  _checkDisableTabs: ->
    disable = []
    disable.push(2) if !@models[0].get('fundamentaldiagramprofile')?
    disable.push(3) if !@models[0].get('demand')? or @models.length > 1
    disable.push(4) if !@models[0].get('capacityprofile')? or @models.length > 1
    disable.push(5)
    @$el.tabs({ disabled: disable })

  # if in browser we diable some fields from being editted
  _checkDisableFields: ->
    if (@models.length > 1)
      $('#link_name').attr("disabled", true)
      $('#length').attr("disabled", true)
  
  # creates a hash of values taken from the model for the html template
  # I could have just passed the model but I did it this way because 
  # I didn't want the long retrieval lines in the html.
  _getTemplateData: (models) ->
    cp = models[0].get('capacity') || null if models.length == 1
    dp = models[0].get('demand') || null if models.length == 1
    
    fds = _.map(models, (m) ->
                  fdp = m.get('fundamentaldiagramprofile')
                  fdp?.get('fundamentaldiagram')[0] || null
          )
    name: _.map(models, (m) -> m.get('name')).join(", ")
    description: _.map(models, (m) -> m.get('description').get('text')).join("; ")
    roadName: _.map(models, (m) -> m.get('road_name')).join(", ")
    lanes: _.map(models, (m) -> m.get('lanes')).join(", ") 
    laneOffset: _.map(models, (m) -> m.get('lane_offset')).join(", ")  
    length: _.map(models, (m) -> m.get('length')).join(", ")  
    freeFlowSpeed: _.map(fds, (fd) -> fd?.get('free_flow_speed') || '').join(", ")
    capacity:  _.map(fds, (fd) -> fd?.get('capacity') || '').join(", ")
    jamDensity: _.map(fds, (fd) -> fd?.get('jam_density') || '').join(", ")
    capacityDrop: _.map(fds, (fd) -> fd?.get('capacity_drop') || '').join(", ")
    congestionSpeed: _.map(fds, (fd) -> fd?.get('congestion_speed') || '').join(", ")
    capacityStandardDev: _.map(fds, (fd) -> fd?.get('std_dev_capacity') || '').join(", ")
    freeFlowStandardDev: _.map(fds, (fd) -> fd?.get('std_dev_free_flow') || '').join(", ")
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
    _.each(@models, (m) -> m.set(fieldId, $("##{id}").val()))

  # this method saves the description
  saveDesc: (e) ->
    id = e.currentTarget.id
    _.each(@models, (m) ->
                      m.get('description').set('text', $("##{id}").val()))
  
  # this saves fields in the fundamental diagram
  saveFD: (e) ->
    id = e.currentTarget.id
    _.each(@models, (m) ->
      ps = m.get('fundamentaldiagramprofile')
      p = ps?.get('fundamentaldiagram')[0]
      p?.set(id, $("##{id}").val())
    )
  
  # this saves fields in the demand profiles
  saveDP: (e) ->
    eid = e.currentTarget.id 
    eid = 'text' if (e.currentTarget.id) is 'dp_text'
    args = {
        id : e.currentTarget.id 
        fieldId: eid
        profile: 'demand'
      }
    @_saveProfileData(args)
  
  saveDPTime: ->
    args = {profile: 'demand'}
    @_saveProfileTimeData(args)
  
  # this saves fields in the capacity profiles
  saveCP: (e) ->
    p = @models[0].get('capacity')
    p?.set('text', $("##{e.currentTarget.id}").val())

  saveCPTime: ->
    args = {profile: 'capacity'}
    @_saveProfileTimeData(args)
  
  # save profile data
  _saveProfileData: (args) ->
    id = args.id
    p = @models[0].get(args.profile)
    p?.set(args.fieldId, $("##{id}").val())
    
  _saveProfileTimeData: (args) ->
    p = @models[0].get(args.profile)
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

  subDivide: (e) ->
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