class window.aurora.LinkGeometry extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.LinkGeometry()
    EncodedPolyline = xml.find('EncodedPolyline')
    obj.set 'encodedpolyline', $a.EncodedPolyline.from_xml2(EncodedPolyline, deferred, object_with_id)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('LinkGeometry')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('encodedpolyline').to_xml()) if @has('encodedpolyline')
    xml
  
  deep_copy: -> LinkGeometry.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null