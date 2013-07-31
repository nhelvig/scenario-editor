class window.beats.Parameter extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Parameter()
    name = $(xml).attr('name')
    obj.set('name', name) if name? and name != ""
    value = $(xml).attr('value')
    obj.set('value', value) if value? and value != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('parameter')
    if @encode_references
      @encode_references()
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('value', @get('value')) if @has('value')
    if @has('mod_stamp') && @mod_stamp != "0" then xml.setAttribute('mod_stamp', @get('mod_stamp'))
    xml
  
  deep_copy: -> Parameter.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null