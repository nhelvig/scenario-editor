# This manages the views for the link collection
class window.sirius.LinkListView extends Backbone.Collection
  $a = window.sirius
  views : []
  
  # set up the draw link and add events and instantiate
  # the MapRouteHanlder for models
  initialize: (@collection, @network) ->
    $a.broker.on('map:draw_link', @createAndDrawLink, @)
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
  
  # when a link is added to the link collection, this function is called to 
  # set up the geometry on the map via the routeHandler. We force a new route
  # to be drawn from here because if the geometry exists it has been moved
  # on the map or we have a new node that wants a link
  addAndRender: (link) ->
    forceNewRoute = true
    @routeHandler.setUpLink(link, forceNewRoute)
    link

  # this removes the link from the views array upon removal from collection
  removeLink: (link) ->
    @views = _.reject(@views, (view) => view.model is link)
