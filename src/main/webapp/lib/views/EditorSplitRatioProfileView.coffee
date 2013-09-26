# This creates the editor for split ratio profile
class window.beats.EditorSplitRatioProfileView extends Backbone.View
  $a = window.beats
  events : {
    'click #close-icon' : 'close'
    'blur #dest-network-id' : 'saveDestNetworkId'
    'blur #start-hour, #start-minute, #start-second' : 'saveStartTime'
    'blur #sample-hour, #sample-minute, #sample-second' : 'saveSampleTime'
    'change #vehicle-type, #link-in, #link-out' : 'regenerateSplitRatioTable'
    'click #add-split-ratio-button' : 'addSplitRatio'
    'click #delete-split-ratio-button' : 'deleteSplitRatio'
    'blur #split-ratio-value' : 'saveSplitRatio'
  }

  # the options argument has the split ratio model and type of dialog to create('splitratio')
  initialize: (options) ->
    @model = options.model
    @node = options.model.node()
    @dataTableId = "split-ratio-table"
    options.templateData = @_getTemplateData()
    template = _.template($("#split-ratio-editor-template").html())
    title  = $a.Util.toStandardCasing("Split Ratio Profile")
    subtitle = $a.Util.toStandardCasing("Node Id " + @node.ident() if @node)
    @$el.attr 'title', "#{title} Editor: #{subtitle}"
    @$el.attr 'id', "split-ratio-editor-template"
    # Populate Underscore.js template
    @template = _.template($("#split-ratio-editor-template").html())
    @$el.html(@template(options.templateData))
    # setup models change events
    @_setupEvents()

  # call the super class to set up the dialog box and then set the select box
  render: ->
    # Render split ratio data table
    @renderSplitRatioTable()
    @_checkMode()
    @_checkDisableFields()
    @_attachRowSelection()
    # change size of map container to accomidate profile editor
    $('#map_canvas').css('height', '60%')
    $('#right_tree').css('height', '60%')

    # change size of split ratio profile editor container
    $('.bottom-profile-editor ').css('height', '40%')
    @

  # Set up profiles on change events
  _setupEvents: ->
    # Setup profile model change events
    @model.on('change:node_id change:destination_network_id change:network_id change:dt change:start_time',
      => @_updateProfile())
    splits = @model?.split_ratios()
    # for each split in profile add changed events
    if splits?
      $.each(splits, (index, split) =>
        # for each split in profile setup model change events
        split.on('change:text',
          => @_updateProfile())
      )

  # Update set's and profile's CrudFlag
  _updateProfile: () ->
    # set crud flag to update for split ratio set, split ratio profile
    $a.models.splitratio_set().set_crud_flag(window.beats.CrudFlag.UPDATE)
    @model.set_crud_flag($a.CrudFlag.UPDATE)

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
    startTime: $a.Util.convertSecondsToHoursMinSec(@model?.start_time() || 0)
    sampleTime: $a.Util.convertSecondsToHoursMinSec(@model?.dt() || 0)
    inputLinks: @_getInputLinks()
    outputLinks: @_getOutputLinks()

  # gets the column data for the table if 0's are passed in for the ids, all split ratios are returned
  _getSplitRatioData: (vehicleTypeId, linkInId, linkOutId) ->
    dataArray = []
    splitratios = @model?.split_ratios()
    # if split ratios exist create a data array of their attributes
    if splitratios?
      $.each(splitratios, (index, splitRatio) ->

        # check if split ratio is applicable, based on vehicleTypeId, linkInId and linkOutId filter
        if (linkInId == "0" or splitRatio.link_in_id() == Number(linkInId)) \
        and (linkOutId == "0" or splitRatio.link_out_id() == Number(linkOutId)) \
        and (vehicleTypeId == "0" or splitRatio.vehicle_type_id() == Number(vehicleTypeId))

          # for each split ratio offset, create datatable row array of data
          i=0
          while i < splitRatio.max_offset()
            dataArray.push([
              splitRatio.ident(),
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
    @dTable = @$el.find("##{@dataTableId}").dataTable( {
      "aaData": @_getSplitRatioData("0","0","0"),
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
    } )

  # removes all event listeners
  _clearEvents: () ->
    # remove profile model change events
    @model.off('change:node_id change:destination_network_id change:network_id change:dt change:start_time')
    splits = @model?.split_ratios()
    # for each split in profile remove change events
    if splits?
      $.each(splits, (index, split) =>
        # for each split in profile setup model change events
        split.off('change:text')
      )

  # Closes the dialog box
  close: () ->
    @_clearEvents()
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
    hms['h'] =  $("#start-hour").val()
    hms['m'] =  $("#start-minute").val()
    hms['s'] =  $("#start-second").val()
    seconds = $a.Util.convertToSeconds(hms)
    @model.set_start_time(seconds)

  # these are callback events for various elements in the interface
  # This is used to save the profiles sample when focus is
  # lost from the element
  saveSampleTime: (e) ->
    hms = new Object()
    hms['h'] =  $("#sample-hour").val()
    hms['m'] =  $("#sample-minute").val()
    hms['s'] =  $("#sample-second").val()
    seconds = $a.Util.convertToSeconds(hms)
    @model.set_dt(seconds)

  # these are callback events for various elements in the interface
  # This is used to save a profiles split ratio when focus is
  # lost from the element
  saveSplitRatio: (e) ->
    id = e.currentTarget.id
    # get split ratio, offset, link in, link out and vehicle type ids
    value = @$el.find("##{id}").val()
    offset = @$el.find("##{id}").closest("tr").find("td:first").html()
    vehicleTypeId = @$el.find("##{id}").closest("tr").find("td:nth-child(2)").html()
    linkInId = @$el.find("##{id}").closest("tr").find("td:nth-child(3)").html()
    linkOutId = @$el.find("##{id}").closest("tr").find("td:nth-child(4)").html()

    # get split ratio model and save new value
    splitRatio = @model.split_ratio(linkInId, linkOutId, vehicleTypeId)
    splitRatio.set_split_ratio(value, offset)
    splitRatio.set_crud_flag($a.CrudFlag.UPDATE, offset)


  # regenerate split ratio table based on selected vehicle type id, link in and link out
  regenerateSplitRatioTable: (e) ->
    # get vehicle type id for ratio
    vehicleTypeId = @$el.find('#vehicle-type').find(":selected").val()
    # get link in id for ratio
    linkInId = @$el.find('#link-in').find(":selected").val()
    # get link out id for ratio
    linkOutId = @$el.find('#link-out').find(":selected").val()
    # clear data table
    @dTable.fnClearTable()
    # regenerate it based on newly set vehicle type, link in and link out
    @dTable.fnAddData(@_getSplitRatioData(vehicleTypeId, linkInId, linkOutId))

    # if vehicle type, link in and link out are all set enable add split ratio button
    if vehicleTypeId != "0" and linkInId != "0" and linkOutId != "0"
      @$el.find("#add-split-ratio-button").attr('disabled', false)
    # otherwise disable it
    else
      @$el.find("#add-split-ratio-button").attr('disabled', true)

  # add split ratio to profile
  addSplitRatio: (e) ->
    # get vehicle type id for ratio
    vehicleTypeId = @$el.find('#vehicle-type').find(":selected").val();
    # get link in id for ratio
    linkInId = @$el.find('#link-in').find(":selected").val();
    # get link out id for ratio
    linkOutId = @$el.find('#link-out').find(":selected").val();
    # Find if there exists any split ratio with the given link in, link out and vehicle type id
    splitRatio = @model.split_ratio(linkInId, linkOutId, vehicleTypeId)

    # if no split ratio exits, create it and add it to profile
    if not splitRatio?
      splitRatio = new $a.Splitratio()
      splitRatio.set_link_in_id(linkInId)
      splitRatio.set_link_out_id(linkOutId)
      splitRatio.set_vehicle_type_id(vehicleTypeId)
      @model.split_ratios().push(splitRatio)

    # get last set dt offset of split ratio
    offset = splitRatio.max_offset()
    splitRatio.set_split_ratio("0.0", offset) # split ratio value added defaults to 0
    splitRatio.set_crud_flag($a.CrudFlag.CREATE, offset)

    # Add new record to data table
    @dTable.dataTable().fnAddData([
      -1, # set id of newly created ratios to -1, to better keep track of them until saved in DB
      offset,
      vehicleTypeId,
      linkInId,
      linkOutId,
      splitRatio.split_ratio(offset)
    ])
    # update Split ratio profile crudflag
    @_updateProfile()

  # add split ratio to profile
  deleteSplitRatio: (e) ->
    alert("delete split ratio")

  # highlights selected row
  _attachRowSelection: () ->
    instance = @
    # attach click event listenor for row selection and editable data table
    @$el.find("##{@dataTableId} tbody").on("click", "tr", (e) ->

      # if row is not selected remove selection add row selection
      if !$(@).hasClass('row_selected')
        # remove row selected class to other selected split ratios
        rows = instance.$el.find("##{instance.dataTableId} tbody tr.row_selected")
        rows.removeClass('row_selected')
        # remove input box for previous select row(s)
        for row in rows
          # asynchronously remove input box from row with delay to ensure blur event
          # which saves data entered in it is handled first
          setTimeout(instance._removeInputBoxFromRow(row), 200)

        # add row selected class to row and create input box to make split ratio editable
        $(@).addClass('row_selected')
        instance._addInputBoxToRow(@)

        # check if delete button should be enabled or disabled

    )

  # Add input box to split ratio column in selected row in datatable
  _addInputBoxToRow: (row) ->
    # get last column which is split ratio, and get it's value
    cell = $(row).find("td:last")
    splitRatio = $(cell).html()

    # replace split ratio value in column with input box
    $(cell).html('<input type="text" id="split-ratio-value" class="text ui-widget ui-widget-content ui-corner-all"' + \
    'value="' + splitRatio + '"/>')

  # Removes input box from row, and puts input box value back into datatable
  _removeInputBoxFromRow: (row) ->
    cell = $(row).find("td:last")
    splitRatio = $(cell).find("input").val()
    $(cell).html(splitRatio)




