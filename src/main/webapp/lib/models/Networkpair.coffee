class window.beats.Networkpair extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Networkpair()
    linkpair = xml.children('linkpair')
    obj.set('linkpair', _.map($(linkpair), (linkpair_i) -> $a.Linkpair.from_xml2($(linkpair_i), deferred, object_with_id))) if linkpair? and linkpair != ""
    network_a = $(xml).attr('network_a')
    obj.set('network_a', Number(network_a)) if network_a? and network_a != ""
    network_b = $(xml).attr('network_b')
    obj.set('network_b', Number(network_b)) if network_b? and network_b != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('networkpair')
    if @encode_references
      @encode_references()
    _.each(@get('linkpair') || [], (a_linkpair) -> xml.appendChild(a_linkpair.to_xml(doc)))
    xml.setAttribute('network_a', @get('network_a')) if @has('network_a')
    xml.setAttribute('network_b', @get('network_b')) if @has('network_b')
    xml
  
  deep_copy: -> Networkpair.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null