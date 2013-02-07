# This creates the Network browser view window
class window.beats.NewtorkBrowserView extends Backbone.View
  $a = window.beats

  # The options hash contains the the model
  # associated with the dialog, and templateData
  # used to inject into the html template
  initialize: (@options) ->
    title  = $a.Util.toStandardCasing(@options.title)  # eg. node -> Node
    @$el.attr 'title', "#{title} Browser"
    @$el.attr 'id', "browser"
    @template = _.template($("#network-browser-template").html())
    @$el.html(@template())  
    # Events Broker used to populate browser table on callback
    $a.broker.on("app:newtorkListCallback", @networkListCallback)
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
        @$el.remove()
    @$el.dialog('open')
    @renderTable()

  # Using data tables framework render Network list within data tables
  renderTable: () ->
    $networkcollection.fetch()
  
  networkListCallback: ->
    tabledata = $a.networkcollection.map((network) -> 
        [
          newtork.get('id'),
          network.get('name'), 
          network.get('description')
        ]
      )
    @dTable = $('#browser-table').dataTable( {
        "aaData": tabledata,
        "aoColumns": networkbrowser._getColumns(),
        "aaSorting": [[ 0, "desc" ]]
        "bPaginate": true,
        "bLengthChange": true,
        "bFilter": false,
        "bSort": true,
        "bInfo": false,
        "bAutoWidth": false,
        "bJQueryUI": true,
    })

  # This method removes the dialog box from the map when clear:map is triggered
  close: ->
    @$el.remove()

  # set up columns and their titles for the browser
  _getColumns: () ->
    columns =  [
            { "sTitle": "Id","bVisible": false},
            { "sTitle": "Newtork Name","sWidth": "50%"},
            { "sTitle": "Description","sWidth": "50%"},
        ]