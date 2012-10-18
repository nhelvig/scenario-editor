class window.sirius.ContextMenuHandler
  $a = window.sirius
  
  constructor: (args) ->
    google.maps.event.addListener(
                      $a.map,
                      'rightclick',
                      (mouseEvent) => @_createMenu(args, mouseEvent.latLng)
                    )
  
  _createMenu: (args, latLng) ->
    contextMenuOptions = {}
    contextMenuOptions.menuItems= @_populateMenu(args)
    contextMenuOptions.id='main-context-menu'
    contextMenuOptions.class='context_menu'
    $a.contextMenu = new $a.ContextMenuView(contextMenuOptions)
    $a.contextMenu.show latLng
    
  _populateMenu: (args) ->
    items = {}
    items = args.items
    items = _.union(items, $a.node_add) if $a.models? or $a.models is not undefined
    items = _.union(items, $a.node_selected) if $a.nodeList? and $a.nodeList.isOneSelected()
    items