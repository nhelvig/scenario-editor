class window.sirius.LinkListCollection extends Backbone.Collection
  $a = window.sirius
  model: $a.Link
  
  initialize: (@models)->
    $a.broker.on('link_coll:add', @addLink, @)
  
  addLink: (args) ->
    link = new window.sirius.Link()
    begin = new window.sirius.Begin()
    begin.set('node_id', args.begin.get('id'))
    begin.set('node', args.begin)
    
    end = new window.sirius.End()
    end.set('node_id', args.end.get('id'))
    end.set('node', args.end)
    
    link.set('begin', begin)
    link.set('end', end)
    @add(link)
    link
  
  getBrowserColumnData: () ->
    @models.map((link) -> 
                  [
                    link.get('id'),
                    link.get('name'),
                    link.get('road_name'),
                    link.get('type'),
                    link.get('lanes'),
                    link.get('begin').get('node').get('name'),
                    link.get('end').get('node').get('name')
                  ]
                )

  