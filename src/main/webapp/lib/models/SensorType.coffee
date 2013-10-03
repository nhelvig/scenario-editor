class window.beats.SensorType extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.SensorType()
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    name = $(xml).attr('name')
    obj.set('name', name) if name? and name != ""
    description = $(xml).attr('description')
    obj.set('description', description) if description? and description != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('sensor_type')
    if @encode_references
      @encode_references()
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('description', @get('description')) if @has('description')
    xml
  
  deep_copy: -> SensorType.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null