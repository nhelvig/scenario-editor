# This class can deleted once we are resolving all the references of links and
# nodes on the xsd2bb side
class window.sirius.MapNetworkModel extends Backbone.Model
  $a = window.sirius
  @LINKS : []
  @NODES : []
  
  initialize: ->
    network = $a.models.get('networklist').get('network')[0]
    MapNetworkModel.LINKS = network.get('linklist').get('link')
    MapNetworkModel.NODES = network.get('nodelist').get('node')
    $a.broker.on('map:clearMap', @removeAll, @)

  # Removes all links and nodes on the map
  removeAll: ->
    @LINKS = []
    @NODES = []