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
    @on('links:add_sensor', @addSensorToLink, @)
    @on('links:remove', @removeLink, @)
    @forEach((link) =>  @_setUpEvents(link))
  
  # addLink takes the begin node and end node ids, sets up the appropriate
  # begin and end node objects, creates the link, adds it to the collection
  # and adds it to the schema
  addLink: (args) ->
    link = new window.beats.Link()
    
    id = $a.Util.getNewElemId($a.models.links())
    link.set('id', id)
    
    begin = new window.beats.Begin()
    begin.set('node_id', args.begin.get('id'))
    begin.set('node', args.begin)
    
    end = new window.beats.End()
    end.set('node_id', args.end.get('id'))
    end.set('node', args.end)
    
    link.set('begin', begin)
    link.set('end', end)
    @add(link)
    $a.models.links().push(link)
    @_setUpEvents(link)
    link
  
  # This removes either the begin or end node from the link if the node
  # itself has been removed from the node collection
  removeNode: (link, type) ->
    link.get(type).set('node', null)
  
  # removeLink removes the link from the collection and takes it off the 
  # map.
  removeLink: (linkID) ->
    link = _.filter(@models, (link) -> link.cid is linkID)
    @remove(link)
  
  # this method clears the collection upon a clear map as well shuts off the 
  # events it is listening too.
  clear: ->
    $a.linkList = {}
    $a.broker.off('map:redraw_link')
    $a.broker.off('links_collection:add')
    @off('links:remove')
  
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
    link.bind('remove', => @destroy)
    bNode = link.begin_node()
    eNode = link.end_node()
    bNode.bind('remove', => @removeNode(link, 'begin'))
    eNode.bind('remove', => @removeNode(link, 'end')) 
    bNode.position().on('change',(=> @reDrawLink(link)), @)
    eNode.position().on('change',(=> @reDrawLink(link)), @)

  # This method adds a sensor to the link id passed in
  addSensorToLink: (pos, cid) ->
    link = @_getLink(cid)
    $a.broker.trigger("sensors:add", pos, link)

  # Find a link in the list by cid
  _getLink : (cid) ->
    @models.filter((link) -> link.cid is cid)[0]