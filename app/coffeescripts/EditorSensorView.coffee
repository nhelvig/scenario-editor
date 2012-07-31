# This creates the editor dialogs for sensor elements
class window.sirius.EditorSensorView extends window.sirius.EditorView 
  $a = window.sirius
  events : {
    'blur #name, #description, #type' : 'save'
    'blur #lat, #lng, #elevation' : 'saveGeo'
    'click #display-at-pos' : 'displayAtPos'
  }    
  
  # the options argument has the Sensor model and type of dialog to create('sensor')
  initialize: (options) ->
    time_step = options.model.get('data_sources').get('data_source')[0].get('dt')
    @hours = Math.floor(time_step/3600)
    time_step = time_step % 3600
    @minutes = Math.floor(time_step/60)
    time_step = time_step % 60
    @seconds = time_step
    options.templateData = @_getTemplateData(options.model)
    @format = options.templateData.format
    @type = options.templateData.sensor_type
    @link_type = options.templateData.link_type
    super options
    
    #set selected type element
    elem = _.filter($(@$el[0]).find("select option"), (item) => $(item).val() is options.model.get('type'))
    $(elem[0]).attr('selected', true)

  # call the super class to set up the dialog box
  render: ->
    super @elem
    $("#sensor-format > option[value='#{@format}']").attr('selected','selected')
    #$("#sensor-type > option[value='#{@type}']")attr('selected','selected')
    #$("#sensor-link-type > option[value='#{@link_type}']")attr('selected','selected')
    @

  # this sets up the hash of values taken from the model and inserted into the html template
  _getTemplateData: (model) ->
    { 
      description: model.get('description').get('text')
      lat: model.get('position').get('point')[0].get('lat')
      lng: model.get('position').get('point')[0].get('lng')
      elev: model.get('position').get('point')[0].get('elevation') || 0
      #TODO: how should I retrieve a point/data_source from the second sensor?
      url: model.get('data_sources').get('data_source')[0].get('url')
      url_desc: 'Enter a full url or shorthand like \n pems: d4, Jan 1, 2011 \n For ranges, use this date format: \n Jan 1-4, 2011'
      format: model.get('data_sources').get('data_source')[0].get('format')
      hour: @hours || 0
      minute: @minutes || 0
      second: @seconds || 0
      links: model.get('link_reference').get('id')
      link_type: model.get('link_type')
      sensor_type: model.get('type')
    }
  
  # these are callback events for various elements in the interface
  # This is used to save the name, type and description when focus is lost from the element
  save: (e) ->
    id = e.currentTarget.id
    @model.set(id, $("##{id}").val())

  # This is used to save the latitude, longitude and elevation when focus is lost from the element
  saveGeo: (e) ->
    id = e.currentTarget.id
    @model.get('position').get('point')[0].set(id, $("##{id}").val())
  
  displayAtPos: () ->
    #do something