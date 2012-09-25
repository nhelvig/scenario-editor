class window.sirius.BrowserNodeView extends  window.sirius.BrowserView
  $a = window.sirius
  
  initialize: ->
    $a.nodeList.forEach((node) => node.on('change', @rePopulateTable, @))
    super {elem: 'node'}
  
  render:() ->
    @$el.dialog({width:600})
    super
  
  renderEditor: (models) ->
      models = [$a.nodeList.at(0)] unless models?
      super new $a.EditorNodeView(models: models, elem: @elem, width: 300)
      
  _getData: () ->
      $a.nodeList.getBrowserColumnData()
  
  _getColumns: () ->
    columns =  [
            { "sTitle": "Id","bVisible": false},
            { "sTitle": "Name","sWidth": "50%"},
            { "sTitle": "Type","sWidth": "50%"},
        ]
  
  _getSelectedElems: (selectedIds) ->
    selectedNodes = $a.nodeList.filter((node) ->
              node if _.include(selectedIds, node.get('id'))
        )
    #$a.nodeList.setSelected(selectedNodes)
    selectedNodes
  
class window.sirius.BrowserLinkView extends  window.sirius.BrowserView
  $a = window.sirius
  
  initialize: ->
    $a.linkList.forEach((link) => link.on('change', @rePopulateTable, @))
    super {elem: 'link'}
  
  render:() ->
    @$el.dialog({width:850})
    super
  
  renderEditor: (models) ->
    models = [$a.linkList.at(0)] unless models?
    super new $a.EditorLinkView(models: models, elem: @elem, width: 375)
      
  _getData: () ->
    $a.linkList.getBrowserColumnData()
  
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
  
  _getSelectedElems: (selectedIds) ->
    $a.linkList.filter((link) ->
            link if _.include(selectedIds, link.get('id'))
        )

class window.sirius.BrowserSensorView extends  window.sirius.BrowserView
  $a = window.sirius
  
  initialize: ->
    $a.linkList.forEach((link) => link.on('change', @rePopulateTable, @))
    super {elem: 'link'}
  
  render:() ->
    @$el.dialog({width:850})
    super
  
  renderEditor: (models) ->
    models = [$a.linkList.at(0)] unless models?
    super new $a.EditorLinkView(models: models, elem: @elem, width: 375)
      
  _getData: () ->
    $a.linkList.getBrowserColumnData()
  
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
  
  _getSelectedElems: (selectedIds) ->
    $a.linkList.filter((link) ->
            link if _.include(selectedIds, link.get('id'))
        )