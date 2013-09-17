# This creates the editor dialogs for node elements
class window.beats.EditorNodeView extends window.beats.EditorView
  $a = window.beats
  events : {
    'blur #type' : 'saveType'
    'blur #name' : 'saveName'
    'blur #lat, #lng, #elevation' : 'saveGeo'
    'click #lock' : 'saveLocked'
    'click #edit-signal' : 'signalEditor'
    'click #choose-name' : 'chooseName'
    'click #remove-join-links' : 'removeJoinLinks'
    'click #create-split-ratio-profile' : 'createSplitRatioProfile'
    'click #edit-split-ratio-profile' : 'editSplitRatioProfile'
  }

  # the options argument has the Node model and type of dialog to create('node')
  initialize: (options) ->
    # get split ratio profile data associated with node
    @splitRatioProfile = if options.models.length == 1 then options.models[0].splitratio_profile() else null
    options.templateData = @_getTemplateData(options.models)
    super options

  # call the super class to set up the dialog box and then set the select box
  render: ->
    super @elem
    @_setSelectedType()
    @_checkDisableTabs()
    @_checkDisableFields()
    @_checkMode()
    @
  
  # if tab doesn't have one of the profiles disable it
  _checkDisableTabs: ->
    # disabled until we implement
    $('body').find('#edit-signal').attr("disabled", true)
    $('body').find('#edit-signal').addClass('ui-state-disabled')
    
    # For now disable the tools tab and the splitratio, if none exist
    disable = [3]
    @$el.tabs({ disabled: disable })
  
  # if in a node browser we disable some fields
  _checkDisableFields: ->
    if (@models.length > 1)
      $('#name').attr("disabled", true)
      $('#lat').attr("disabled", true)
      $('#lng').attr("disabled", true)
      $('#elevation').attr("disabled", true)
  
  # set up the mode correctly
  scenarioMode: ->
    super
    @$el.find("#tabs-node-split-ratio :input").attr("disabled", false)

  networkMode: ->
    super
    @$el.find("#tabs-node :input").attr("disabled", false)
    @$el.find("#tabs-node-geo :input").attr("disabled", false)
    @_checkDisableFields()
  
  # Once an editor is created we sets field to respond to the appropriate modes
  _checkMode: ->
    @viewMode() if $a.Mode.VIEW
    @scenarioMode() if $a.Mode.SCENARIO
    @networkMode() if $a.Mode.NETWORK
    
  #set selected type element
  _setSelectedType: ->
    type = @models[0].type_id();
    $(@$el[0]).find("select option[value='#{type}']").attr('selected','selected')
  
  # creates a hash of values taken from the model for the html template
  _getTemplateData: (models) ->
    name: _.map(models, (m) -> m.name())
    lat: $a.Util.getGeometry({models:models, geom:'lat'})
    lng: $a.Util.getGeometry({models:models, geom:'lng'})
    elevation: $a.Util.getGeometry({models:models, geom:'elevation'})
    lock: if models[0]? and models[0].locked() then 'checked' else ''
    profile: if @splitRatioProfile? then true else false

  # Create a new split ratio profile model and display split ratios table editor
  createSplitRatioProfile: () ->
    # add new split ratio profile to set and associate with node
    @splitRatioProfile = $a.models.add_splitratio_profile(@models?[0])
    # open split ratio profile editor view
    env = new $a.EditorSplitRatioProfileView(model: @splitRatioProfile)
    $('body').append(env.el)
    env.render()
    # close current dialog box
    @models[0].set_editor_show(false)
    @close()

  # Edit split ratio profile model and display split ratios table editor
  editSplitRatioProfile: () ->
    # open split ratio profile editor view
    env = new $a.EditorSplitRatioProfileView(model: @splitRatioProfile)
    $('body').append(env.el)
    env.render()
    # close current dialog box
    @models[0].set_editor_show(false)
    @close()

  # these are callback events for various elements in the interface
  # This is used to save the type when focus is
  # lost from the element
  saveType: (e) ->
    id = e.currentTarget.id
    _.each(@models, (m) -> m.set_type($("##{id} :selected").val(), $("##{id} :selected").attr("name")))

  # This is used to save the name when focus is
  # lost from the element
  saveName: (e) ->
    id = e.currentTarget.id
    _.each(@models, (m) -> m.set_name($("##{id}").val()))
  
  # This is used to save the latitude, longitude and elevation when focus is
  # lost from the element
  saveGeo: (e) ->
    id = e.currentTarget.id
    @models[0].get('position').get('point')[0].set(id, $("##{id}").val())

  # This saves the checkbox indicating the node is locked
  saveLocked: (e) ->
    id = e.currentTarget.id
    _.each(@models, (m) -> m.set_locked($("##{id}").prop('checked')))

  # These three methods below will be configured to launch various
  # editors in future phases
  signalEditor: (e) ->
    e.preventDefault()

  chooseName: (e) ->
    e.preventDefault()

  removeJoinLinks: (e) ->
    e.preventDefault()