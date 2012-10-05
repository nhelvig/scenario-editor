# This creates the editor dialogs for sensor elements
class window.sirius.EditorSensorView extends window.sirius.EditorView 
  $a = window.sirius
  
  # Displayed in the editor to describe how to format urls
  URL_DESC = '* Note:<br/>Enter a full url or shorthand like:'
  URL_DESC += '<br/>pems: d4, July 20, 2012<br/>'
  URL_DESC += 'For ranges, use this date format:<br/>July 20-21, 2012'
  
  events : {
    'blur #sensor_type, #sensor_link_type': 'save' 
    'blur #sensor_format, #sensor_url' : 'saveDataSource' 
    'blur #sensor_links' : 'saveLinks'
    'blur #sensor_desc' : 'saveDesc'
    'blur #sensor_hour, #sensor_minute, #sensor_second' : 'saveTime'
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
    format = @models[0].get('data_sources').get('data_source')[0].get('format')
    type = @models[0].get('type')
    lType = @models[0].get('link_type')
    $("#sensor_type > option[value='#{type}']").attr('selected','selected')
    $("#sensor_format > option[value='#{format}']").attr('selected','selected')
    $("#sensor_link_type > option[value='#{lType}']").attr('selected','selected')
  
  # set up a hash of values from the model and inserted into the html template
  _getTemplateData: (models) ->
    dt = models[0].get('data_sources').get('data_source')[0].get('dt')
    { 
      description: $a.Util.getDesc(models)
      lat: $a.Util.getGeometry({models:models, geom:'lat'})
      lng: $a.Util.getGeometry({models:models, geom:'lng'})
      elev: $a.Util.getGeometry({models:models, geom:'elevation'})
      #TODO: how should I retrieve a point/data_source from the second sensor?
      url: _.map(models, (m) -> 
              m.get('data_sources').get('data_source')[0].get('url')).join('; ')
      url_desc: URL_DESC
      dt: $a.Util.convertSecondsToHoursMinSec(dt || 0)
      links: _.map(models, (m) -> m.get('link_reference').get('id')).join('; ')
    }
  

  # these are callback events for various elements in the interface
  # This is used to save the all the fields when focus is lost from
  # the element
  save: (e) ->
    id = e.currentTarget.id
    fieldId = @_getFieldId(id)
    _.each(@models, (m) -> m.set(fieldId, $("##{id}").val()))

  # description is in its own descripiton object
  saveDesc: (e) ->
    id = e.currentTarget.id
    _.each(@models, (m) ->
                      m.get('description').set('text', $("##{id}").val()))
  
  # links are in the link_reference attribute
  saveLinks: (e) ->
    id = e.currentTarget.id
    @models[0].get('link_reference').set('id', $("##{id}").val())
  
  # format and url in the data course attribute
  saveDataSource: (e) ->
    id = e.currentTarget.id
    fieldId = @_getFieldId(id)
    _.each(@models, (m) ->
          p = m.get('data_sources').get('data_source')[0]
          p?.set(fieldId, $("##{id}").val())
    )
  
  # saves the dt field -- first converts h, m, s to seconds
  saveTime: (e) ->
    dt = {
      'h': $("#sensor_hour").val()
      'm': $("#sensor_minute").val()
      's': $("#sensor_second").val()
    }
    _.each(@models, (m) ->
                      p = m.get('data_sources').get('data_source')[0]
                      p?.set('dt', $a.Util.convertToSeconds(dt))
    )
  
  # This is used to save the latitude, longitude and elevation when focus is
  # lost from the element
  saveGeo: (e) ->
    id = e.currentTarget.id
    fieldId = @_getFieldId(id)
    @models[0].get('position').get('point')[0].set(fieldId, $("##{id}").val())
  
  _getFieldId: (id) ->
    id = id[7...] if id.indexOf("sensor") is 0
    id
  
  displayAtPos: (e) ->
    e.preventDefault()