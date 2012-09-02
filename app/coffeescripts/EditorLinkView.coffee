# This creates the editor dialogs for node elements
class window.sirius.EditorLinkView extends window.sirius.EditorView
  $a = window.sirius
  events : {
    'blur #link_name, #road_name, #link_type' : 'save'
    'blur #lanes, #lane_offset, #length, #queue_limit' : 'save'
    'blur #capacity, #capacity_drop, #jam_density, #critical_density' : 'saveFD'
    'blur #coefficient, #demand_profile' : 'saveDP'
    'blur #link_demand_start_hour, 
      #link_demand_start_minute, 
      #link_demand_start_second,
      #link_demand_sample_hour, 
      #link_demand_sample_minute, 
      #link_demand_sample_second' : 'saveDPTime'
    'blur #description' : 'saveDesc'
    'click #record' : 'saveRecord'
    'click #edit-signal' : 'signalEditor'
    'click #choose-name' : 'chooseName'
    'click #remove-join-links' : 'removeJoinLinks'
  }
  
  # the options argument has the Node model and type of dialog to create('node')
  initialize: (options) ->
    window.test = options.model

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
    fdp = model.get('fundamentaldiagramprofile')
    fd = fdp?.get('fundamentaldiagram')[0] || null
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
    fdp = @model.get('fundamentaldiagramprofile')
    fd = fdp?.get('fundamentaldiagram')[0]
    fd.set(id, $("##{id}").val())
  
  # this saves fields in the demand profiles
  saveDP: (e) ->
    id = e.currentTarget.id
    dp = @model.get('demandprofile')
    d = fdp?.get('demand')[0]
    d.set(id, $("##{id}").val())
  
  # this saves fields in the demand profiles time
  saveDPTime: (e) ->
    dp = @model.get('demandprofile')
    d = dp?.get('demand')[0]
    start_hour = $("#link_demand_start_hour").val()
    start_minute = $("#link_demand_start_minute").val()
    start_second = $("#link_demand_start_second").val()
    sample_hour = $("#link_demand_sample_hour").val()
    sample_minute = $("#link_demand_sample_minute").val()
    sample_second = $("#link_demand_sample_second").val()
    d.set('start_time', "#{start_hour}:#{start_minute}:#{start:second}")
    d.set('sample_period', "#{sample_hour}:#{sample_minute}:#{sample:second}")

  # These three methods below will be configured to launch various
  # editors in future phases
  signalEditor: (e) ->
    e.preventDefault()

  chooseName: (e) ->
    e.preventDefault()

  removeJoinLinks: (e) ->
    e.preventDefault()
