# This creates the editor for fundamental diagram profile
class window.beats.EditorFundamentalDiagramProfileView extends Backbone.View
  $a = window.beats
  events : {
    'click #close-icon' : 'close'
    'blur #start-hour, #start-minute, #start-second' : 'saveStartTime'
    'blur #sample-hour, #sample-minute, #sample-second' : 'saveSampleTime'
    'blur #fd-type' : 'saveFDType'
    'click #add-fd-button' : 'addFD'
    'click #delete-fd-button' : 'deleteFD'
    'blur .fd-value-field' : 'saveFDRow'
  }

  # the options argument has the FD model and type of dialog to create('fd')
  initialize: (options) ->
    @model = options.model
    @link = options.model.link()
    @dataTableId = "fd-table"
    options.templateData = @_getTemplateData()
    template = _.template($("#fd-editor-template").html())
    title  = $a.Util.toStandardCasing("Fundamental Diagram Profile")
    subtitle = $a.Util.toStandardCasing("Link Id " + @link.ident() if @link)
    @$el.attr 'title', "#{title} Editor: #{subtitle}"
    @$el.attr 'id', "fd-editor-template"
    # Populate Underscore.js template
    @template = _.template($("#fd-editor-template").html())
    @$el.html(@template(options.templateData))
    # setup models change events
    @_setupEvents()


  # call the super class to set up the dialog box and then set the select box
  render: ->
    @_setSelectedType()
    # Render fundamental diagram data table
    @renderFDTable()
    @_checkMode()
    @_checkDisableFields()
    @_attachRowSelection()
    # change size of map container to accomidate profile editor
    $('#map_canvas').css('height', '60%')
    $('#right_tree').css('height', '60%')

    # change size of fd profile editor container
    $('.bottom-profile-editor ').css('height', '40%')
    @

  # Set up profiles on change events
  _setupEvents: ->
    # Setup profile model change events
    @model.on('change:link_id change:sensor_id change:start_time change:dt change:agg_run_id',
                => @_updateProfile())
    # Set up fd profile type model change events
    fdType = @model?.fundamental_diagram_type()
    # if there is no FD Type set default to id 1

    if not fdType?
      @model.set_fundamental_diagram_type(1)
      fdType = @model?.fundamental_diagram_type()
    fdType.on('change:id', => @_updateProfile())

    fds = @model?.fundamental_diagrams()
    # for each fd in profile add changed events
    if fds?
      $.each(fds, (index, fd) =>
        # for each fd in profile setup model change events
        fd.on('change:order change:capacity change:capacity_drop change:std_dev_capacity
          change:free_flow_speed change:congestion_speed change:critical_speed
          change:std_dev_free_flow_speed change:std_dev_congestion_speed change:jam_density',
            => @_updateProfile(fd))
      )

  # Update Profile's CRUD flag
  _updateProfile: (fd) ->
    # set crud flag to update for fd set, fd profile and fd if passed in
    $a.models.fundamentaldiagram_set().set_crud_flag(window.beats.CrudFlag.UPDATE)
    @model.set_crud_flag($a.CrudFlag.UPDATE)
    if fd?
      fd.set_crud_flag($a.CrudFlag.UPDATE)

  # if in a fd we disable some fields
  _checkDisableFields: ->
    # disable the only the delete fd button
    @$el.find("#delete-fd-button").attr('disabled', true)

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

  # set FD type and Agg Run Type selected type element
  _setSelectedType: ->
    fdType = @model.fundamental_diagram_type_id();
    $(@$el[0]).find("select option[value='#{fdType}']").attr('selected','selected')

  # creates a hash of values taken from the model for the html template
  _getTemplateData: () ->
    linkId: @model.link_id()
    startTime: $a.Util.convertSecondsToHoursMinSec(@model?.start_time() || 0)
    sampleTime: $a.Util.convertSecondsToHoursMinSec(@model?.dt() || 0)

  _getFDRow: (fd) ->
    row = [
      fd.ident(),
      fd.order(),
      fd.capacity(),
      fd.capacity_drop(),
      fd.std_dev_capacity(),
      fd.free_flow_speed(),
      fd.std_dev_free_flow_speed(),
      fd.congestion_speed(),
      fd.std_dev_congestion_speed(),
      fd.critical_speed(),
      fd.jam_density()
    ]

  # gets the column data for all fds under profile
  _getFDData: () ->
    dataArray = []
    fds = @model?.fundamental_diagrams()
    instance = @
    # if fds exist create a data array of their attributes
    if fds?
      $.each(fds, (index, fd) ->
          # for each fd in profile create datatable row array of data
          dataArray.push(instance._getFDRow(fd))
      )
    dataArray

  # set up FundamentalDiagram columns and their titles for the data table
  _getFDColumns: () ->
    columns =  [
      { "sTitle": "Id","bVisible": false},
      { "sTitle": "FD Order","sWidth": "10%"},
      { "sTitle": "Capacity","sWidth": "10%"},
      { "sTitle": "Capacity Drop","sWidth": "10%"},
      { "sTitle": "Capacity Std Dev","sWidth": "10%"},
      { "sTitle": "Free Flow Speed","sWidth": "10%"},
      { "sTitle": "Free Flow Std Dev","sWidth": "10%"},
      { "sTitle": "Congestion Speed","sWidth": "10%"},
      { "sTitle": "Congestion Std Dev","sWidth": "10%"},
      { "sTitle": "Critical Speed","sWidth": "10%"},
      { "sTitle": "Jam Density","sWidth": "10%"},
    ]

  # render the FD table in the left pane
  renderFDTable: () ->
    @dTable = @$el.find("##{@dataTableId}").dataTable( {
      "aaData": @_getFDData("0"),
      "aoColumns": @_getFDColumns(),
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
    @model.off('change:link_id change:sensor_id change:start_time change:dt change:agg_run_id')
    fds = @model?.fundamental_diagrams()
    # if fds exist remove change event listener for each one
    fdType = @model?.fundamental_diagram_type()
    fdType.off('change:id')
    if fds?
      $.each(fds, (index, fd) =>
        # for each fd in profile remove model change events
        fd.off('change:order change:capacity change:capacity_drop change:std_dev_capacity
                  change:free_flow_speed change:congestion_speed change:critical_speed
                  change:std_dev_free_flow_speed change:std_dev_congestion_speed change:jam_density')
      )

  # Closes the dialog box
  close: () ->
    @_clearEvents()
    # change size fd profile editor container to 0%
    $('.bottom-profile-editor ').css('height', '0%')
    # restore size of map container
    $('#map_canvas').css('height', '100%')
    $('#right_tree').css('height', '100%')
    #remove element
    @$el.remove()


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
  # This is used to save the fd type when focus is
  # lost from the element
  saveFDType: (e) ->
    id = e.currentTarget.id
    @model.set_fundamental_diagram_type($("##{id} :selected").val(), $("##{id} :selected").attr("name"))


  # these are callback events for various elements in the FD datatable
  # This is used to save a capcity when focus is
  # lost from the element
  saveFDRow: (e) ->
    id = e.currentTarget.id
    order = e.currentTarget.name
    # get the value to be saved
    value = @$el.find("##{id}").val()
    # get fd with at given row (based on its order value)
    fd = @model.fd_at_order(order)
    # figure out which cell was changed and map to appropriate FD attribute
    switch id
      when 'fd-value-2' then fd.set_capacity(value)
      when 'fd-value-3' then fd.set_capacity_drop(value)
      when 'fd-value-4' then fd.set_std_dev_capacity(value)
      when 'fd-value-5' then fd.set_free_flow_speed(value)
      when 'fd-value-6' then fd.set_std_dev_free_flow_speed(value)
      when 'fd-value-7' then fd.set_congestion_speed(value)
      when 'fd-value-8' then fd.set_std_dev_congestion_speed(value)
      when 'fd-value-9' then fd.set_critical_speed(value)
      when 'fd-value-10' then fd.set_jam_density(value)

  # add FD to profile
  addFD: (e) ->
    # make sure delete button is disabled
    @.$el.find("#delete-fd-button").attr('disabled', true)

    fd = new $a.FundamentalDiagram({crudFlag: window.beats.CrudFlag.CREATE})
    # get maximut order in profile + 1
    maxOrder = @model.max_order() + 1
    fd.set_order(maxOrder)
    @model.fundamental_diagrams().push(fd)

    # Add new record to data table
    @dTable.dataTable().fnAddData(
      @._getFDRow(fd)
    )
    # update FD profile
    @_updateProfile()

  # add fd to profile
  deleteFD: (e) ->
    # will only delete last order fd profile, ensure seleted profile is the last order


  # highlights selected row
  _attachRowSelection: () ->
    instance = @
    # attach click event listenor for row selection and editable data table
    @$el.find("##{@dataTableId} tbody").on("click", "tr", (e) ->
      # get order number of fd clicked on to add to input boxes
      order = $(@).closest("tr").find("td:first").html()

      # if row is not selected remove selection add row selection
      if !$(@).hasClass('row_selected')
        # remove row selected class to other selected fd
        rows = instance.$el.find("##{instance.dataTableId} tbody tr.row_selected")
        rows.removeClass('row_selected')
        # remove input box for previous select row(s)
        for row in rows
          # asynchronously remove input box from row with delay to ensure blur event
          # which saves data entered in it is handled first
          setTimeout(instance._removeInputBoxFromRow(row), 200)

        # add row selected class to row and create input box to make fd editable
        $(@).addClass('row_selected')
        instance._addInputBoxToRow(@, order)

        # if last order fd is highlighted delete button should be enabled
        if instance.model.max_order() == Number(order)
          instance.$el.find("#delete-fd-button").attr('disabled', false)
        # otherwise disable it
        else
          instance.$el.find("#delete-fd-button").attr('disabled', true)
    )

  # Add input box to fd column in selected row in datatable
  _addInputBoxToRow: (row, order) ->
    i = 1
    # get last column which is fd, and get it's value
    $(row).find("td").each( (index, cell) ->
      # skip first row
      if i != 1
        value = $(cell).html()
        # replace fd value in column with input box
        $(cell).html('<input type="text" name="' + order + '" id="fd-value-' + i +
        '" class="fd-value-field text ui-widget ui-widget-content ui-corner-all"' + 'value="' + value + '"/>')
      i++
    )

  # Removes input box from row, and puts input box value back into datatable
  _removeInputBoxFromRow: (row) ->
    cells = $(row).find("td")
    $.each(cells, (index, cell) ->
      fd = $(cell).find("input").val()
      $(cell).html(fd)
    )
