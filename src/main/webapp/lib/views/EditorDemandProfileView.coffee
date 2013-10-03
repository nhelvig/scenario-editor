# This creates the editor for demand profile
class window.beats.EditorDemandProfileView extends Backbone.View
  $a = window.beats
  events : {
    'click #close-icon' : 'close'
    'blur #dest-network-id' : 'saveDestNetworkId'
    'blur #start-hour, #start-minute, #start-second' : 'saveStartTime'
    'blur #sample-hour, #sample-minute, #sample-second' : 'saveSampleTime'
    'blur #std-dev-add' : 'saveStdDevAdd'
    'blur #std-dev-mult' : 'saveStdDevMult'
    'change #vehicle-type' : 'regenerateDemandTable'
    'click #add-demand-button' : 'addDemand'
    'click #delete-demand-button' : 'deleteDemand'
    'blur #demand-value' : 'saveDemand'
  }

  # the options argument has the Demand model and type of dialog to create('demand')
  initialize: (options) ->
    @model = options.model
    @link = options.model.link()
    @dataTableId = "demand-table"
    options.templateData = @_getTemplateData()
    template = _.template($("#demand-editor-template").html())
    title  = $a.Util.toStandardCasing("Demand Profile")
    subtitle = $a.Util.toStandardCasing("Link Id " + @link.ident() if @link)
    @$el.attr 'title', "#{title} Editor: #{subtitle}"
    @$el.attr 'id', "demand-editor-template"
    # Populate Underscore.js template
    @template = _.template($("#demand-editor-template").html())
    @$el.html(@template(options.templateData))
    # setup models change events
    @_setupEvents()

  # call the super class to set up the dialog box and then set the select box
  render: ->
    # Render demand data table
    @renderDemandTable()
    @_checkMode()
    @_checkDisableFields()
    @_attachRowSelection()
    # change size of map container to accomidate profile editor
    $('#map_canvas').css('height', '60%')
    $('#right_tree').css('height', '60%')

    # change size of demand profile editor container
    $('.bottom-profile-editor ').css('height', '40%')
    @

  # Set up profiles on change events
  _setupEvents: ->
    # Setup profile model change events
    @model.on('change:link_id change:destination_network_id change:dt change:start_time
      change:std_dev_mult change:std_dev_add change:knob',
      => @_updateProfile())
    demands = @model?.demands()
    # for each demand in profile add changed events
    if demands?
      $.each(demands, (index, demand) =>
        # for each demand in profile setup model change events
        demand.on('change:text',
          => @_updateProfile())
      )

  # if in a demand we disable some fields
  _checkDisableFields: ->
    # disable the add and delete demand buttons
    @$el.find("#add-demand-button").attr('disabled', true)
    @$el.find("#delete-demand-button").attr('disabled', true)

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
    linkId: @model.link_id()
    destNetworkId: @model?.destination_network_id()
    startTime: $a.Util.convertSecondsToHoursMinSec(@model?.start_time() || 0)
    sampleTime: $a.Util.convertSecondsToHoursMinSec(@model?.dt() || 0)
    stdDevAdd: @model?.std_dev_add() || 0
    stdDevMult: @model?.std_dev_mult() || 1

  # gets the column data for the table if 0's are passed in for vehicle type id, all demands are returned
  _getDemandData: (vehicleTypeId) ->
    dataArray = []
    demands = @model?.demands()
    # if demands exist create a data array of their attributes
    if demands?
      $.each(demands, (index, demand) ->

        # check if demand is applicable, based on vehicleTypeId
        if vehicleTypeId == "0" or demand.vehicle_type_id() == Number(vehicleTypeId)

          # for each demand offset, create datatable row array of data
          i=0
          while i < demand.max_offset()
            dataArray.push([
              demand.ident(),
              i,
              demand.vehicle_type_id(),
              demand.demand(i)
            ])
            i++
      )
    dataArray

  # set up Demand columns and their titles for the data table
  _getDemandColumns: () ->
    columns =  [
      { "sTitle": "Id","bVisible": false},
      { "sTitle": "Demand Order","sWidth": "30%"},
      { "sTitle": "Vehicle Type ID","sWidth": "30%"},
      { "sTitle": "Demand","sWidth": "40%"},
    ]

  # render the Demand table in the left pane
  renderDemandTable: () ->
    @dTable = @$el.find("##{@dataTableId}").dataTable( {
      "aaData": @_getDemandData("0"),
      "aoColumns": @_getDemandColumns(),
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

  # removes all event listeners
  _clearEvents: () ->
    # remove profile model change events
    @model.off('change:link_id change:destination_network_id change:dt change:start_time
          change:std_dev_mult change:std_dev_add change:knob')
    demands = @model?.demands()
    # for each demand in profile remove change events
    if demands?
      $.each(demands, (index, demand) =>
        # for each demand in profile setup model change events
        demand.off('change:text')
      )

  # Update set's and profile's CrudFlag
  _updateProfile: () ->
    # set crud flag to update for demand set and demand profile
    $a.models.demand_set().set_crud_flag(window.beats.CrudFlag.UPDATE)
    @model.set_crud_flag($a.CrudFlag.UPDATE)

  # Closes the dialog box
  close: () ->
    @_clearEvents()
    # change size of demand profile editor container to 0%
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
  # This is used to save the Additive Uncertainty when focus is
  # lost from the element
  saveStdDevAdd: (e) ->
    id = e.currentTarget.id
    @model.set_std_dev_add($("##{id}").val())

  # these are callback events for various elements in the interface
  # This is used to save the Multiplicative Uncertainty when focus is
  # lost from the element
  saveStdDevMult: (e) ->
    id = e.currentTarget.id
    @model.set_std_dev_mult($("##{id}").val())

  # these are callback events for various elements in the interface
  # This is used to save a profiles demand when focus is
  # lost from the element
  saveDemand: (e) ->
    id = e.currentTarget.id
    # get demand, offset and vehicle type ids
    value = @$el.find("##{id}").val()
    offset = @$el.find("##{id}").closest("tr").find("td:first").html()
    vehicleTypeId = @$el.find("##{id}").closest("tr").find("td:nth-child(2)").html()

    # get demand model and save new value
    demand = @model.demand(vehicleTypeId)
    demand.set_demand(value, offset)
    demand.set_crud_flag($a.CrudFlag.UPDATE, offset)

  # regenerate demand table based on selected vehicle type id
  regenerateDemandTable: (e) ->
    # get vehicle type id for demand
    vehicleTypeId = @$el.find('#vehicle-type').find(":selected").val()
    # clear data table
    @dTable.fnClearTable()
    # regenerate it based on newly set vehicle type
    @dTable.fnAddData(@_getDemandData(vehicleTypeId))

    # if vehicle type is set to enable add demand button
    if vehicleTypeId != "0"
      @$el.find("#add-demand-button").attr('disabled', false)
    # otherwise disable it
    else
      @$el.find("#add-demand-button").attr('disabled', true)

  # add demand to profile
  addDemand: (e) ->
    # get vehicle type id for demand
    vehicleTypeId = @$el.find('#vehicle-type').find(":selected").val();
    # Find if there exists any demand with the given vehicle type id
    demand = @model.demand(vehicleTypeId)

    # if no demand exits, create it and add it to profile
    if not demand?
      demand = new $a.Demand()
      demand.set_vehicle_type_id(vehicleTypeId)
      @model.demands().push(demand)

    # get last set dt offset of demand
    offset = demand.max_offset()
    demand.set_demand("0.0", offset) # demand value added defaults to 0
    demand.set_crud_flag($a.CrudFlag.CREATE, offset)

    # Add new record to data table
    @dTable.dataTable().fnAddData([
      -1, # set id of newly created demand to -1, to better keep track of them until saved in DB
      offset,
      vehicleTypeId,
      demand.demand(offset)
    ])
    # update Demand profile crudflag
    @_updateProfile()

  # add demand to profile
  deleteDemand: (e) ->
    alert("delete demand")

  # highlights selected row
  _attachRowSelection: () ->
    instance = @
    # attach click event listenor for row selection and editable data table
    @$el.find("##{@dataTableId} tbody").on("click", "tr", (e) ->

      # if row is not selected remove selection add row selection
      if !$(@).hasClass('row_selected')
        # remove row selected class to other selected demand
        rows = instance.$el.find("##{instance.dataTableId} tbody tr.row_selected")
        rows.removeClass('row_selected')
        # remove input box for previous select row(s)
        for row in rows
          # asynchronously remove input box from row with delay to ensure blur event
          # which saves data entered in it is handled first
          setTimeout(instance._removeInputBoxFromRow(row), 200)

        # add row selected class to row and create input box to make demand editable
        $(@).addClass('row_selected')
        instance._addInputBoxToRow(@)

      # check if delete button should be enabled or disabled

    )

  # Add input box to demand column in selected row in datatable
  _addInputBoxToRow: (row) ->
    # get last column which is demand, and get it's value
    cell = $(row).find("td:last")
    demand = $(cell).html()

    # replace demand value in column with input box
    $(cell).html('<input type="text" id="demand-value" class="text ui-widget ui-widget-content ui-corner-all"' +
    'value="' + demand + '"/>')

  # Removes input box from row, and puts input box value back into datatable
  _removeInputBoxFromRow: (row) ->
    cell = $(row).find("td:last")
    demand = $(cell).find("input").val()
    $(cell).html(demand)

