class window.beats.Interval extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Interval()
    start_time = $(xml).attr('start_time')
    obj.set('start_time', Number(start_time)) if start_time? and start_time != ""
    end_time = $(xml).attr('end_time')
    obj.set('end_time', Number(end_time)) if end_time? and end_time != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('interval')
    if @encode_references
      @encode_references()
    xml.setAttribute('start_time', @get('start_time')) if @has('start_time')
    xml.setAttribute('end_time', @get('end_time')) if @has('end_time')
    xml
  
  deep_copy: -> Interval.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null