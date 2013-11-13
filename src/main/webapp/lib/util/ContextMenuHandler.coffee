# This class handles the creation and population of any context menu in the
# system
class window.beats.ContextMenuHandler
  $a = window.beats
  
  # sets up the options on the context menu and then populates the menu
  # latlng is used to place the menu
  @createMenu: (args, latLng) ->
    contextMenuOptions = args.options
    contextMenuOptions.menuItems= $a.ContextMenuHandler._populateMenu(args)
    if args.model?
      # pass the cid as id for the select item so we know what event handler to
      # call since they can be referenced by a models cid
      _.each(contextMenuOptions.menuItems, (item) => item.id = "#{args.model.cid}")
    $a.contextMenu = new $a.ContextMenuView(contextMenuOptions)
    $a.contextMenu.show latLng
    
  # this method adds the correct items into the list depending on the 
  # context passed through args
  @_populateMenu: (args) ->
    items = []
    items.push i for i in args.items when i.mode is null or eval(i.mode) is true
    items.push $a.context_menu_item_disabled  if(items.length is 0)
    items