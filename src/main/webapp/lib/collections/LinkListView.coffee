# This manages the views for the link collection
class window.beats.LinkListView extends Backbone.Collection
  $a = window.beats
  views : []
  
  broker_events : {
    'map:clear_map' : 'clear'
    'map:draw_link' : 'createAndDrawLink'
    'links:check_proximinity' : 'checkSnap'
  }
  
  collection_events : {
    'add' : 'addAndRender'
    'remove' : 'removeLink'
  }
  
  # set up the draw link and add events and instantiate
  # the MapRouteHanlder for models
  initialize: (@collection, @network) ->
    google.maps.event.addListener($a.map, 'zoom_changed', =>
      @setStrokeWeight()
      @toogleLinkArrow()
    )
    $a.Util.publishEvents($a.broker, @broker_events, @)
    $a.Util.publishEvents(@collection, @collection_events, @)
    @getLinkGeometry(@collection.models)
    @setUpModelsNodePositionChange(@collection.models)

  # create the route handler for the models
  getLinkGeometry: (models) ->
    @routeHandler = new $a.GoogleMapRouteHandler(models)
  
  # ties the position's objects of each node change event to call resetPath for
  # all the models in the collection
  setUpModelsNodePositionChange: (models) ->
    _.each(models, (link) =>
      @setUpNodePositionChange(link) 
    )
  
  setUpNodePositionChange: (link) ->
    bNode = link.begin_node()
    eNode = link.end_node()
    bNode.position().on('change', (=> @resetPath(link)), @)
    eNode.position().on('change', (=> @resetPath(link)), @)
  
  resetPath : (link) ->
    @routeHandler.setNewPath(link)
  
  # this is called when the map:draw_link event is triggered. It created
  # the link view obect, which prepares itself to be drawn on the map
  createAndDrawLink: (link) ->
    mlv = new $a.MapLinkView(link, @network)
    @views.push(mlv)
    mlv
  
  #this method clears the collection upon a clear map
  clear: ->
    $a.linkListView = {}
    # turn off events
    $a.Util.unpublishEvents($a.broker, @broker_events, @)
    $a.Util.unpublishEvents(@collection, @collection_events, @)

  # when a link is added to the link collection or a node moved, this function 
  # is called to set up the geometry on the map via the routeHandler. 
  # We force a new route to be drawn by setting the shape to null from here 
  # because if the shape exists it has been moved on the map or we have a new 
  # node that wants a link
  addAndRender: (link) ->
    pos = link.position()
    if (!pos? or pos.length is 0) and (!link.geometry()? or link.geometry() is '')
      @routeHandler.requestLink(link)
    else
      @createAndDrawLink(link)
    link
    @setUpNodePositionChange(link) 
  
  
  # this removes the link from the views array upon removal from collection
  removeLink: (link) ->
    @views = _.reject(@views, (view) => view.model.id is link.id)
    begin = link.begin_node()
    end = link.end_node()
    if begin?
      begin.position().off('change')
      @_turnOnNodePostionChange(begin.inputs(), begin.id, link)
      @_turnOnNodePostionChange(begin.outputs(), begin.id, link)
    if end?
      end.position().off('change')
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
        end.position().on('change',(=> @resetPath(link)), @) if end?.id is nID
        begin.position().on('change',(=> @resetPath(link)), @) if begin?.id is nID
    )
  
  # tests to see if marker is close enough to snap, highlights it
  # sets the link for the model
  checkSnap: (markerView) ->
    geo = google.maps.geometry.poly
    marker = markerView.marker
    model = markerView.model
    _.each(@views, (view) ->
            if geo.isLocationOnEdge(marker.getPosition(), view.link, 0.0006)
                view.linkSelect()
                model.set_link(view.model)
                setTimeout (-> view.clearSelected()), 1000
            else
                view.clearSelected()
          )
  
  # set the strokeweight of all polyline based on the zoom level
  setStrokeWeight: ->
    _.each(@views, (view) -> 
      view.link.setOptions(strokeWeight:view.getLinkStrokeWeight()) if view.link?
    )

  # set the strokeweight of all polyline based on the zoom level
  toogleLinkArrow: ->
    _.each(@views, (view) ->
      view.link.icons[0].icon.path = view.getLinkIconPath() if view.link?
    )