# This creates the editor dialogs for sensor elements
class window.beats.EditorSensorView extends window.beats.EditorView 
  $a = window.beats
  
  # Displayed in the editor to describe how to format urls
  URL_DESC = '* Note:<br/>Enter a full url or shorthand like:'
  URL_DESC += '<br/>pems: d4, July 20, 2012<br/>'
  URL_DESC += 'For ranges, use this date format:<br/>July 20-21, 2012'
  
  events : {
    'blur #sensor_type, #sensor_link_type': 'save' 
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
    @_checkDisableFields()
    @

  # if in browser we disable some fields from being editted
  _checkDisableFields: ->
    if (@models.length > 1)
      $('#sensor_lat').attr("disabled", true)
      $('#sensor_lng').attr("disabled", true)
      $('#sensor_elevation').attr("disabled", true)
  
  #set selected type element for sensor type and sensor format
  _setSelectedType: ->
    type = @models[0].type()
    lType = @models[0].link()?.type()
    $("#sensor_type > option[value='#{type}']").attr('selected','selected')
    $("#sensor_link_type > option[value='#{lType}']").attr('selected','selected')
  
  # set up a hash of values from the model and inserted into the html template
  _getTemplateData: (models) ->
    { 
      lat: models[0].display_lat();
      lng: models[0].display_lng();
      elev: models[0].display_elev();
      url: ''
      url_desc: URL_DESC
      links: _.map(models, (m) -> m.link().ident() if m.link()?).join('; ')
    }
  
  # these are callback events for various elements in the interface
  # This is used to save the all the fields when focus is lost from
  # the element
  save: (e) ->
    id = e.currentTarget.id
    fieldId = @_getFieldId(id)
    _.each(@models, (m) -> m.set_generic(fieldId, $("##{id}").val()))
  
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