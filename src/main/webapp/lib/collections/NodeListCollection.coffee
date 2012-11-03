# This class is used to manage our node models. 
class window.beats.NodeListCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Node
  
  # when initialized go through the models and set selected to false, and 
  # set up all the events need to add nodes to the collection.  
  initialize:(@models) ->
    @clearSelected()
    @forEach((node) -> node.bind('remove', => @destroy))
    @on('nodes:add', @addNode, @)
    @on('nodes:add_link', @addLink, @)
    @on('nodes:add_origin', @addLinkOrigin, @)
    @on('nodes:add_dest', @addLinkDest, @)
    @on('nodes:remove', @removeNode, @)
  
  # the node browser calls this to gets the column data for the table
  getBrowserColumnData: () ->
    @models.map((node) -> [node.get('id'), node.get('name'),node.get('type')])
  
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
  
  # removeNode removes this node from the collection and takes it off the 
  # map.
  removeNode: (nodeID) ->
    node = _.filter(@models, (node) -> node.cid is nodeID)
    @remove(node)
  
  # addNode creates a node of the type and at the position passed in and adds
  # to the collection. It is called from the context menu's add node event
  addNode: (position, type) ->
    latlng = position
    n = new $a.Node()
    pt = new $a.Point()
    pt.set('lat',latlng.lat())
    pt.set('lng',latlng.lng())
    pt.set('elevation', NaN)
    p = new $a.Position()
    p.get('point').splice(0,2) # position starts with two empty points
    p.get('point').push(pt)
    n.set('position', p)
    n.set('type', type || 'simple')
    @add(n)
    n

  # addLink is called from the conttext menus add Link item when there is
  # one other node selected. It adds a node at the position where the event
  # occurred, finds the other selected node, and then creates the link
  # via the triggering of the link_coll:add method
  addLink: (position) ->
    node = @addNode(position)
    selNode = @_getSelectedNode()
    $a.broker.trigger('link_coll:add', {begin:selNode[0], end:node})
  
  # similar to addLink above except it creates a terminal node and draws the link
  # from this position to the other selected node
  addLinkOrigin: (position) ->
    node = @addNode(position,'terminal')
    selNode = @_getSelectedNode()
    $a.broker.trigger('link_coll:add', {begin:node, end:selNode[0] })
  
  # similar to addLink above except it creates a terminal node and draws the link
  # to this position from the other selected node
  addLinkDest: (position) ->
    node = @addNode(position, 'terminal')
    selNode = @_getSelectedNode()
    $a.broker.trigger('link_coll:add', {begin:selNode[0], end:node})
  
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

