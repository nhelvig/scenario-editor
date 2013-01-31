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
    $a.broker.on('links:remove', @removeLink, @)
    @on('links:duplicate', @duplicateLink, @)
    @on('links:add_sensor', @addSensorToLink, @)
    @on('links:add_controller', @addControllerToLink, @)
    @on('links:add_event', @addEventToLink, @)
    @on('links:remove', @removeLink, @)
    @on('links:split', @splitLink, @)
    @on('links:split_add_node', @splitLinkAddNode, @)
    @forEach((link) =>  @_setUpEvents(link))
  
  # addLink takes the begin node and end node ids, sets up the appropriate
  # begin and end node objects, creates the link, adds it to the collection
  # and the schema and then sets this link to the output and input fields
  # of the appropriate nodes
  addLink: (args) ->
    link = new window.beats.Link()
    
    id = $a.Util.getNewElemId($a.models.links())
    link.set('id', id)
    
    if args.duplicate?
      link.set_geometry args.path
      link.legs = []
    
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
    args.begin.outputs().push new window.beats.Output({link: link})
    args.end.inputs().push new window.beats.Input({link: link})
    link
  
  # this function sets all the links passed in selected field to true. It is
  # called by the BrowserTypeView for links in order to sync the view state
  # between the browser and the map -- if selected in browser it will select
  # it on the map
  setSelected: (links) ->
    _.each(links, (link) ->
      link.set('selected', true) if !link.get('selected')
    )

  # set selected to false for all links. It is triggered
  # when the link browser closes as well as when we initialize the collection
  clearSelected: ->
    @forEach((link) -> link.set('selected', false))
  
  # This removes either the begin or end node from the link if the node
  # itself has been removed from the node collection
  removeNodeReference: (link, type) ->
    link.get(type).set('node', null)
  
  # removeLink removes the link from the collection and takes it off the 
  # map.
  removeLink: (linkID) ->
    link = @getByCid(linkID)
    b = link.begin_node()
    b.position().off('change')
    e = link.end_node()
    e.position().off('change')
    @remove(link)
    ########  use inputs and outputs
    @.forEach((link) => 
      if link.begin_node().id is b.id or link.begin_node().id is e.id
        link.begin_node().position().on('change',(=> @reDrawLink(link)), @)
      if link.end_node().id is b.id or link.end_node().id is e.id
        link.end_node().position().on('change',(=> @reDrawLink(link)), @)
    )


  
  # creates a duplicate link to the one passed in
  duplicateLink: (linkID) ->
    link = @getByCid(linkID)
    args = {}
    args.begin = link.begin_node()
    args.end = link.end_node()
    args.path = link.geometry()
    args.duplicate = true
    args.strokeWeight = 1
    @addLink(args)

  # splitLink splits the link in to two links and creates a node at the 
  # position
  splitLinkAddNode: (linkID, pos) ->
    link = @getByCid(linkID)
    begin  = link.begin_node()
    end = link.end_node()
    newNode = $a.nodeList.addNode(pos)
    args = {}
    args.begin = begin
    args.end = newNode
    @addLink(args)
    args = {}
    args.begin = newNode
    args.end = end
    @addLink(args)
    @removeLink(linkID)
  
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
  joinLink: (args) ->
    _.each(args.in, (i) =>
      _.each(args.out, (o) =>
        @_join(i.link(), o.link())
      )
    )
    _.each(args.in, (i) => @remove(i.link()))
    _.each(args.out, (o) => @remove(o.link()))

  # join the two links passed in by combining paths and setting the begin and
  # end node
  _join: (bLink, eLink) ->
    bPath = google.maps.geometry.encoding.decodePath bLink.geometry() 
    ePath = google.maps.geometry.encoding.decodePath eLink.geometry()
    cPath = _.union(bPath, ePath)
    path = google.maps.geometry.encoding.encodePath cPath
    bLink.begin_node().position().off()
    eLink.end_node().position().off()
    @addLink({begin: bLink.begin_node(), end: eLink.end_node(), path: path})
    
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
    link.set_geometry ''
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