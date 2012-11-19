# This class handles the creation and population of any context menu in the
# system
class window.beats.ContextMenuHandler
  $a = window.beats
  
  # set up the listener that allows for a menu to be created on 
  # right-click
  constructor: (args) ->
    google.maps.event.addListener(
                      $a.map,
                      'rightclick',
                      (mouseEvent) => @_createMenu(args, mouseEvent.latLng)
                    )
  
  # sets up the options on the context menu and then populates the menu
  # latlng is used to place the menu
  _createMenu: (args, latLng) ->
    contextMenuOptions = {}
    contextMenuOptions.menuItems= @_populateMenu(args)
    contextMenuOptions.id='main-context-menu'
    contextMenuOptions.class='context_menu'
    $a.contextMenu = new $a.ContextMenuView(contextMenuOptions)
    $a.contextMenu.show latLng
    
  # this method adds the correct items into the list depending on the 
  # context passed through args
  _populateMenu: (args) ->
    items = {}
    items = args.items
    items = _.union(items, $a.node_selected) if $a.nodeList? and $a.nodeList.isOneSelected()
    items