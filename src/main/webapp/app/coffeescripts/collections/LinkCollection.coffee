class window.sirius.LinkCollection extends Backbone.Collection
  $a = window.sirius
  model: $a.Link
  
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