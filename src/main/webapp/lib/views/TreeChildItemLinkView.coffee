# The view class for each link child item in the tree view. Each child item
# is <li> tag with an anchor surrounding the name.
class window.beats.TreeChildItemLinkView extends window.beats.TreeChildItemView
  $a = window.beats

  # Overridden method that registers LinkTreeItem to appropriate layer 
  # hide/show events
  setUpEvents: ->
    if @model.get('targetreferences')?
      @model.get('targetreferences')[0].on('remove', @removeItem, @)
    @model.get('link').on('remove', @removeItem, @) if @model.get('link')?
    
    $a.broker.on('map:show_link_layer', @showItem, @)
    $a.broker.on('map:hide_link_layer', @hideItem, @)
    _.each(@targets, (elem) =>
      $a.broker.on("app:tree_highlight:#{elem.cid}", @highlight, @)
      $a.broker.on("app:tree_remove_highlight:#{elem.cid}", @removeHighlight, @)
      $a.broker.on("map:links:show_#{elem.get('type')}", @showItem, @)
      $a.broker.on("map:links:hide_#{elem.get('type')}", @hideItem, @)
    ) if @targets?
    super