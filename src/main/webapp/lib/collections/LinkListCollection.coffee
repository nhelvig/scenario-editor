# This class is used to manage our link models. 
class window.beats.LinkListCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Link
  
  # set up the event that calls for the addition of a link to the collection
  # register the links begin and end nodes with the remove method on the model
  # node
  initialize: (@models, @network)->
    $a.broker.on("map:clear_map", @clear, @)
    $a.broker.on("map:redraw_link", @reDrawLink, @)
    $a.broker.on('links_collection:add', @addLink, @)
    $a.broker.on('links_collection:join', @joinLink, @)
    $a.broker.on('links:remove', @removeLink, @)
    $a.broker.on('map:clear_selected', @clearSelected, @)
    if network?
      $a.broker.on("map:select_network:#{@network.cid}", @setSelected, @)
      $a.broker.on("map:clear_network:#{@network.cid}", @clearSelected, @)

    @on('links:hide_link_layer', @hideLinkLayer, @)
    @on('links:show_link_layer', @showLinkLayer, @)
    @on('links:duplicate', @duplicateLink, @)
    @on('links:add_sensor', @addSensorToLink, @)
    @on('links:add_controller', @addControllerToLink, @)
    @on('links:add_event', @addEventToLink, @)
    @on('links:remove', @removeLink, @)
    @on('links:split', @splitLink, @)
    @on('links:split_add_node', @splitLinkAddNode, @)
    @on('links:open_editor', @showEditor, @)
    @on('links:select_neighbors', @setNeighborsSelected, @)
    @on('links:deselect_link', @deSelectLink, @)
    @on('links:view_demand', @viewDemands, @)
    
    @forEach((link) =>  @_setUpEvents(link))
  
  # addLink takes the begin node and end node ids, sets up the appropriate
  # begin and end node objects, creates the link, adds it to the collection
  # and the schema and then sets this link to the output and input fields
  # of the appropriate nodes
  addLink: (args) ->
    link = new window.beats.Link()
    link.set_crud($a.CrudFlag.CREATE)
    id = $a.Util.getNewElemId($a.models.links())
    link.set_id(id)
    
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
  
  # called from context menu of link. Highlight itself and its nodes 
  setNeighborsSelected: (cid) ->
    link = @getByCid(cid)
    link.toggle_selected() if link.selected() is false
    begin = link.begin_node()
    end = link.end_node()
    begin.toggle_selected() if begin.selected() is false
    end.toggle_selected() if end.selected() is false
  
  # set one link selected
  deSelectLink: (cid) ->
    link = @getByCid(cid)
    link.toggle_selected() if link.selected() is true
    
  # this function sets all the links passed in selected field to true. It is
  # called by the BrowserTypeView for links in order to sync the view state
  # between the browser and the map -- if selected in browser it will select
  # it on the map
  setSelected: (links) ->
    links = @models if !links?
    _.each(links, (link) ->
      link.set_selected(true) if link.selected() is false
    )

  # set selected to false for all links. It is triggered
  # when the link browser closes as well as when we initialize the collection
  clearSelected: ->
    @forEach((link) -> 
      link.set('selected', false) if link.selected() is true
    ) unless $a.SHIFT_DOWN
  
  # This removes either the begin or end node from the link if the node
  # itself has been removed from the node collection
  removeNodeReference: (link, type) ->
    link.get(type).set('node', null)
  
  # removeLink removes the link from the collection and takes it off the 
  # map, turns off the begin and end node position change and then
  # re-instante position change for all of each nodes inputs and outputs
  removeLink: (linkID) ->
    link = @getByCid(linkID)
    begin = link.begin_node()
    begin.position().off('change')
    end = link.end_node()
    end.position().off('change')
    @remove(link)
    @_turnOnNodePostionChange(begin.inputs(), begin.id, link)
    @_turnOnNodePostionChange(begin.outputs(), begin.id, link)
    @_turnOnNodePostionChange(end.inputs(), end.id, link)
    @_turnOnNodePostionChange(end.outputs(), end.id, link)
  
  # helper method for removeLink. It turns on the begin and node position 
  # change event for all links that are not the removed link on the begin 
  # and end nodes of the link that was removed. We tried to stop the removed
  # link from responding to the node position change event it was attached too
  # but we could not get the correct context.
  # It appears future backbone releases will have a method to accomplish
  # just this.
  _turnOnNodePostionChange: (elements, nID, removedLink) ->
    _.each(elements, (element) =>
      link = element.link()
      if(not(link.id is removedLink.id))
        begin = link.begin_node()
        end = link.end_node()
        end.position().on('change',(=> @reDrawLink(link)), @) if end.id is nID
        begin.position().on('change',(=> @reDrawLink(link)), @) if begin.id is nID
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
  
  # splits the link by the distance indicated in the subdivide field. The field
  # is set in the link editor tools tab. When the sub-divide is clicked we take
  # the number in the distance text box and set it to the model's subdivide
  # field which triggers this method
  splitLinkByDistance: (link) ->
    distance = link.subdivide()
    length = $a.Util.convertSIToMiles(link.length())
    numLinks = Math.floor(length / distance)
    @splitLink(link.cid, numLinks)
  
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
                    link.ident(),
                    link.link_name(),
                    link.type_name(),
                    link.lanes(),
                    link.begin_node().name(),
                    link.end_node().name()
                  ]
                )
  
  # This method is triggered when a node is dragged. First remove the current
  # link from the map and re-add the new link to the collection which 
  # triggers the creation of view
  reDrawLink: (link) ->
    link.set_geometry ''
    link.set_position null
    link.set_length null
    @remove(link)
    @add(link)
  
  # This method sets up the events each link should listen too
  _setUpEvents: (link) ->
    ch = 'change:lanes change:lane_offset change:length change:speed_limit '
    ch += 'change:link_name change:in_sync'
    link.on(ch, -> link.set_crud_update())
    link.on('change:subdivide', => @splitLinkByDistance(link))
    link.on('remove', -> link.remove())
    link.on('add', -> link.add())
    
    link.link_type().on('change', -> link.set_crud_update()) if(link.link_type()?)
    link.shape().on('change', -> link.set_crud_update()) if(link.shape()?)
    link.dynamics().on('change', -> link.set_crud_update()) if(link.dynamics()?)
    if(link.roads()? and link.roads().road())
      _.map(link.roads().road(), (r) -> r.on('change', -> link.set_crud_update()))
    bNode = link.begin_node()
    eNode = link.end_node()
    bNode.on('remove', => @removeNodeReference(link, 'begin'))
    eNode.on('remove', => @removeNodeReference(link, 'end')) 
    bNode.position().on('change',(=> @reDrawLink(link)), @)
    eNode.position().on('change',(=> @reDrawLink(link)), @)
  
  #view the demands for the link passed in
  viewDemands: (cid) ->
    link =  @getByCid(cid)
    link.show_demands(true)
  
  #show editor for the link passed in
  showEditor: (cid) ->
    link =  @getByCid(cid)
    link.set_editor_show(true)
  
  # hide links
  hideLinkLayer: (type) =>
    @forEach((link) -> link.set_view('hide') if !type? or type is link.type_name())
  
  # show links
  showLinkLayer: (type) =>
    @forEach((link) -> link.set_view('show') if !type? or type is link.type_name())

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