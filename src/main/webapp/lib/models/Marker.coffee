class window.beats.Marker extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Marker()
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    name = $(xml).attr('name')
    obj.set('name', name) if name? and name != ""
    postmile = $(xml).attr('postmile')
    obj.set('postmile', Number(postmile)) if postmile? and postmile != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('marker')
    if @encode_references
      @encode_references()
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('postmile', @get('postmile')) if @has('postmile')
    if @has('mod_stamp') && @mod_stamp != "0" then xml.setAttribute('mod_stamp', @get('mod_stamp'))
    xml
  
  deep_copy: -> Marker.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null