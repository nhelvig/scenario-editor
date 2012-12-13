# This creates the editor dialogs for node elements
class window.beats.EditorNodeView extends window.beats.EditorView
  $a = window.beats
  events : {
    'blur #type' : 'save'
    'blur #name' : 'saveName'
    'blur #lat, #lng, #elevation' : 'saveGeo'
    'click #lock' : 'saveLocked'
    'click #edit-signal' : 'signalEditor'
    'click #choose-name' : 'chooseName'
    'click #remove-join-links' : 'removeJoinLinks'
  }

  # the options argument has the Node model and type of dialog to create('node')
  initialize: (options) ->
    options.templateData = @_getTemplateData(options.models)
    super options

  # call the super class to set up the dialog box and then set the select box
  render: ->
    super @elem
    @_setSelectedType()
    @_checkDisableTabs()
    @_checkDisableFields()
    @
  
  # if tab doesn't have one of the profiles disable it
  _checkDisableTabs: ->
    # disabled until we implement
    $('#edit-signal').attr("disabled", true)
    $('#edit-signal').addClass('ui-state-disabled')
    disable = [2]
    @$el.tabs({ disabled: disable })
  
  # if in browser we diable some fields from being editted
  _checkDisableFields: ->
    if (@models.length > 1)
      $('#name').attr("disabled", true)
      $('#lat').attr("disabled", true)
      $('#lng').attr("disabled", true)
      $('#elevation').attr("disabled", true)
  
  #set selected type element
  _setSelectedType: ->
    type = @models[0].get('type');
    $(@$el[0]).find("select option[value='#{type}']").attr('selected','selected')
  
  # creates a hash of values taken from the model for the html template
  _getTemplateData: (models) ->
    name: _.map(models, (m) -> m.road_names()).join(", ")
    lat: $a.Util.getGeometry({models:models, geom:'lat'})
    lng: $a.Util.getGeometry({models:models, geom:'lng'})
    elevation: $a.Util.getGeometry({models:models, geom:'elevation'})
    lock: if models[0].has('lock') and models[0].get('lock') then 'checked' else ''

  # these are callback events for various elements in the interface
  # This is used to save the type and description when focus is
  # lost from the element
  save: (e) ->
    id = e.currentTarget.id
    _.each(@models, (m) -> m.set(id, $("##{id}").val()))

  # This is used to save the name when focus is
  # lost from the element
  saveName: (e) ->
    id = e.currentTarget.id
    _.each(@models, (m) -> m.set_road_names($("##{id}").val()))
  
  
  # This is used to save the latitude, longitude and elevation when focus is
  # lost from the element
  saveGeo: (e) ->
    id = e.currentTarget.id
    @models[0].get('position').get('point')[0].set(id, $("##{id}").val())

  # This saves the checkbox indicating the node is locked
  saveLocked: (e) ->
    id = e.currentTarget.id
    _.each(@models, (m) -> m.set(id, $("##{id}").prop('checked')))

  # These three methods below will be configured to launch various
  # editors in future phases
  signalEditor: (e) ->
    e.preventDefault()

  chooseName: (e) ->
    e.preventDefault()

  removeJoinLinks: (e) ->
    e.preventDefault()