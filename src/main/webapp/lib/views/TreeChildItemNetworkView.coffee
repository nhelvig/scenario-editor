  # The view class for each network child item in the tree view. Each child item
# is <li> tag with an anchor surrounding the name.
class window.beats.TreeChildItemNetworkView extends window.beats.TreeChildItemView
  $a = window.beats

  # Overridden method that trigger the select/clear netowrk event as well
  # as highlights itself
  manageHighlight:  ->
    $a.broker.trigger('map:clear_selected') unless $a.ALT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.ALT_DOWN

    if !@highlighted
      @highlighted = true
      $a.broker.trigger("map:select_network:#{@model.cid}")
      @highlight()
    else
      @highlighted = false
      $a.broker.trigger("map:clear_network:#{@model.cid}")
      @removeHighlight()