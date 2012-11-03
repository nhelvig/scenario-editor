# the browser view for the nodes
class window.beats.BrowserNodeView extends  window.beats.BrowserView
  $a = window.beats
  
  # set up the change event for the nodes. If there is change to a node
  # we re-opulate the table
  initialize: ->
    $a.nodeList.forEach((node) => node.on('change', @rePopulateTable, @))
    super {elem: 'node'}
  
  # set up width for dialog box and let BrowserView render it
  render:() ->
    @$el.dialog({width:600})
    super
  
  # set up editor view for nodes selected in the right pane
  renderEditor: (models) ->
      models = [$a.nodeList.at(0)] unless models?
      super new $a.EditorNodeView(models: models, elem: @elem, width: 300)
  
  # grab the column data for the browser table
  _getData: () ->
      $a.nodeList.getBrowserColumnData()
  
  # set up columns and their titles for the browser
  _getColumns: () ->
    columns =  [
            { "sTitle": "Id","bVisible": false},
            { "sTitle": "Name","sWidth": "50%"},
            { "sTitle": "Type","sWidth": "50%"},
        ]
  
  # get the node models of the items that are selected. Called by BrowserView
  # in order to get the data for each selected model and render it in the
  # editor, this also clears and sets the nodes on the map
  _configureSelectedElems: (selectedIds) ->
    selectedNodes = $a.nodeList.filter((node) ->
      node if _.include(selectedIds, node.get('id'))
    )
    $a.nodeList.clearSelected()
    $a.nodeList.setSelected(selectedNodes)
    selectedNodes

# the browser view for the links
class window.beats.BrowserLinkView extends  window.beats.BrowserView
  $a = window.beats
  
  # set up the change event for the links. If there is change to a node
  # we re-opulate the table
  initialize: ->
    $a.linkList.forEach((link) => link.on('change', @rePopulateTable, @))
    super {elem: 'link'}
  
  # set up editor view for links selected in the right pane
  render:() ->
    @$el.dialog({width:850})
    super
  
  # set up editor view for link selected in the right pane
  renderEditor: (models) ->
    models = [$a.linkList.at(0)] unless models?
    super new $a.EditorLinkView(models: models, elem: @elem, width: 375)
   
  # grab the column data for the browser table
  _getData: () ->
    $a.linkList.getBrowserColumnData()
  
  # set up columns and their titles for the browser
  _getColumns: () ->
    columns =  [
            { "sTitle": "Id","bVisible": false},
            { "sTitle": "Name","sWidth": "17%"},
            { "sTitle": "Road Name","sWidth": "17%"},
            { "sTitle": "Type","sWidth": "17%"},
            { "sTitle": "Lanes","sWidth": "17%"},
            { "sTitle": "Begin","sWidth": "16%"},
            { "sTitle": "End","sWidth": "16%"},
        ]
  
  # get the link models of the items that are selected. Called by BrowserView
  # in order to get the data for each selected model and render it in the
  # editor
  _configureSelectedElems: (selectedIds) ->
    $a.linkList.filter((link) ->
            link if _.include(selectedIds, link.get('id'))
        )

# the browser view for the sensors
class window.beats.BrowserSensorView extends  window.beats.BrowserView
  $a = window.beats

  # set up the change event for the sensors. If there is change to a node
  # we re-opulate the table  
  initialize: ->
    $a.sensorList.forEach((sensor) => sensor.on('change', @rePopulateTable, @))
    super {elem: 'sensor'}
  
  # set up editor view for sensors selected in the right pane
  render:() ->
    @$el.dialog({width:800})
    super
  
  # set up editor view for sensor selected in the right pane
  renderEditor: (models) ->
    models = [$a.sensorList.at(0)] unless models?
    super new $a.EditorSensorView(models: models, elem: @elem, width: 300)
  
  # grab the column data for the browser table  
  _getData: () ->
    $a.sensorList.getBrowserColumnData()
  
  # set up columns and their titles for the browser
  _getColumns: () ->
    columns =  [
            { "sTitle": "Id","bVisible": false},
            { "sTitle": "Type","sWidth": "25%"},
            { "sTitle": "Link Type","sWidth": "25%"},
            { "sTitle": "Links","sWidth": "25%"},
            { "sTitle": "Description","sWidth": "25%"},
        ]
  
  # get the sensor models of the items that are selected. Called by BrowserView
  # in order to get the data for each selected model and render it in the
  # editor
  _configureSelectedElems: (selectedIds) ->
    $a.sensorList.filter((sensor) ->
            sensor if _.include(selectedIds, sensor.get('id'))
        )