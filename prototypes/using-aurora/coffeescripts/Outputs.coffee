class window.aurora.Outputs extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Outputs()
    output = xml.find('output')
    obj.set 'output', _.map(output, (output_i) -> $a.Output.from_xml2(output_i, deferred, object_with_id))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('outputs')
    if @encode_references
      @encode_references()
    _.each(@get('output') || [], (a_output) -> xml.appendChild(a_output.to_xml()))
    xml
  
  deep_copy: -> Outputs.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null