# The view class for each link child item in the tree view. Each child item
# is <li> tag with an anchor surrounding the name.
class window.sirius.TreeChildItemDemandLinkView extends window.sirius.TreeChildItemLinkView
  showContext: (e) ->
    @targets[0].get('contextMenu').options.menuItems.push { label: 'Visualize Demand', className: 'context_menu_item', event: ((e) -> alert('VIsualize'))}
    super