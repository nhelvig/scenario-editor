class window.sirius.ContextMenuHandler
  $a = window.sirius
  
  getMenu: ->
    google.maps.event.addListener(
                      $a.map,
                      'rightclick',
                      (mouseEvent) => @_createMenu(mouseEvent)
                    )
  
  _createMenu: (evt) ->
    contextMenuOptions = {}
    contextMenuOptions.menuItems= @_populateMenu()
    contextMenuOptions.id='main-context-menu'
    contextMenuOptions.class='context_menu'
    $a.contextMenu = new $a.ContextMenuView(contextMenuOptions)
    $a.contextMenu.show evt.latLng
  
  _populateMenu: ->
    items = {}
    items = $a.main_context_menu
    items = _.union(items, $a.node_add) if $a.models? or $a.models is not undefined
    items = _.union(items, $a.node_selected) if $a.nodeList.isOneSelected()
    items