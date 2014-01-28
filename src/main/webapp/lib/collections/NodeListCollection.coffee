# This class is used to manage our node models. 
class window.beats.NodeListCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Node
  
  broker_events : {
    'map:clear_map' : 'clear'
    'map:clear_selected' : 'clearSelected'
    'nodes:add' :  'addNode'
    'nodes:remove' : 'removeNode'
    'nodes:remove_and_links' : 'removeNodeAndLinks'
    'nodes:remove_and_join' : 'removeNodeAndJoinLinks'
  }
  
  collection_events : {
    'nodes:add_link' : 'addLink'
    'nodes:add_connecting_link_orig' : 'addConnectingLinkOrigin'
    'nodes:add_connecting_link_dest' : 'addConnectingLinkDest'
    'nodes:add_origin' : 'addLinkOrigin'
    'nodes:add_dest' : 'addLinkDest'
  }
  
  # when initialized go through the models and set selected to false, and 
  # set up all the events need to add nodes to the collection.
  initialize:(@models) ->
    @clearSelected()
    @forEach((node) => @_setUpEvents(node))
    $a.Util.publishEvents($a.broker, @broker_events, @)
    $a.Util.publishEvents(@, @collection_events, @)
  
  # the node browser calls this to gets the column data for the table
  getBrowserColumnData: () ->
    @models.map((node) -> 
      [node.ident(), node.name(), node.type_name()]
    )
  
  # this function sets all the nodes passed in selected field to true. It is
  # called by the BrowserTypeView for nodes in order to sync the view state
  # between the browser and the map -- if selected in browser it will select
  # it on the map
  setSelected: (nodes) ->
    _.each(nodes, (node) ->
      node.set('selected', true) if !node.get('selected')
    )

  # this method sets all the selected attributes to false
  # which causes the MapNodeViews to re-render themselves 
  # in an unselected state
  clearSelected: () ->
    @forEach((node) -> 
      if node.selected() or !node.selected()?
        node.set_selected(false)
    )
  
  # removes the node from the collection and takes it off the map. 
  removeNode: (nodeID) ->
    node = @getByCid(nodeID)
    @remove(node)
  
  # removes the node plus any links it is associated with. 
  removeNodeAndLinks: (nodeID) ->
    n = @getByCid(nodeID)
    _.each(n.outputs(), (o) -> $a.broker.trigger('links:remove', o.link().cid))
    _.each(n.inputs(), (i) -> $a.broker.trigger('links:remove', i.link().cid))
    @removeNode(nodeID)
  
  # removes the node and joins any links whose begin node is this node and
  # the another whose end node is this node.
  removeNodeAndJoinLinks: (nodeID) ->
    n = @getByCid(nodeID)
    args = {out:n.outputs(), in:n.inputs(), nodeId: n.id}
    $a.broker.trigger("links_collection:join", args)
    @removeNode(nodeID)

  # addNode creates a node of the type and at the position passed in and adds
  # it to the collection as well as to the models schema. 
  # It is called from the context menu's add node event
  addNode: (position, type) ->
    n = new $a.Node()
    t = new $a.NodeType();
    t.set_name(type.name()) if type?
    
    p = new $a.Position()
    pt = new $a.Point()
    pt.set(
            { 
              'lat':position.lat(),
              'lng':position.lng(),
              'elevation': 0 # default to 0 for elevation setting
            }
          )
    p.set('point', []) 
    p.get('point').push(pt)
    n.set('id', $a.Util.getNewElemId($a.models.nodes()))
    n.set('position', p)
    n.set('node_type', t) if type?
    n.set_crud($a.CrudFlag.CREATE)
    @_setUpEvents(n)
    @add(n)
    n
  
  # addLink is called from the context menus add Link item when there is
  # one other node selected. It adds a node at the position where the event
  # occurred, finds the other selected node, and then creates the link
  # via the triggering of the link_coll:add method
  addLink: (position) ->
    selNode = @_getSelectedNode()
    node = @addNode(position)
    $a.broker.trigger('links_collection:add', {begin:selNode[0], end:node})
  
  # similar to addLink above except it creates a terminal node and draws the link
  # from this position to the other selected node
  addLinkOrigin: (position) ->
    node = @addNode(position, new $a.NodeType({name: 'terminal'}))
    selNode = @_getSelectedNode()
    $a.broker.trigger('links_collection:add', {begin:node, end:selNode[0] })
  
  # similar to addLink above except it creates a terminal node and draws the link
  # to this position from the other selected node
  addLinkDest: (position) ->
    node = @addNode(position, new $a.NodeType({name: 'terminal'}))
    selNode = @_getSelectedNode()
    $a.broker.trigger('links_collection:add', {begin:selNode[0], end:node})
  
  # Adds a link from the node at left clicked to the selected node
  addConnectingLinkOrigin: (nodeID) ->
    clickedNode = _.filter(@models, (node) -> node.cid is nodeID)
    selNode = @_getSelectedNode()
    $a.broker.trigger('links_collection:add', {begin:clickedNode[0], end:selNode[0]})

  # Adds a link to the node at left clicked from the selected node
  addConnectingLinkDest: (nodeID) ->
    clickedNode = _.filter(@models, (node) -> node.cid is nodeID)
    selNode = @_getSelectedNode()
    $a.broker.trigger('links_collection:add', {begin:selNode[0], end:clickedNode[0]})

  # this returns true if exactly one node is selected. It is called by
  # the context menu handler to ensure the appropriate items are added
  # to the context menu if one node is selected
  isOneSelected: ->
    count = 0
    @forEach((node) ->
      if node.get('selected')
        count++
    )
    count is 1
  
  # gets the selected node from the collection
  _getSelectedNode:  ->
    _.filter(@models, (node) -> node.selected() is true)

  # This method sets up the events each node should listen too
  _setUpEvents: (node) ->
    node.on('remove', => node.remove())
    node.on('add', => node.add())
    node.on('change:node_name change:in_sync', 
          -> node.set_crud($a.CrudFlag.UPDATE))
    node.position().on('change', -> node.set_crud_update())
    node.node_type().on('change:name', -> node.set_crud_update())
    _.map(node.roadway_markers().marker(), 
        (m) -> m.on('change', -> node.set_crud_update())
    ) if(node.roadway_markers()? and node.roadway_markers().marker()?)
  
  #this method clears the collection upon a clear map
  clear: ->
    @remove(@models)
    $a.nodeList = {}
    $a.Util.unpublishEvents($a.broker, @broker_events, @)
    $a.Util.unpublishEvents(@, @collection_events, @)