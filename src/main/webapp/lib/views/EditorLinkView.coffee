# This creates the editor dialogs for node elements
class window.beats.EditorLinkView extends window.beats.EditorView
  $a = window.beats
  events : {
    'blur #link_type' : 'saveType'
    'blur #link_name' : 'saveName'
    'blur #lanes, #lane_offset, #length' : 'save'
    'blur #cp_text': 'saveCP'
    'blur #link_capacity_start_hour, 
      #link_capacity_start_minute, 
      #link_capacity_start_second,
      #link_capacity_sample_hour, 
      #link_capacity_sample_minute, 
      #link_capacity_sample_second' : 'saveCPTime'
    'click #do-subdivide' : 'subDivide'
    'click #do-split': 'doSplit'
    'click #add-lt' : 'addLeftTurn'
    'click #add-rt' : 'addRightTurn'
    'click #choose-name' : 'chooseName'
    'click #reverse-link' : 'reverseLink'
    'click #geom-line' : 'geomLine'
    'click #geom-road' : 'geomRoad'
    'click #in_sync' : 'saveInSync'
    'click #create-demand-profile' : 'createDemandProfile'
    'click #edit-demand-profile' : 'editDemandProfile'
    'click #create-fd-profile' : 'createFDProfile'
    'click #edit-fd-profile' : 'editFDProfile'
  }

  # the options argument has the Node model and type of dialog to create('node')
  initialize: (options) ->
    # get profile data associated with link
    @demandProfile = if options.models.length == 1 then options.models[0].demand_profile() else null
    @fdProfile = if options.models.length == 1 then options.models[0].fundamental_diagram_profile() else null
    options.templateData = @_getTemplateData(options.models)
    super options
  
  # call the super class to set up the dialog box and tabs
  # upon initializations of tabs you disable tabs that are not needed
  render: ->
    super @elem
    @_checkDisableTabs()
    @_checkDisableFields()
    @_setSelectedType()
    @_checkMode()
    @
  
  #set selected type element
  _setSelectedType: ->
    type = @models[0].type_id();
    $(@$el[0]).find("select option[value='#{type}']").attr('selected','selected')
  
  # if tab doesn't have one of the profiles disable it
  _checkDisableTabs: ->
    disable = []
    disable.push(4) if !@models[0].get('capacityprofile')? or @models.length > 1
    @$el.tabs({ disabled: disable })
  
  # if in browser we disable some fields from being editted
  _checkDisableFields: ->
    if (@models.length > 1)
      $('#link_name').attr("disabled", true)
      $('#length').attr("disabled", true)
      $('#in_sync').attr("disabled", true)
  
  # set up the mode correctly
  scenarioMode: ->
    super
    @$el.find("#tabs-link-fd :input").attr("disabled", false)
    @$el.find("#tabs-link-demand :input").attr("disabled", false)
    @$el.find("#tabs-link-capacity :input").attr("disabled", false)

  networkMode: ->
    super
    @$el.find("#tabs-link :input").attr("disabled", false)
    @$el.find("#tabs-link-geo :input").attr("disabled", false)
    @$el.find("#tabs-link-tools :input").attr("disabled", false)
    @_checkDisableFields()
  
  # Once an editor is created we sets field to respond to the appropriate modes
  _checkMode: ->
    @viewMode() if $a.Mode.VIEW
    @scenarioMode() if $a.Mode.SCENARIO
    @networkMode() if $a.Mode.NETWORK
  
  # creates a hash of values taken from the model for the html template
  # I could have just passed the model but I did it this way because 
  # I didn't want the long retrieval lines in the html.
  _getTemplateData: (models) ->
    @cp = models[0].get('capacity') || null if models.length == 1
    @dp = models[0].get('demand') || null if models.length == 1
    
    @fds = _.map(models, (m) ->
                  fdp = m.get('fundamentaldiagramprofile')
                  fdp?.get('fundamentaldiagram')[0] || null
          )
    #name: _.map(models, (m) -> m.road_names()).join(", ")
    name: _.map(models, (m) -> m.link_name()).join(", ")
    insync: if models[0].has('in_sync') and models[0].get('in_sync') then 'checked' else ''
    lanes: _.map(models, (m) -> m.get('lanes')).join(", ") 
    laneOffset: _.map(models, (m) -> m.get('lane_offset')).join(", ")  
    length: _.map(models, (m) -> m.get('length')).join(", ")
    cpStartTime: $a.Util.convertSecondsToHoursMinSec(@cp?.get('start_time') || 0)
    cpSampleTime: $a.Util.convertSecondsToHoursMinSec(@cp?.get('dt') || 0)
    capacityProfile: @cp?.get('text') || ''
    demandProfile: if @demandProfile? then true else false
    fdProfile: if @fdProfile? then true else false

  # Create a new demand profile model and display demands table editor
  createDemandProfile: () ->
    # add new demand profile to set and associate with link
    @demandProfile = $a.models.add_demand_profile(@models?[0])
    # open demand profile editor view
    env = new $a.EditorDemandProfileView(model: @demandProfile)
    @._openProfileEditor(env)

  # Edit demand profile model and display demands table editor
  editDemandProfile: () ->
    # open demand profile editor view
    env = new $a.EditorDemandProfileView(model: @demandProfile)
    @._openProfileEditor(env)

  # Create a new FD profile model and display fd table editor
  createFDProfile: () ->
    # add new fd profile to set and associate with link
    @fdProfile = $a.models.add_fundamentaldiagram_profile(@models?[0])
    @fdProfile.set_fundamental_diagram_type(1)
    # open fd profile editor view
    env = new $a.EditorFundamentalDiagramProfileView(model: @fdProfile)
    @._openProfileEditor(env)

  # Edit FD profile model and display fd table editor
  editFDProfile: () ->
    # open fd profile editor view
    env = new $a.EditorFundamentalDiagramProfileView(model: @fdProfile)
    @._openProfileEditor(env)

  # opens given profile view associated with view
  _openProfileEditor: (view) ->
    $('body').append(view.el)
    view.render()
    # close current dialog box
    @models[0].set_editor_show(false)
    @close()

  # these are callback events for various elements in the interface
  # This is used to save the name, type and description when focus is
  # lost from the element. Note: in order to avoid id conflicts with other
  # editors I append the type some ids -- it needs to be stripped off
  # in the fieldId
  save: (e) ->
    id = e.currentTarget.id
    fieldId = id
    fieldId = id[5...] if id.indexOf("link") is 0
    _.each(@models, (m) -> m.set_generic(fieldId,$("##{id}").val()))
  
  # This saves the link name - will be needed when we go back to road names
  saveName: (e) ->
    id = e.currentTarget.id
    #_.each(@models, (m) -> m.set_road_names($("##{id}").val()))
    _.each(@models, (m) -> m.set_link_name($("##{id}").val()))

  # these are callback events for various elements in the interface
  # This is used to save the type when focus is
  # lost from the element
  saveType: (e) ->
    id = e.currentTarget.id
    _.each(@models, (m) -> m.set_type($("##{id} :selected").val(), $("##{id} :selected").attr("name")))

  # This saves the checkbox indicating the link is in sync
  saveInSync: (e) ->
    id = e.currentTarget.id
    _.each(@models, (m) -> m.set_generic(id, $("##{id}").prop('checked')))
  
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
    @models[0].set_subdivide($("#subdivide").val())
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