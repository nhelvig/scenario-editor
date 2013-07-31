class window.beats.Begin extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Begin()
    node_id = $(xml).attr('node_id')
    obj.set('node_id', Number(node_id)) if node_id? and node_id != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('begin')
    if @encode_references
      @encode_references()
    xml.setAttribute('node_id', @get('node_id')) if @has('node_id')
    xml
  
  deep_copy: -> Begin.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null