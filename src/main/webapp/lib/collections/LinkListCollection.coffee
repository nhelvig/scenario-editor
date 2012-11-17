# This class is used to manage our link models. 
class window.beats.LinkListCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Link
  
  # set up the event that calls for the addition of a link to the collection
  # register the links begin and end nodes with the remove method on the model
  # node
  initialize: (@models)->
    $a.broker.on("map:redraw_link", @reDrawLink, @)
    $a.broker.on('link_coll:add', @addLink, @)
    @forEach((link) => 
        bNode = link.begin_node()
        eNode = link.end_node()
        bNode.bind('remove', => @removeNode(link, 'begin'))
        eNode.bind('remove', => @removeNode(link, 'end'))  
        bNode.position().on('change',(=> @reDrawLink(link)), @)
        eNode.position().on('change',(=> @reDrawLink(link)), @)

    )
    @forEach((link) -> link.bind('remove', => @destroy))
    @on('links:remove', @removeLink, @)
  
  # addLink takes the begin node and end node ids, sets up the appropriate
  # begin and end node objects, creates the link and adds it to the collection
  addLink: (args) ->
    link = new window.beats.Link()
    begin = new window.beats.Begin()
    begin.set('node_id', args.begin.get('id'))
    begin.set('node', args.begin)
    
    end = new window.beats.End()
    end.set('node_id', args.end.get('id'))
    end.set('node', args.end)
    
    link.set('begin', begin)
    link.set('end', end)
    @add(link)
    link
  
  # This removes either the begin or end node from the link if the node
  # itself has been removed from the node collection
  removeNode: (link, type) ->
    link.set(type, null)
  
  # removeLink removes the link from the collection and takes it off the 
  # map.
  removeLink: (linkID) ->
    link = _.filter(@models, (link) -> link.cid is linkID)
    @remove(link)
  
  # This is called when a link browser is created in order to return
  # the desired column data for the table.
  getBrowserColumnData: () ->
    @models.map((link) ->
                  [
                    link.get('id'),
                    link.get_road_names(),
                    link.get('type'),
                    link.get('lanes'),
                    link.get('begin').get('node').get_road_names(),
                    link.get('end').get('node').get_road_names()
                  ]
                )
  
  # This method is triggered when a node is dragged. First remove the current
  # link from the map and re-add the new link to the collection which 
  # triggers the creation of view
  reDrawLink: (link) ->
    @remove(link)
    @add(link)
    