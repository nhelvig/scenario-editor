class window.beats.DestinationNetworks extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.DestinationNetworks()
    destination_network = xml.children('destination_network')
    obj.set('destination_network', _.map($(destination_network), (destination_network_i) -> $a.Destination_network.from_xml2($(destination_network_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('DestinationNetworks')
    if @encode_references
      @encode_references()
    _.each(@get('destination_network') || [], (a_destination_network) -> xml.appendChild(a_destination_network.to_xml(doc)))
    xml
  
  deep_copy: -> DestinationNetworks.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null