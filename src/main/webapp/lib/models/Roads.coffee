class window.beats.Roads extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Roads()
    road = xml.children('road')
    obj.set('road', _.map($(road), (road_i) -> $a.Road.from_xml2($(road_i), deferred, object_with_id))) if road? and road != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('roads')
    if @encode_references
      @encode_references()
    _.each(@get('road') || [], (a_road) -> xml.appendChild(a_road.to_xml(doc)))
    xml
  
  deep_copy: -> Roads.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null