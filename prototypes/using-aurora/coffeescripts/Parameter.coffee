class window.aurora.Parameter extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Parameter()
    name = $(xml).attr('name')
    obj.set('name', name)
    value = $(xml).attr('value')
    obj.set('value', value)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('parameter')
    if @encode_references
      @encode_references()
    xml.setAttribute('name', @get('name'))
    xml.setAttribute('value', @get('value'))
    xml
  
  deep_copy: -> Parameter.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null