# This class is used to manage our node models. 
class window.beats.NodeListCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Node
  nextID = 9999
  
  # when initialized go through the models and set selected to false, and 
  # set up all the events need to add nodes to the collection.
  initialize:(@models) ->
    @clearSelected()
    @forEach((node) => @_setUpEvents(node))
    $a.broker.on('map:clear_map', @clear, @)
    $a.broker.on('nodes:add', @addNode, @)
    $a.broker.on('nodes:remove', @removeNode, @)
    @on('nodes:add_link', @addLink, @)
    @on('nodes:add_connecting_link_orig', @addConnectingLinkOrigin, @)
    @on('nodes:add_connecting_link_dest', @addConnectingLinkDest, @)
    @on('nodes:add_origin', @addLinkOrigin, @)
    @on('nodes:add_dest', @addLinkDest, @)
  
  # the node browser calls this to gets the column data for the table
  getBrowserColumnData: () ->
    @models.map((node) -> 
      [node.get('id'), node.road_names(), node.get('type')]
    )
  
  # this function sets all the nodes passed in selected field to true. It is
  # called by the BrowserTypeView for nodes in order to sync the view state
  # between the browser and the map -- if selected in browser it will select
  # it on the map
  setSelected: (nodes) ->
    _.each(nodes, (node) ->
      node.set('selected', true) if !node.get('selected')
    )

  # set selected to false for all nodes. It is triggered
  # when the node browser closes as well as when we initialize the collection
  clearSelected: ->
    @forEach((node) -> node.set('selected', false))
  
  # removeNode removes this node, joins any links that may be connected via
  # this node, removes the node from the collection and takes it off the 
  # map. 
  removeNode: (nodeID, linksJoined) ->
    node = @getByCid(nodeID)
    if linksJoined? and linksJoined
      @remove(node)
    else
      $a.broker.trigger("links_collection:join", node)
  
  # addNode creates a node of the type and at the position passed in and adds
  # it to the collection as well as to the models schema. 
  # It is called from the context menu's add node event
  addNode: (position, type) ->
    n = new $a.Node()
    p = new $a.Position()
    pt = new $a.Point()
    pt.set(
            { 
              'lat':position.lat(),
              'lng':position.lng(),
              'elevation':NaN
            }
          )
    p.set('point', []) 
    p.get('point').push(pt)
    n.set('id',nextID++)
    n.set('position', p)
    n.set('type', type) if type?
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
    node = @addNode(position,'terminal')
    selNode = @_getSelectedNode()
    $a.broker.trigger('links_collection:add', {begin:node, end:selNode[0] })
  
  # similar to addLink above except it creates a terminal node and draws the link
  # to this position from the other selected node
  addLinkDest: (position) ->
    node = @addNode(position, 'terminal')
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
  # the context menu handleer to ensure the appropriate items are added
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
    _.filter(@models, (node) -> node.get('selected') is true)

  # This method sets up the events each node should listen too
  _setUpEvents: (node) ->
    node.bind('remove', => node.remove())
    node.bind('add', => node.add())
  
  #this method clears the collection upon a clear map
  clear: ->
    @remove(@models)
    $a.nodeList = {}
    $a.broker.off('nodes:add')
    @off(null, null, @)