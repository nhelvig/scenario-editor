# This creates the Scenario Browser view window
class window.beats.ScenarioBrowserView extends Backbone.View
  $a = window.beats

  # The options hash contains the the model
  # associated with the dialog, and templateData
  # used to inject into the html template
  initialize: (@options) ->
    title  = $a.Util.toStandardCasing(@options.title)  # eg. node -> Node
    @$el.attr 'title', "#{title} Browser"
    @$el.attr 'id', "browser"
    @template = _.template($("#scenario-browser-template").html())
    @$el.html(@template())
    # Events Broker used to populate browser table on callback
    $a.broker.on("app:scenarioListCallback", @scenarioListCallback)
    @render()

  # render the dialog box.
  # it as well as calling el.tabs and el.diaload('open')
  render:  ->
    @$el.dialog
      autoOpen: false,
      modal: false,
      open: ->
        $('.ui-state-default').blur() #hack to get ui dialog focus bug
      close: =>
        @close()
    @$el.dialog('open')
    @renderTable()
    @


  # Using data tables framework render Scenario list within data tables
  renderTable: () ->
    $a.scenariocollection = new $a.ScenarioCollection()
    $a.scenariocollection.fetch()

  # populates table of list of scenarios on ajax callback
  scenarioListCallback: ->
    tabledata = $a.scenariocollection.map((scenario) ->
      [
        if scenario.get('id')? then scenario.get('id') else 12,
        if scenario.get('name')? then scenario.get('name') else ''
      ]
    )
    $a.scenariobrowser.dTable = $('#scenario-browser-table').dataTable( {
      "aaData": tabledata,
      "aoColumns": $a.scenariobrowser._getColumns(),
      "aaSorting": [[ 0, "desc" ]]
      "bPaginate": true,
      "bLengthChange": true,
      "bFilter": false,
      "bSort": true,
      "bInfo": false,
      "bAutoWidth": false,
      "bJQueryUI": true,
      "bDestroy": true
    })
    $a.scenariobrowser.addLoadScenarioListener()


  # This method removes the dialog box from the map when clear:map is triggered
  # Or dialog box is closed and completely destroys the view from memory
  close: ->
    @$el.remove()
    @undelegateEvents()
    @$el.removeData().unbind()
    $a.broker.off("app:scenarioListCallback")

    # Remove view from DOM
    @remove()
    Backbone.View.prototype.remove.call(@)


  # set up columns and their titles for the browser
  _getColumns: () ->
    columns =  [
      { "sTitle": "Id","sWidth": "20%"},
      { "sTitle": "Scenario Name","sWidth": "80%"}
    ]

  # the click event for any row triggers an event to load the specified scenario
  addLoadScenarioListener: () ->
    #handles the row selection
    $("#scenario-browser-table tbody").one("click", "tr", ->
      $(@).addClass('row_selected')
    )
    scenarioId = null

    # Finds selected row triggers event to load this scenario
    $("#scenario-browser-table tbody").on("click", "tr", ->
      $($a.scenariobrowser.dTable.fnSettings().aoData).each((data) ->
        if($(@.nTr).hasClass('row_selected'))
          scenarioId =  @_aData[0]
      )
      # Try and load scenario and display message
      $a.broker.trigger("app:load_scenario", scenarioId)
      # close scenario browser
      $a.scenariobrowser.close()
    )
