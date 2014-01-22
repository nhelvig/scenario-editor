# This creates the editor dialogs for sensor elements
class window.beats.EditorSensorView extends window.beats.EditorView 
  $a = window.beats
  
  # Displayed in the editor to describe how to format urls
  URL_DESC = '* Note:<br/>Enter a full url or shorthand like:'
  URL_DESC += '<br/>pems: d4, July 20, 2012<br/>'
  URL_DESC += 'For ranges, use this date format:<br/>July 20-21, 2012'
  
  events : {
    'blur #sensor_type' : 'saveType'
    'blur #sensor_links' : 'saveLinks'
    'blur #sensor_lat, #sensor_lng, #sensor_elevation' : 'saveGeo'
    'click #display-at-pos' : 'displayAtPos'
  }    
  
  # the options argument has the Sensor model and type of dialog to
  # create('sensor')
  initialize: (options) ->
    options.templateData = @_getTemplateData(options.models)
    super options

  # call the super class to set up the dialog box and then set select boxes
  render: ->
    super @elem
    @_setSelectedType()
    @_checkMode()
    @

  # if in browser we disable some fields from being editted
  _checkDisableFields: ->
    if (@models.length > 1)
      $('#sensor_lat').attr("disabled", true)
      $('#sensor_lng').attr("disabled", true)
      $('#sensor_elevation').attr("disabled", true)
  
  # set up the mode correctly
  scenarioMode: ->
    super
    @$el.find("#tabs-sensor :input").attr("disabled", false)
    @$el.find("#tabs-sensor-geo :input").attr("disabled", false)
    @_checkDisableFields()

  networkMode: ->
    super
    @$el.find("#tabs-sensor :input").attr("disabled", true)
    @$el.find("#tabs-sensor-geo :input").attr("disabled", true)
  
  # Once an editor is created we sets field to respond to the appropriate modes
  _checkMode: ->
    @viewMode() if $a.Mode.VIEW
    @scenarioMode() if $a.Mode.SCENARIO
    @networkMode() if $a.Mode.NETWORK
  
  #set selected type element for sensor type and sensor format
  _setSelectedType: ->
    type = @models[0].type_id()
    $("#sensor_type > option[value='#{type}']").attr('selected','selected')
  
  # set up a hash of values from the model and inserted into the html template
  _getTemplateData: (models) ->
    { 
      lat: models[0].display_lat()
      lng: models[0].display_lng()
      elev: models[0].display_elev()
      vds: models[0].sensor_id_original()
      url: ''
      url_desc: URL_DESC
      link_type: models[0].link_type_original()
      links: _.map(models, (m) -> m.link_id() if m.link_id()?).join('; ')
    }
  
  # these are callback events for various elements in the interface
  # This is used to save the all the fields when focus is lost from
  # the element
  save: (e) ->
    id = e.currentTarget.id
    fieldId = @_getFieldId(id)
    _.each(@models, (m) -> m.set_generic(fieldId, $("##{id}").val()))

  # Save sensor type
  saveType: (e) ->
    id = e.currentTarget.id
    _.each(@models, (m) -> 
      elem = $("##{id} :selected")
      m.set_type(elem.val(), elem.attr("name"))
    )

  # links are in the link_reference attribute
  saveLinks: (e) ->
    id = e.currentTarget.id
    @models[0].set_link_reference($("##{id}").val())
  
  # This is used to save the latitude, longitude and elevation when focus is
  # lost from the element
  saveGeo: (e) ->
    id = e.currentTarget.id
    fieldId = @_getFieldId(id)
    @models[0].set_display_position(fieldId, $("##{id}").val())
  
  _getFieldId: (id) ->
    id = id[7...] if id.indexOf("sensor") is 0
    id
  
  displayAtPos: (e) ->
    e.preventDefault()