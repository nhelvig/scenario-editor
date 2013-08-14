class window.beats.ActivationIntervals extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.ActivationIntervals()
    interval = xml.children('interval')
    obj.set('interval', _.map($(interval), (interval_i) -> $a.Interval.from_xml2($(interval_i), deferred, object_with_id))) if interval? and interval != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('ActivationIntervals')
    if @encode_references
      @encode_references()
    _.each(@get('interval') || [], (a_interval) -> xml.appendChild(a_interval.to_xml(doc)))
    xml
  
  deep_copy: -> ActivationIntervals.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null