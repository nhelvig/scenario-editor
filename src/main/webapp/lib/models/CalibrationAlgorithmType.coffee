class window.beats.CalibrationAlgorithmType extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.CalibrationAlgorithmType()
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    name = $(xml).attr('name')
    obj.set('name', name) if name? and name != ""
    description = $(xml).attr('description')
    obj.set('description', description) if description? and description != ""
    in_use = $(xml).attr('in_use')
    obj.set('in_use', Number(in_use)) if in_use? and in_use != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('calibrationAlgorithmType')
    if @encode_references
      @encode_references()
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('description', @get('description')) if @has('description')
    xml.setAttribute('in_use', @get('in_use')) if @has('in_use')
    if @has('mod_stamp') && @mod_stamp != "0" then xml.setAttribute('mod_stamp', @get('mod_stamp'))
    xml
  
  deep_copy: -> CalibrationAlgorithmType.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null