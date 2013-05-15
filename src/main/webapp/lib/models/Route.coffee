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
    route_links = xml.children('route_links')
    obj.set('route_links', _.map($(route_links), (route_links_i) -> $a.Route_links.from_xml2($(route_links_i), deferred, object_with_id)))
    id = $(xml).attr('id')
    obj.set('id', Number(id))
    project_id = $(xml).attr('project_id')
    obj.set('project_id', Number(project_id))
    name = $(xml).attr('name')
    obj.set('name', name)
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('Route')
    if @encode_references
      @encode_references()
    _.each(@get('route_links') || [], (a_route_links) -> xml.appendChild(a_route_links.to_xml(doc)))
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('project_id', @get('project_id')) if @has('project_id')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('mod_stamp', @get('mod_stamp')) if @has('mod_stamp')
    xml
  
  deep_copy: -> Route.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null