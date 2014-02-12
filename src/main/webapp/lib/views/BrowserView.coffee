# This creates the browsers window for all element
class window.beats.BrowserView extends Backbone.View
  $a = window.beats
  @BROWSER_NUM: 1
  
  # static method used to instantiate new Browser -- called from main menu
  @start: (type) ->
    switch type
      when 'node' then new window.beats.BrowserNodeView()
      when 'link' then new window.beats.BrowserLinkView()
      when 'sensor' then new window.beats.BrowserSensorView()
      when 'controller' then new window.beats.BrowserControllerView()

  # The options hash contains the type of dialog(eg. 'node'), the model
  # associated with the dialog, and templateData
  # used to inject into the html template
  initialize: (@options) ->
    @elem = @options.elem
    @options.browser_table_id = "#{@options.browser_table_id}-#{BrowserView.BROWSER_NUM}"
    @browser_table_id = "##{@options.browser_table_id}"
    title  = $a.Util.toStandardCasing(@elem)  # eg. node -> Node
    @$el.attr 'title', "#{title} Browser"
    @browser_name = "browser-#{BrowserView.BROWSER_NUM}"
    BrowserView.BROWSER_NUM++
    @$el.attr 'id', @browser_name
    @template = _.template($("#browser-window-template").html())
    @$el.html(@template(@options))  
    # Events Broker used to minimize or maximize browser box 
    # based on triggered events
    $a.broker.on('app:minimize-dialog', @minimize, @)
    $a.broker.on('app:maximize-dialog', @maximize, @)
    $a.broker.on('map:clear_map', @close, @)
    @render()

  # render the dialog box. The calling function has responsability for appending
  # it as well as calling el.tabs and el.diaload('open')
  render:  ->
    @$el.dialog
      autoOpen: false,
      modal: false,
      open: ->
        $('.ui-state-default').blur() #hack to get ui dialog focus bug

    @renderTable()
    @renderEditor()
    @$el.dialog('open')
    @renderResizer()
    @attachRowSelection()
    @_firstRowSelected()
    @
  
  # This method removes the dialog box from the map when clear:map is triggered
  close: ->
     @$el.remove()
  
  # render the editor for the right pane
  renderEditor: (@nev) ->
    @nev.render()
    $(@nev.el).tabs()
    $("##{@browser_name} #right").append(@nev.el)
  
  # render the table in the left pane
  renderTable: () ->
    @dTable = $(@browser_table_id).dataTable( {
        "aaData": @_getData(),
        "aoColumns": @_getColumns(),
        "aaSorting": [[ 0, "desc" ]]
        "bPaginate": true,
        "bLengthChange": true,
        "bFilter": false,
        "bSort": true,
        "bInfo": false,
        "bAutoWidth": false,
        "bJQueryUI": true,
    })
  
  # upon redering make sure first row is selected
  _firstRowSelected: () ->
    nTop = $("#{@browser_table_id} tbody tr")[0]
    $(nTop).addClass('row_selected')
    $("#{@browser_table_id} tbody").click()
  
  # this renders the resize bar between panes
  renderResizer: (e) ->
    prevPos = 0
    @_setResizerHeight()
    
    $("##{@browser_name} #resize").draggable({
      axis : 'x',
      start: (e) ->
        prevPos = e.pageX
      drag: (e) =>
        @_setResizerHeight()
        right = "##{@browser_name} #right"
        left = "##{@browser_name} #left"
        total = $(left).width() + $(right).width()
        delta = (prevPos - e.pageX)
        prevPos = e.pageX
        divLeftWidth = $(left).width() - delta
        divRightWidth = $(right).width() + delta
        if divLeftWidth < 150 or divRightWidth < 150
          divRightWidth = $(right).width()
          divLeftWidth = $(left).width() 

        $(left).css('width', divLeftWidth / total * 100 + '%')
        $(right).css('width', divRightWidth / total * 100 + '%')
        $("##{@browser_name} #resize").css('position', '')
    })
  
  # this height of the resize bar is dependent on which side of browser is
  # taller
  _setResizerHeight: () ->
    browserHeight = $("##{@browser_name} #right").height() - 3
    datatableHeight = $("##{@browser_name} #left").height()
    height = browserHeight
    height = datatableHeight if datatableHeight > height
    
    handleTop = height / 2 - 25
    $("##{@browser_name} #handle").css('margin-top', "#{handleTop}px")
    $("##{@browser_name} #resize").css('height', "#{height}px")
  
  # the click event for each row. Every row clicked triggers a rendering
  # of the editor in the right pane
  attachRowSelection: () ->
    bid = @browser_table_id
    #handles the row selection
    $("#{@browser_table_id} tbody").on("click", "tr", ->
      if $(this).hasClass('row_selected')
        $(this).removeClass('row_selected')
      else
        rows = $("#{bid} tbody tr.row_selected")
        rows.removeClass('row_selected') unless $a.ALT_DOWN
        $(this).addClass('row_selected')
    )

    #handles the editor rendering
    $("#{@browser_table_id} tbody").click( (event) =>
      selectedIds = []
      $(@dTable.fnSettings().aoData).each((data) ->
        if($(this.nTr).hasClass('row_selected'))
          selectedIds.push @_aData[0]
      )
      selectedModels = @_configureSelectedElems(selectedIds)
      tabSelected = $(@nev.el).tabs().tabs('option', 'selected')
      $("##{@browser_name} #right [id*='dialog-form']").remove()
      @renderEditor(selectedModels) unless _.isEmpty(selectedIds)
      $(@nev.el).tabs("select", tabSelected)
    )
  
  # if any change in the editor is made the table itself is rendered again
  # to make sure the state is synchronized
  rePopulateTable: () ->
    # Check if this method fired because of a selected attribute change
    if arguments?[0]._changed.hasOwnProperty('selected')
      selected = true
    # Don't repopulate table if the model change event fired because of it was selected
    if not selected
      @data = @_getData()
      rowIndex = 0
      self = this
      $(@dTable.fnSettings().aoData).each( (data) ->
          if($(this.nTr).hasClass('row_selected'))
            self.dTable.fnUpdate(self.data[rowIndex],rowIndex)
          rowIndex++
      )

  # Minimize the editor or browser window to bottom of parent window
  minimize: () ->
    #TODO: hard code these default dialog box settings/sizes within 
    # the browser or editor class?
    $('.ui-dialog').animate
      height: '35px',
      width: '200px',
      top: $('#map_canvas').height() - 50

    # Save all events on the Browser Dialog Box
    @dialogEvents = $('.ui-dialog').data('events')
    # Unbind all events which allow for dialog box to be resized or moved
    $('.ui-dialog').unbind()
    # Add on-click event to browser dialog header to maximize window
    $('.ui-dialog-titlebar').on('click', ->
                                  $a.broker.trigger('app:maximize-dialog'))
    # Display message to screen 
    $a.broker.trigger('app:show_message:info', """Select Scenario Elements... 
      Click Editor Box when done.""" )

  # Maximize the editor or browser window to orginal location
  maximize: () ->
    #TODO: hard code these default dialog box settings/sizes
    # within the browser or editor class?
    $('.ui-dialog').animate
      height: '250px',
      width: '800px',
      top: '128px'

    # Re-enable all browser dialog events to what it was before it was minimized
    $('.ui-dialog').data('events', @dialogEvents)