class window.beats.RoadwayMarkers extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.RoadwayMarkers()
    marker = xml.children('marker')
    obj.set('marker', _.map($(marker), (marker_i) -> $a.Marker.from_xml2($(marker_i), deferred, object_with_id))) if marker? and marker != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('roadway_markers')
    if @encode_references
      @encode_references()
    _.each(@get('marker') || [], (a_marker) -> xml.appendChild(a_marker.to_xml(doc)))
    xml
  
  deep_copy: -> RoadwayMarkers.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null