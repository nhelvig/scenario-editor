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
  }

  # the options argument has the Node model and type of dialog to create('node')
  initialize: (options) ->
    # get split ratio profile data associated with node
    @splitRatioProfile = options.models[0].get('splitratioprofile') || null if options.models.length == 1
    options.templateData = @_getTemplateData(options.models)
    super options

  # call the super class to set up the dialog box and then set the select box
  render: ->
    super @elem
    # If there is split ratio profile for link, render split ratio data table
    if @splitRatioProfile?
      @renderSplitRatioTable()
    @_setSelectedType()
    @_checkDisableTabs()
    @_disableBrowserFields() if (@models.length > 1)
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
  _disableBrowserFields: ->
    $('#name').attr("disabled", true)
    $('#lat').attr("disabled", true)
    $('#lng').attr("disabled", true)
    $('#elevation').attr("disabled", true)
  
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
    destnetworkid: @splitRatioProfile?.get('destination_network_id')
    srpStartTime: $a.Util.convertSecondsToHoursMinSec(@splitRatioProfile?.get('start_time') || 0)
    srpSampleTime: $a.Util.convertSecondsToHoursMinSec(@splitRatioProfile?.get('dt') || 0)

  # the split ratio tab calls this to the column data for the table
  _getSplitRatioData: () ->
    dataArray = []
    splitratios = @splitRatioProfile?.split_ratios()
    # if split ratios exist create a data array of their attributes
    if splitratios?
      $.each(splitratios, (index, splitRatio) ->
        dataArray.push([
          splitRatio.ident(),
          splitRatio.vehicle_type_id(),
          splitRatio.ratio_order(),
          splitRatio.in_link_id(),
          splitRatio.out_link_id(),
          splitRatio.split_ratio()
        ])
      )
    dataArray

  # set up split ratio columns and their titles for the browser
  _getSplitRatioColumns: () ->
    columns =  [
      { "sTitle": "Id","bVisible": false},
      { "sTitle": "Vehcile Type ID","sWidth": "20%"},
      { "sTitle": "Ratio Order","sWidth": "20%"},
      { "sTitle": "Input Link Id","sWidth": "20%"},
      { "sTitle": "Output Link Id","sWidth": "20%"},
      { "sTitle": "Split Ratio","sWidth": "20%"},
    ]

  # render the table in the left pane
  renderSplitRatioTable: () ->
    @dTable = $('#node-split-ratio-table').dataTable( {
      "aaData": @_getSplitRatioData(),
      "aoColumns": @_getSplitRatioColumns(),
      "aaSorting": [[ 2, "desc" ]]
      "bPaginate": true,
      "bLengthChange": false,
      "bFilter": false,
      "bSort": true,
      "bInfo": false,
      "bDestroy": true,
      "bAutoWidth": false,
      "bJQueryUI": true,
    })

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