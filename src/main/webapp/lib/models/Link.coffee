class window.beats.Link extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Link()
    begin = xml.children('begin')
    obj.set('begin', $a.Begin.from_xml2(begin, deferred, object_with_id))
    end = xml.children('end')
    obj.set('end', $a.End.from_xml2(end, deferred, object_with_id))
    roads = xml.children('roads')
    obj.set('roads', $a.Roads.from_xml2(roads, deferred, object_with_id))
    dynamics = xml.children('dynamics')
    obj.set('dynamics', $a.Dynamics.from_xml2(dynamics, deferred, object_with_id))
    shape = xml.children('shape')
    obj.set('shape', $a.Shape.from_xml2(shape, deferred, object_with_id))
    lanes = $(xml).attr('lanes')
    obj.set('lanes', Number(lanes))
    lane_offset = $(xml).attr('lane_offset')
    obj.set('lane_offset', Number(lane_offset))
    length = $(xml).attr('length')
    obj.set('length', Number(length))
    type = $(xml).attr('type')
    obj.set('type', type)
    id = $(xml).attr('id')
    obj.set('id', id)
    in_sync = $(xml).attr('in_sync')
    obj.set('in_sync', (in_sync.toString().toLowerCase() == 'true') if in_sync?)
    if object_with_id.link
      object_with_id.link[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('link')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('begin').to_xml(doc)) if @has('begin')
    xml.appendChild(@get('end').to_xml(doc)) if @has('end')
    xml.appendChild(@get('roads').to_xml(doc)) if @has('roads')
    xml.appendChild(@get('dynamics').to_xml(doc)) if @has('dynamics')
    xml.appendChild(@get('shape').to_xml(doc)) if @has('shape')
    xml.setAttribute('lanes', @get('lanes')) if @has('lanes')
    if @has('lane_offset') && @lane_offset != 0 then xml.setAttribute('lane_offset', @get('lane_offset'))
    xml.setAttribute('length', @get('length')) if @has('length')
    xml.setAttribute('type', @get('type')) if @has('type')
    xml.setAttribute('id', @get('id')) if @has('id')
    if @has('in_sync') && @in_sync != true then xml.setAttribute('in_sync', @get('in_sync'))
    xml
  
  deep_copy: -> Link.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null