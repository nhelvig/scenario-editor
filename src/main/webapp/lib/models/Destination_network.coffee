class window.sirius.Destination_network extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Destination_network()
    link_references = xml.children('link_references')
    obj.set('link_references', $a.Link_references.from_xml2(link_references, deferred, object_with_id))
    id = $(xml).attr('id')
    obj.set('id', id)
    link_id_destination = $(xml).attr('link_id_destination')
    obj.set('link_id_destination', link_id_destination)
    if object_with_id.destination_network
      object_with_id.destination_network[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('destination_network')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('link_references').to_xml(doc)) if @has('link_references')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('link_id_destination', @get('link_id_destination')) if @has('link_id_destination')
    xml
  
  deep_copy: -> Destination_network.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null