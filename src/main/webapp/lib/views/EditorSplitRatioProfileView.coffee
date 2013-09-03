# This creates the editor for split ratio elements
class window.beats.EditorSplitRatioProfileView extends Backbone.View
  $a = window.beats
  events : {
    'click #split-ratio-close-icon' : 'close'
    'blur #dest-network-id' : 'saveDestNetworkId'
    'blur #node-split-ratio-start-hour, #node-split-ratio-start-minute, #node-split-ratio-start-second' : 'saveStartTime'
    'blur #node-split-ratio-sample-hour, #node-split-ratio-sample-minute, #node-split-ratio-sample-second' : 'saveSampleTime'
    'change #vehicle-type, #link-in, #link-out' : 'regenerateSplitRatioTable'
    'click #add-split-ratio-button' : 'addSplitRatio'
    'click #delete-split-ratio-button' : 'deleteSplitRatio'
    'click #node-split-ratio-table tbody td' : 'editSplitRatio'
  }

  # the options argument has the Node model and type of dialog to create('splitratio')
  initialize: (options) ->
    @model = options.model
    @node = options.model.node()
    options.templateData = @_getTemplateData()
    template = _.template($("#split-ratio-editor-template").html())
    title  = $a.Util.toStandardCasing("Split Ratio Profile")
    subtitle = $a.Util.toStandardCasing("Node Id " + @node.ident() if @node)
    @$el.attr 'title', "#{title} Editor: #{subtitle}"
    @$el.attr 'id', "split-ratio-editor-template"
    # Populate Underscore.js template
    @template = _.template($("#split-ratio-editor-template").html())
    @$el.html(@template(options.templateData))
    $a.Util.publishEvents($a.broker, @broker_events, @)

  # call the super class to set up the dialog box and then set the select box
  render: ->
    # Render split ratio data table
    @renderSplitRatioTable()
    @_checkMode()
    @_checkDisableFields()
    # change size of map container to accomidate profile editor
    $('#map_canvas').css('height', '60%')
    $('#right_tree').css('height', '60%')

    # change size of split ratio profile editor container
    $('.bottom-profile-editor ').css('height', '40%')
    @

  # if in a split ratio we disable some fields
  _checkDisableFields: ->
    # disable the add and delete split ratio buttons
    @$el.find("#add-split-ratio-button").attr('disabled', true)
    @$el.find("#delete-split-ratio-button").attr('disabled', true)

  # set up the mode correctly
  scenarioMode: ->
    @$el.find(":input").attr("disabled", false)

  networkMode: ->
    @$el.find(":input").attr("disabled", true)
    @_checkDisableFields()

  viewMode: ->
    @$el.find(":input").attr("disabled", true)

  # Once an editor is created we sets field to respond to the appropriate modes
  _checkMode: ->
    @viewMode() if $a.Mode.VIEW
    @scenarioMode() if $a.Mode.SCENARIO
    @networkMode() if $a.Mode.NETWORK

  # creates a hash of values taken from the model for the html template
  _getTemplateData: () ->
    nodeId: @model.node_id()
    destNetworkId: @model?.destination_network_id()
    srpStartTime: $a.Util.convertSecondsToHoursMinSec(@model?.start_time() || 0)
    srpSampleTime: $a.Util.convertSecondsToHoursMinSec(@model?.dt() || 0)
    inputLinks: @_getInputLinks()
    outputLinks: @_getOutputLinks()

  # the split ratio tab calls this to the column data for the table
  # if 0's are passed in for the ids, all split ratios are returned
  _getSplitRatioData: (vehicleTypeId, linkInId, linkOutId) ->
    dataArray = []
    splitratios = @model?.split_ratios()
    # if split ratios exist create a data array of their attributes
    if splitratios?
      $.each(splitratios, (index, splitRatio) ->

        # check if split ratio is applicable, based on vehicleTypeId, linkInId and linkOutId filter
        if (linkInId == "0" or splitRatio.link_in_id() == linkInId) \
        and (linkOutId == "0" or splitRatio.link_out_id() == linkOutId) \
        and (vehicleTypeId == "0" or splitRatio.vehicle_type_id() == vehicleTypeId)

          # for each split ratio offset, create datatable row array of data
          i=0
          while i < splitRatio.max_offset()
            dataArray.push([
              splitRatio.ident(i),
              i,
              splitRatio.vehicle_type_id()
              splitRatio.link_in_id(),
              splitRatio.link_out_id(),
              splitRatio.split_ratio(i)
            ])
            i++
      )
    dataArray

  # return list of all input links at split ratio profile node
  _getInputLinks: () ->
    inputLinks = []
    $.each(@node.inputs(), (index, input) ->
      inputLinks.push(input.get("link_id"))
    )
    inputLinks

  # return list of all output links at split ratio profile node
  _getOutputLinks: () ->
    outputLinks = []
    $.each(@node.outputs(), (index, output) ->
      outputLinks.push(output.get("link_id"))
    )
    outputLinks

  # set up split ratio columns and their titles for the data table
  _getSplitRatioColumns: () ->
    columns =  [
      { "sTitle": "Id","bVisible": false},
      { "sTitle": "Ratio Order","sWidth": "20%"},
      { "sTitle": "Vehicle Type ID","sWidth": "20%"},
      { "sTitle": "Input Link Id","sWidth": "20%"},
      { "sTitle": "Output Link Id","sWidth": "20%"},
      { "sTitle": "Split Ratio","sWidth": "20%"},
    ]

  # render the table in the left pane
  renderSplitRatioTable: () ->
    @dTable = $('#node-split-ratio-table').dataTable( {
      "aaData": @_getSplitRatioData(0,0,0),
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

  # Closes the dialog box
  close: () ->
    # change size of split ratio profile editor container to 0%
    $('.bottom-profile-editor ').css('height', '0%')
    # restore size of map container
    $('#map_canvas').css('height', '100%')
    $('#right_tree').css('height', '100%')
    #remove element
    @$el.remove()

  # these are callback events for various elements in the interface
  # This is used to save the destination network id when focus is
  # lost from the element
  saveDestNetworkId: (e) ->
    id = e.currentTarget.id
    @model.set_destintation_network_id($("##{id}").val())

  # these are callback events for various elements in the interface
  # This is used to save the profiles start time when focus is
  # lost from the element
  saveStartTime: (e) ->
    hms = new Object()
    hms['h'] =  $("#node-split-ratio-start-hour").val()
    hms['m'] =  $("#node-split-ratio-start-minute").val()
    hms['s'] =  $("#node-split-ratio-start-second").val()
    seconds = $a.Util.convertToSeconds(hms)
    @model.set_start_time(seconds)

  # these are callback events for various elements in the interface
  # This is used to save the profiles sample when focus is
  # lost from the element
  saveSampleTime: (e) ->
    hms = new Object()
    hms['h'] =  $("#node-split-ratio-sample-hour").val()
    hms['m'] =  $("#node-split-ratio-sample-minute").val()
    hms['s'] =  $("#node-split-ratio-sample-second").val()
    seconds = $a.Util.convertToSeconds(hms)
    @model.set_dt(seconds)

  # regenerate split ratio table based on selected vehicle type id, link in and link out
  regenerateSplitRatioTable: (e) ->
    # get vehicle type id for ratio
    vehicleTypeId = $('#vehicle-type').find(":selected").val();
    # get link in id for ratio
    linkInId = $('#link-in').find(":selected").val();
    # get link out id for ratio
    linkOutId = $('#link-out').find(":selected").val();
    # clear data table
    @dTable.fnClearTable();
    # regenerate it based on newly set vehicle type, link in and link out
    @dTable.fnAddData(@_getSplitRatioData(vehicleTypeId, linkInId, linkOutId));

    # if vehicle type, link in and link out are all set enable add split ratio button
    if vehicleTypeId != "0" and linkInId != "0" and linkOutId != "0"
      @$el.find("#add-split-ratio-button").attr('disabled', false)
    # otherwise disable it
    else
      @$el.find("#add-split-ratio-button").attr('disabled', true)

  # add split ratio to profile
  addSplitRatio: (e) ->
    # get vehicle type id for ratio
    vehicleTypeId = $('#vehicle-type').find(":selected").val();
    # get link in id for ratio
    linkInId = $('#link-in').find(":selected").val();
    # get link out id for ratio
    linkOutId = $('#link-out').find(":selected").val();
    # Find if there exists any split ratio with the given link in, link out and vehicle type id
    splitRatio = @model.split_ratio(linkInId, linkOutId, vehicleTypeId)

    # if no split ratio exits, create it and add it to profile
    if splitRatio is null
      splitRatio = new $a.Splitratio()
      splitRatio.set_link_in_id(linkInId)
      splitRatio.set_link_out_id(linkOutId)
      splitRatio.set_vehicle_type_id(vehicleTypeId)
      @model.split_ratios().push(splitRatio)

    # get last set dt offset of split ratio
    offset = splitRatio.max_offset()
    splitRatio.set_split_ratio("0.0", offset) # split ratio value added defaults to 0

    @dTable.dataTable().fnAddData([
      -1, # set id of newly created ratios to -1, to better keep track of them until saved in DB
      offset,
      vehicleTypeId,
      linkInId,
      linkOutId,
      splitRatio.split_ratio(offset)
    ])

  # add split ratio to profile
  deleteSplitRatio: (e) ->
    alert("delete split ratio")

  # edit split ratio
  editSplitRatio: (e) ->
    # get position on table where click event happened
    pos = @dTable.fnGetPosition(e)
    # if the fifth visible column was clicked (split ratio) make cell editable
    # if pos[1] == 5
      # get value in cell and put into input box


