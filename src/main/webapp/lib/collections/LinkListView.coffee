# This manages the views for the link collection
class window.beats.LinkListView extends Backbone.Collection
  $a = window.beats
  views : []
  
  # set up the draw link and add events and instantiate
  # the MapRouteHanlder for models
  initialize: (@collection, @network) ->
    $a.broker.on("map:clear_map", @clear, @)
    $a.broker.on('map:draw_link', @createAndDrawLink, @)
    $a.broker.on('links:check_proximinity', @checkSnap, @)
    google.maps.event.addListener($a.map, 'zoom_changed', => @setStrokeWeight())
    @collection.on('add', @addAndRender, @)
    @collection.on('remove', @removeLink, @)
    @getLinkGeometry(@collection.models)

  # create the route handler for the models
  getLinkGeometry: (models) ->
    @routeHandler = new $a.GoogleMapRouteHandler(models)
  
  # this is called when the map:draw_link event is triggered. It created
  # the link view obect, which prepares itself to be drawn on the map
  createAndDrawLink: (link) ->
    mlv = new $a.MapLinkView(link, @network)
    @views.push(mlv)
    mlv
  
  #this method clears the collection upon a clear map
  clear: ->
    $a.linkListView = {}
    
  # when a link is added to the link collection or a node moved, this function 
  # is called to set up the geometry on the map via the routeHandler. 
  # We force a new route to be drawn by setting the shape to null from here 
  # because if the shape exists it has been moved on the map or we have a new 
  # node that wants a link
  addAndRender: (link) ->
    if !link.position()? and (!link.geometry()? or link.geometry() is '')
      @routeHandler.requestLink(link)
    else
      @createAndDrawLink(link)
    link
  
  # this removes the link from the views array upon removal from collection
  removeLink: (link) ->
    @views = _.reject(@views, (view) => view.model is link)
  
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