# This creates the Network browser view window
class window.beats.NetworkBrowserView extends Backbone.View
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
    $a.broker.on("app:networkListCallback", @networkListCallback)
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
    

  # Using data tables framework render Network list within data tables
  renderTable: () ->
    $a.networkcollection = new $a.NetworkCollection()
    $a.networkcollection.fetch()
  
  # populates table of list of networks on ajax callback
  networkListCallback: ->
    tabledata = $a.networkcollection.map((network) -> 
        [
          if network.get('id')? then network.get('id') else 12,
          if network.get('name')? then network.get('name') else ''
        ]
      )
    $a.networkbrowser.dTable = $('#network-browser-table').dataTable( {
        "aaData": tabledata,
        "aoColumns": $a.networkbrowser._getColumns(),
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
    $a.networkbrowser.addLoadNetworkListener()
    

  # This method removes the dialog box from the map when clear:map is triggered
  # And completely destroys the view
  close: ->
    @$el.remove()
    @undelegateEvents()
    @$el.removeData().unbind()
    $a.broker.off("app:networkListCallback")

    # Remove view from DOM
    @remove()
    Backbone.View.prototype.remove.call(@)
    

  # set up columns and their titles for the browser
  _getColumns: () ->
    columns =  [
            { "sTitle": "Id","sWidth": "20%"},
            { "sTitle": "Network Name","sWidth": "80%"}
        ]

  # the click event for any row triggers an event to load the specified network
  addLoadNetworkListener: () ->
    #handles the row selection
    $("#network-browser-table tbody").one("click", "tr", ->
      $(@).addClass('row_selected')
    )
    networkId = null

    # Finds selected row triggers event to load this network
    $("#network-browser-table tbody").on("click", "tr", ->
      $($a.networkbrowser.dTable.fnSettings().aoData).each((data) ->  
        if($(@.nTr).hasClass('row_selected'))
          networkId =  @_aData[0]
      )
      # Try and load network and display message
      $a.broker.trigger("app:load_network", networkId)
      # close network browser
      $a.networkbrowser.close()
    )
