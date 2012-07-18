# The view class for each node child item in the tree view. Each child item
# is <li> tag with an anchor surrounding the name.
class window.sirius.TreeChildItemNodeView extends window.sirius.TreeChildItemView
  $a = window.sirius
  
  # Overridden method that registers NodeTreeItem to appropriate layer hide/show events
  setUpEvents: ->
    $a.broker.on('map:show_node_layer', @showItem, @)
    $a.broker.on('map:hide_node_layer', @hideItem, @)
    _.each(@targets, (target) => 
      $a.broker.on("app:tree_highlight:#{target.cid}", @highlight, self)
      $a.broker.on("app:tree_remove_highlight:#{target.cid}", @removeHighlight, self)
      $a.broker.on("map:nodes:show_#{target.get('type')}", @showItem, @)
      $a.broker.on("map:nodes:hide_#{target.get('type')}", @hideItem, @)
      ) if @targets?
    super
    