class window.beats.Signal extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Signal()
    phase = xml.children('phase')
    obj.set('phase', _.map($(phase), (phase_i) -> $a.Phase.from_xml2($(phase_i), deferred, object_with_id))) if phase? and phase != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    node_id = $(xml).attr('node_id')
    obj.set('node_id', Number(node_id)) if node_id? and node_id != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('signal')
    if @encode_references
      @encode_references()
    _.each(@get('phase') || [], (a_phase) -> xml.appendChild(a_phase.to_xml(doc)))
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('node_id', @get('node_id')) if @has('node_id')
    xml
  
  deep_copy: -> Signal.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null