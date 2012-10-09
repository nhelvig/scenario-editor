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
  
  addOne: (position) ->
    latlng = position
    n = new $a.Node()
    pt = new $a.Point()
    pt.set('lat',latlng.lat())
    pt.set('lng',latlng.lng())
    pt.set('elevation', NaN)
    p = new $a.Position()
    p.get('point').splice(0,2) # position starts with two empty points
    p.get('point').push(pt)
    n.set('position', p)
    @add(n)
      