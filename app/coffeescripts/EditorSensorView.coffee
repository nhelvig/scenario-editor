# This creates the editor dialogs for sensor elements
class window.sirius.EditorSensorView extends window.sirius.EditorView 
  $a = window.sirius
  
  # Displayed in the editor to describe how to format urls
  URL_DESC = '* Note:<br/>Enter a full url or shorthand like:'
  URL_DESC += '<br/>pems: d4, July 20, 2012<br/>'
  URL_DESC += 'For ranges, use this date format:<br/>July 20-21, 2012'
  
  events : {
    'blur #name, #description, #type' : 'save'
    'blur #lat, #lng, #elevation' : 'saveGeo'
    'click #display-at-pos' : 'displayAtPos'
  }    
  
  # the options argument has the Sensor model and type of dialog to
  # create('sensor')
  initialize: (options) ->
    options.templateData = @_getTemplateData(options.model)
    super options

  # call the super class to set up the dialog box and then set select boxes
  render: ->
    super @elem
    @_setSelectedType()
    console.log(@model)
    @

  #set selected type element for sensor type and sensor format
  _setSelectedType: ->
    format = @model.get('data_sources').get('data_source')[0].get('format')
    type = @model.get('type')
    $("#sensor_type > option[value='#{type}']").attr('selected','selected')
    $("#sensor_format > option[value='#{format}']").attr('selected','selected')
  
  # set up a hash of values from the model and inserted into the html template
  _getTemplateData: (model) ->
    dt = model.get('data_sources').get('data_source')[0].get('dt')
    { 
      description: model.get('description').get('text')
      lat: model.get('position').get('point')[0].get('lat')
      lng: model.get('position').get('point')[0].get('lng')
      elev: model.get('position').get('point')[0].get('elevation')
      #TODO: how should I retrieve a point/data_source from the second sensor?
      url: model.get('data_sources').get('data_source')[0].get('url')
      url_desc: URL_DESC
      format: model.get('data_sources').get('data_source')[0].get('format')
      dt: $a.Util.convertSecondsToHoursMinSec(dt || 0)
      links: model.get('link_reference').get('id')
      link_type: model.get('link_type')
      sensor_type: model.get('type')
    }
  
  # these are callback events for various elements in the interface
  # This is used to save the name, type and description when focus is lost from
  # the element
  save: (e) ->
    id = e.currentTarget.id
    @model.set(id, $("##{id}").val())

  # This is used to save the latitude, longitude and elevation when focus is
  # lost from the element
  saveGeo: (e) ->
    id = e.currentTarget.id
    @model.get('position').get('point')[0].set(id, $("##{id}").val())
  
  displayAtPos: () ->
    #do something