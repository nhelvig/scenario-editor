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
    obj.set('begin', $a.Begin.from_xml2(begin, deferred, object_with_id)) if begin? and begin != ""
    end = xml.children('end')
    obj.set('end', $a.End.from_xml2(end, deferred, object_with_id)) if end? and end != ""
    roads = xml.children('roads')
    obj.set('roads', $a.Roads.from_xml2(roads, deferred, object_with_id)) if roads? and roads != ""
    dynamics = xml.children('dynamics')
    obj.set('dynamics', $a.Dynamics.from_xml2(dynamics, deferred, object_with_id)) if dynamics? and dynamics != ""
    position = xml.children('position')
    obj.set('position', $a.Position.from_xml2(position, deferred, object_with_id)) if position? and position != ""
    shape = xml.children('shape')
    obj.set('shape', $a.Shape.from_xml2(shape, deferred, object_with_id)) if shape? and shape != ""
    link_type = xml.children('link_type')
    obj.set('link_type', $a.LinkType.from_xml2(link_type, deferred, object_with_id)) if link_type? and link_type != ""
    crudFlag = $(xml).attr('crudFlag')
    obj.set('crudFlag', crudFlag) if crudFlag? and crudFlag != ""
    lanes = $(xml).attr('lanes')
    obj.set('lanes', Number(lanes)) if lanes? and lanes != ""
    lane_offset = $(xml).attr('lane_offset')
    obj.set('lane_offset', Number(lane_offset)) if lane_offset? and lane_offset != ""
    length = $(xml).attr('length')
    obj.set('length', Number(length)) if length? and length != ""
    speed_limit = $(xml).attr('speed_limit')
    obj.set('speed_limit', Number(speed_limit)) if speed_limit? and speed_limit != ""
    link_name = $(xml).attr('link_name')
    obj.set('link_name', link_name) if link_name? and link_name != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    in_sync = $(xml).attr('in_sync')
    obj.set('in_sync', (in_sync.toString().toLowerCase() == 'true') if in_sync?) if in_sync? and in_sync != ""
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
    xml.appendChild(@get('position').to_xml(doc)) if @has('position')
    xml.appendChild(@get('shape').to_xml(doc)) if @has('shape')
    xml.appendChild(@get('link_type').to_xml(doc)) if @has('link_type')
    xml.setAttribute('crudFlag', @get('crudFlag')) if @has('crudFlag')
    xml.setAttribute('lanes', @get('lanes')) if @has('lanes')
    if @has('lane_offset') && @lane_offset != 0 then xml.setAttribute('lane_offset', @get('lane_offset'))
    xml.setAttribute('length', @get('length')) if @has('length')
    xml.setAttribute('speed_limit', @get('speed_limit')) if @has('speed_limit')
    xml.setAttribute('link_name', @get('link_name')) if @has('link_name')
    xml.setAttribute('mod_stamp', @get('mod_stamp')) if @has('mod_stamp')
    xml.setAttribute('id', @get('id')) if @has('id')
    if @has('in_sync') && @in_sync != true then xml.setAttribute('in_sync', @get('in_sync'))
    xml
  
  deep_copy: -> Link.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null