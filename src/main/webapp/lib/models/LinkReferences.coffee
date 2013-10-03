class window.beats.LinkReferences extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.LinkReferences()
    link_reference = xml.children('link_reference')
    obj.set('link_reference', _.map($(link_reference), (link_reference_i) -> $a.LinkReference.from_xml2($(link_reference_i), deferred, object_with_id))) if link_reference? and link_reference != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('link_references')
    if @encode_references
      @encode_references()
    _.each(@get('link_reference') || [], (a_link_reference) -> xml.appendChild(a_link_reference.to_xml(doc)))
    xml
  
  deep_copy: -> LinkReferences.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null