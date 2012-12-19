# This class handles the creation and population of any context menu in the
# system
class window.beats.ContextMenuHandler
  $a = window.beats
  
  # set up the listener that allows for a menu to be created on 
  # right-click
  constructor: (args) ->
    google.maps.event.addListener(
                      args.element,
                      'rightclick',
                      (mouseEvent) => @_createMenu(args, mouseEvent.latLng)
                    )
  
  # sets up the options on the context menu and then populates the menu
  # latlng is used to place the menu
  _createMenu: (args, latLng) ->
    contextMenuOptions = args.options
    contextMenuOptions.menuItems= @_populateMenu(args)
    if args.model?
      # pass the cid as id for the select item so we know what event handler to call
      # since they can be referenced by a models cid
      _.each(contextMenuOptions.menuItems, (item) => item.id = "#{args.model.cid}")
    $a.contextMenu = new $a.ContextMenuView(contextMenuOptions)
    $a.contextMenu.show latLng
    
  # this method adds the correct items into the list depending on the 
  # context passed through args
  _populateMenu: (args) ->
    items = {}
    items = args.items
    items = _.union(items, $a.node_selected) if $a.nodeList? and $a.nodeList.isOneSelected()
    items = _.union(items, $a.node_selected_node_clicked) if $a.nodeList? and $a.nodeList.isOneSelected() and args.model?
    items