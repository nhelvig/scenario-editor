# The view class for each node child item in the tree view. Each child item
# is <li> tag with an anchor surrounding the name.
class window.beats.TreeChildItemNodeView extends window.beats.TreeChildItemView
  $a = window.beats

  # Overridden method that registers NodeTreeItem to appropriate layer 
  # hide/show events
  setUpEvents: ->
    @model.get('node').on('remove', @removeItem, @)
    $a.broker.on('map:show_node_layer', @showItem, @)
    $a.broker.on('map:hide_node_layer', @hideItem, @)
    _.each(@targets, (elem) =>
      $a.broker.on("app:tree_highlight:#{elem.cid}", @highlight, @)
      $a.broker.on("app:tree_remove_highlight:#{elem.cid}", @removeHighlight, @)
      $a.broker.on("map:nodes:show_#{elem.get('type')}", @showItem, @)
      $a.broker.on("map:nodes:hide_#{elem.get('type')}", @hideItem, @)
    ) if @targets?
    super