# This creates the editor dialogs for node elements
class window.sirius.EditorNodeView extends window.sirius.EditorView
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
    options.templateData = @_getTemplateData(options.model)
    super options

  # call the super class to set up the dialog box and then set the select box
  render: ->
    super @elem
    @_setSelectedType()
    @
  
  #set selected type element
  _setSelectedType: ->
    type = @model.get('type');
    $(@$el[0]).find("select option[value='#{type}']").attr('selected','selected')
  
  # creates a hash of values taken from the model for the html template
  _getTemplateData: (model) ->
    name: model.get('name')
    description: model.get('description')
    lat: model.get('position').get('point')[0].get('lat')
    lng: model.get('position').get('point')[0].get('lng')
    elevation: model.get('position').get('point')[0].get('elevation')
    lock: if model.has('lock') and model.get('lock') then 'checked' else ''

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