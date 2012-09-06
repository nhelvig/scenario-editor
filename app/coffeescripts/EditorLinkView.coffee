# This creates the editor dialogs for node elements
class window.sirius.EditorLinkView extends window.sirius.EditorView
  $a = window.sirius
  events : {
    'blur #link_name, #road_name, #link_type' : 'save'
    'blur #lanes, #lane_offset, #length, #queue_limit' : 'save'
    'blur #capacity, #capacity_drop, #jam_density, #critical_density' : 'saveFD'
    'blur #coefficient, 
      #demand_profile,
      #link_demand_start_hour, 
      #link_demand_start_minute, 
      #link_demand_start_second,
      #link_demand_sample_hour, 
      #link_demand_sample_minute, 
      #link_demand_sample_second' : 'saveDP'
    'blur #capacity_profile,
      #link_capacity_start_hour, 
      #link_capacity_start_minute, 
      #link_capacity_start_second,
      #link_capacity_sample_hour, 
      #link_capacity_sample_minute, 
      #link_capacity_sample_second' : 'saveCP'
    'blur #description' : 'saveDesc'
    'click #record' : 'saveRecord'
    'click #edit-signal' : 'signalEditor'
    'click #choose-name' : 'chooseName'
    'click #remove-join-links' : 'removeJoinLinks'
  }
  
  # the options argument has the Node model and type of dialog to create('node')
  initialize: (options) ->
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
    disable.push(3) if !@model.get('demandprofile')?
    @$el.tabs({ disabled: disable })

  # creates a hash of values taken from the model for the html template
  # I could have just passed the model but I did it this way because 
  # I didn't want the long retrieval lines in the html.
  _getTemplateData: (model) ->
    fdp = model.get('fundamentaldiagramprofile')
    fd = fdp?.get('fundamentaldiagram')[0] || null
    cp = model.get('capacityprofile')?.get('capacity')[0] || null
    dp = model.get('demandprofile')?.get('demand')[0] || null
    
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
    @_saveProfileData({
        id: e.currentTarget.id
        profileset: 'fundamentaldiagramprofile'
        profile: 'fundamentaldiagram'
      })
  
  # this saves fields in the demand profiles
  saveDP: (e) ->
    @_saveProfileData({
        id: e.currentTarget.id
        profileset: 'demandprofile'
        profile: 'demand'
      })
    @_saveProfileTimeData({
        profileset: 'demandprofile'
        profile: 'demand'
      })

  # this saves fields in the capacity profiles
  saveCP: (e) ->
    @_saveProfileData({
        id: e.currentTarget.id
        profileset: 'capacityprofile'
        profile: 'capacity'
      })
    @_saveProfileTimeData({
        profileset: 'capacityprofile'
        profile: 'capacity'
      })

  # save profile data
  _saveProfileData: (args) ->
    id = args.id
    ps = @model.get(args.profileset)
    p = ps?.get(args.profile)[0]
    p?.set(id, $("##{id}").val())

  _saveProfileTimeData: (args) ->
    ps = @model.get(args.profileset)
    p = ps?.get(args.profile)[0]
    start_hour = $("#link_#{args.profile}_start_hour").val()
    start_minute = $("#link_#{args.profile}_start_minute").val()
    start_second = $("#link_#{args.profile}_start_second").val()
    sample_hour = $("#link_#{args.profile}_sample_hour").val()
    sample_minute = $("#link_#{args.profile}_sample_minute").val()
    sample_second = $("#link_#{args.profile}_sample_second").val()
    p?.set('start_time', "#{start_hour}:#{start_minute}:#{start:second}")
    p?.set('dt', "#{sample_hour}:#{sample_minute}:#{sample:second}")
  
  # These three methods below will be configured to launch various
  # editors in future phases
  signalEditor: (e) ->
    e.preventDefault()

  chooseName: (e) ->
    e.preventDefault()

  removeJoinLinks: (e) ->
    e.preventDefault()
