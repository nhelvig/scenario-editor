class window.beats.Route extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Route()
    route_link = xml.children('route_link')
    obj.set('route_link', _.map($(route_link), (route_link_i) -> $a.RouteLink.from_xml2($(route_link_i), deferred, object_with_id))) if route_link? and route_link != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    name = $(xml).attr('name')
    obj.set('name', name) if name? and name != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    crudFlag = $(xml).attr('crudFlag')
    obj.set('crudFlag', crudFlag) if crudFlag? and crudFlag != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('route')
    if @encode_references
      @encode_references()
    _.each(@get('route_link') || [], (a_route_link) -> xml.appendChild(a_route_link.to_xml(doc)))
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('name', @get('name')) if @has('name')
    if @has('mod_stamp') && @mod_stamp != "0" then xml.setAttribute('mod_stamp', @get('mod_stamp'))
    xml.setAttribute('crudFlag', @get('crudFlag')) if @has('crudFlag')
    xml
  
  deep_copy: -> Route.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null