class window.sirius.LinkListView extends Backbone.Collection
  $a = window.sirius
  views : []
  
  initialize: (@collection, @network) ->
    $a.broker.on('map:draw_link', @createAndDrawLink, @)
    @collection.on('add', @addAndRender, @)
    @getLinkGeometry()
  
  # _drawRoute uses the Google Direction's api to get the data used to render 
  # the route. The network reference is the network you are drawing now
  getLinkGeometry: ->
    @routeHandler = new $a.GoogleMapRouteHandler(@collection.models)
    
  createAndDrawLink: (link) ->
    mlv = new $a.MapLinkView(link, @network)
    @views.push(mlv)
    mlv
  
  addAndRender: (link) ->
    @routeHandler.setUpLink(link)
    link
  
