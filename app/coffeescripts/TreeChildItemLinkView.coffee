# The view class for each link child item in the tree view. Each child item
# is <li> tag with an anchor surrounding the name.
class window.sirius.TreeChildItemLinkView extends window.sirius.TreeChildItemView
  $a = window.sirius

  # Overridden method that registers LinkTreeItem to appropriate layer hide/show events
  setUpEvents: ->
    $a.broker.on('map:show_link_layer', @showItem, @)
    $a.broker.on('map:hide_link_layer', @hideItem, @)
    _.each(@targets, (target) =>
      $a.broker.on("app:tree_highlight:#{target.cid}", @highlight, self)
      $a.broker.on("app:tree_remove_highlight:#{target.cid}", @removeHighlight, self)
      $a.broker.on("map:links:show_#{target.get('type')}", @showItem, @)
      $a.broker.on("map:links:hide_#{target.get('type')}", @hideItem, @)
    ) if @targets?
    super