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
    @getLinkGeometry()
  
  # create the route handler for the models
  getLinkGeometry: ->
    @routeHandler = new $a.GoogleMapRouteHandler(@collection.models)
  
  # this is called when the map:draw_link event is triggered. It created
  # the link view obect, which prepares itself to be drawn on the map
  createAndDrawLink: (link) ->
    mlv = new $a.MapLinkView(link, @network)
    @views.push(mlv)
    mlv
  
  # when a link is added to the link collection, this function is called to 
  # set up the geometry on the map via the routeHandler 
  addAndRender: (link) ->
    @routeHandler.setUpLink(link)
    link

  # this removes the link from the views array upon removal from collection
  removeLink: (link) ->
    @views = _.reject(@views, (view) => view.model is link)
