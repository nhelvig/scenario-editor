# This class is used to manage our link models. 
class window.beats.LinkListCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Link
  
  # set up the event that calls for the addition of a link to the collection
  # register the links begin and end nodes with the remove method on the model
  # node
  initialize: (@models)->
    $a.broker.on("map:clear_map", @clear, @)
    $a.broker.on("map:redraw_link", @reDrawLink, @)
    $a.broker.on('links_collection:add', @addLink, @)
    $a.broker.on('links_collection:join', @joinLink, @)
    @on('links:parallel', @parallelLink, @)
    @on('links:add_sensor', @addSensorToLink, @)
    @on('links:add_controller', @addControllerToLink, @)
    @on('links:add_event', @addEventToLink, @)
    @on('links:remove', @removeLink, @)
    @on('links:split', @splitLink, @)
    @forEach((link) =>  @_setUpEvents(link))
  
  # addLink takes the begin node and end node ids, sets up the appropriate
  # begin and end node objects, creates the link, adds it to the collection
  # and adds it to the schema
  addLink: (args) ->
    link = new window.beats.Link()
    
    id = $a.Util.getNewElemId($a.models.links())
    link.set('id', id)
    link.set_geometry args.path if args.path?
    link.set_parallel args.parallel if args.parallel?
    
    begin = new window.beats.Begin()
    begin.set('node_id', args.begin.get('id'))
    begin.set('node', args.begin)
    
    end = new window.beats.End()
    end.set('node_id', args.end.get('id'))
    end.set('node', args.end)
    
    link.set('begin', begin)
    link.set('end', end)
    @_setUpEvents(link)
    @add(link)
    link
  
  # This removes either the begin or end node from the link if the node
  # itself has been removed from the node collection
  removeNodeReference: (link, type) ->
    link.get(type).set('node', null)
  
  # removeLink removes the link from the collection and takes it off the 
  # map.
  removeLink: (linkID) ->
    link = @getByCid(linkID)
    link.begin_node().position().off('change')
    link.end_node().position().off('change')
    @remove(link)
  
  # creates a parallel link to the one passed in
  parallelLink: (linkID) ->
    link = @getByCid(linkID)
    path = google.maps.geometry.encoding.decodePath(link.geometry())
    paths = $a.Util.parallelLines(path, $a.map.getProjection(), 7, 4);
    args = {}
    args.begin = link.begin_node()
    args.end = link.end_node()
    args.path = google.maps.geometry.encoding.encodePath paths.path1
    args.parallel = true
    args.strokeWeight = 1
    @addLink(args)
    args.path = google.maps.geometry.encoding.encodePath paths.path2
    @remove(link)
    @addLink(args)
  
  # splitLink splits the link into a series of nodes
  splitLink: (linkID, numLinks) ->
    link = @getByCid(linkID)
    @removeLink(linkID)
    linkGeom = link.get('shape').get('text')
    path = google.maps.geometry.encoding.decodePath linkGeom
    numPoints = path.length
    args = {}
    args.begin = link.begin_node()
    beginIndex = Math.floor(numPoints/numLinks)
    index = beginIndex
    while numLinks > 1
      endLatLng  = path[index]
      endNode = $a.nodeList.addNode(endLatLng)
      args.end = endNode
      @addLink(args)
      args.begin = endNode
      index += beginIndex
      numLinks--
    args.end = link.end_node()
    @addLink(args)

  # joins links when a connecting node is removed
  joinLink: (node) ->
    nid = node.id
    links = _.filter(@models, (link) -> 
                                  endId = link.end_node().id
                                  beginId = link.begin_node().id
                                  beginId is nid or  endId is nid
                    )
    for linkIndex in [0..links.length - 1]
      link = links[linkIndex]
      linkIndex2 = linkIndex + 1
      while linkIndex2 < links.length
        link2 = links[linkIndex2]
        @_joinMatchingNodes(link, link2)
        linkIndex2++
    _.each((links), (link) =>  @remove(link))
    $a.broker.trigger('nodes:remove', node.cid, true)
  
  _joinMatchingNodes: (link, link2) ->
    if(link.begin_node() is link2.end_node())
        @_join(link2, link, link2.begin_node(), link.end_node())
    else if(link.end_node() is link2.begin_node())
        @_join(link, link2, link.begin_node(), link2.end_node())
    else if(link.end_node() is link2.end_node())
        @_join(link, link2, link.begin_node(), link2.begin_node())
    else if(link.begin_node() is link2.begin_node())
        @_join(link, link2, link.end_node(), link2.end_node())

  _join: (bLink, eLink, bNode, eNode) ->
    bPath = google.maps.geometry.encoding.decodePath bLink.geometry() 
    ePath = google.maps.geometry.encoding.decodePath eLink.geometry()
    cPath = _.union(bPath,ePath)
    path = google.maps.geometry.encoding.encodePath cPath
    bLink.begin_node().position().off()
    eLink.end_node().position().off()
    @addLink({begin: bNode, end: eNode, path: path})
    
  # this method clears the collection upon a clear map as well shuts off the 
  # events it is listening too.
  clear: ->
    @remove(@models)
    $a.linkList = {}
    $a.broker.off("map:redraw_link")
    $a.broker.off('links_collection:add')
    @off(null, null, @)
  
  # This is called when a link browser is created in order to return
  # the desired column data for the table.
  getBrowserColumnData: () ->
    @models.map((link) ->
                  [
                    link.get('id'),
                    link.road_names(),
                    link.get('type'),
                    link.get('lanes'),
                    link.get('begin').get('node').road_names(),
                    link.get('end').get('node').road_names()
                  ]
                )
  
  # This method is triggered when a node is dragged. First remove the current
  # link from the map and re-add the new link to the collection which 
  # triggers the creation of view
  reDrawLink: (link) ->
    @remove(link)
    @add(link)
  
  # This method sets up the events each link should listen too
  _setUpEvents: (link) ->
    link.bind('remove', -> link.remove())
    link.bind('add', -> link.add())
    bNode = link.begin_node()
    eNode = link.end_node()
    bNode.bind('remove', => @removeNodeReference(link, 'begin'))
    eNode.bind('remove', => @removeNodeReference(link, 'end')) 
    bNode.position().on('change',(=> @reDrawLink(link)), @)
    eNode.position().on('change',(=> @reDrawLink(link)), @)

  # This method adds a sensor to the link id passed in
  addSensorToLink: (cid) ->
    link =  @getByCid(cid)
    pos = link.get('contextMenu').position
    $a.broker.trigger("sensors:add", pos, link)
    
  # This method adds a controller to the link id passed in
  addControllerToLink: (cid) ->
    link =  @getByCid(cid)
    pos = link.get('contextMenu').position
    $a.broker.trigger("controllers:add", pos, link)
    
  # This method adds an event to the link id passed in
  addEventToLink: (cid) ->
    link =  @getByCid(cid)
    pos = link.get('contextMenu').position
    $a.broker.trigger("events:add", pos, link)