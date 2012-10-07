class window.sirius.NodeListCollection extends Backbone.Collection
  $a = window.sirius
  model: $a.Node
  
  initialize:(@models) ->
    @forEach((node) -> node.set('selected', false))
    @on('nodes:add', @addOne, @)
  
  getBrowserColumnData: () ->
    @models.map((node) -> [node.get('id'), node.get('name'),node.get('type')])
  
  setSelected: (nodes) ->
    _.each(nodes, (node) ->
      node.set('selected', true) if !node.get('selected')
    )
  
  addOne: (e) ->
    gPoint = new google.maps.Point(e.pageX, e.pageY)
    latlng = $a.map.getProjection().fromPointToLatLng(gPoint)
    window.console.log latlng.lat
    n = new $a.Node()
    pt = new $a.Point()
    pt.set('lat',latlng.lat)
    pt.set('lng',latlng.lng)
    pt.set('elevation', NaN)
    p = new $a.Position()
    p.set('point', pt)
    n.set('position', p)
    @add(n)
      