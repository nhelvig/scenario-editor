class window.beats.Route_links extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Route_links()
    link_references = xml.children('link_references')
    obj.set('link_references', $a.Link_references.from_xml2(link_references, deferred, object_with_id))
    crudFlag = $(xml).attr('crudFlag')
    obj.set('crudFlag', crudFlag)
    id = $(xml).attr('id')
    obj.set('id', Number(id))
    link_order = $(xml).attr('link_order')
    obj.set('link_order', Number(link_order))
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('route_links')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('link_references').to_xml(doc)) if @has('link_references')
    xml.setAttribute('crudFlag', @get('crudFlag')) if @has('crudFlag')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('link_order', @get('link_order')) if @has('link_order')
    xml.setAttribute('mod_stamp', @get('mod_stamp')) if @has('mod_stamp')
    xml
  
  deep_copy: -> Route_links.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null