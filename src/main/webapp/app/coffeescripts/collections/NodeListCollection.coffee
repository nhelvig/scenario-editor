class window.sirius.NodeListCollection extends Backbone.Collection
  $a = window.sirius
  model: $a.Node
  
  initialize:(@models) ->
    @forEach((node) -> node.set('selected', false))
    @on('nodes:add', @addOne, @)
    @on('nodes:add_link', @addLink, @)
    @on('nodes:add_origin', @addLinkOrigin, @)
    @on('nodes:add_dest', @addLinkDest, @)
  
  getBrowserColumnData: () ->
    @models.map((node) -> [node.get('id'), node.get('name'),node.get('type')])
  
  setSelected: (nodes) ->
    _.each(nodes, (node) ->
      node.set('selected', true) if !node.get('selected')
    )
  
  addOne: (position, type) ->
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
    n.set('type', type || 'simple')
    @add(n)
    n

  addLink: (position) ->
    node = @addOne(position)
    selNode = _.filter(@models, (node) -> node.get('selected') is true)
    $a.broker.trigger('link_coll:add', {begin:selNode[0], end:node})
  
  addLinkOrigin: (position) ->
    node = @addOne(position,'terminal')
    selNode = _.filter(@models, (node) -> node.get('selected') is true)
    $a.broker.trigger('link_coll:add', {begin:node, end:selNode[0] })
    
  addLinkDest: (position) ->
    node = @addOne(position, 'terminal')
    selNode = _.filter(@models, (node) -> node.get('selected') is true)
    $a.broker.trigger('link_coll:add', {begin:selNode[0], end:node})
    
  isOneSelected: ->
    count = 0
    @forEach((node) ->
      if node.get('selected')
        count++
    )
    count is 1