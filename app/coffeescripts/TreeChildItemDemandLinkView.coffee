# The view class for each link child item in the tree view. Each child item
# is <li> tag with an anchor surrounding the name.
class window.sirius.TreeChildItemDemandLinkView extends window.sirius.TreeChildItemLinkView
  $a = window.sirius
  showContext: (e) ->
    if !@added_menu_item
      @targets[0].get('contextMenu').options.menuItems.push
        label: 'Visualize Demand'
        className: 'context_menu_item'
        event: (e) -> alert('VIsualize')
      @added_menu_item = true
    super