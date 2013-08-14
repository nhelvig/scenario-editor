class window.beats.ScenarioElement extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.ScenarioElement()
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    usage = $(xml).attr('usage')
    obj.set('usage', usage) if usage? and usage != ""
    type = $(xml).attr('type')
    obj.set('type', type) if type? and type != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('scenarioElement')
    if @encode_references
      @encode_references()
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('usage', @get('usage')) if @has('usage')
    xml.setAttribute('type', @get('type')) if @has('type')
    xml
  
  deep_copy: -> ScenarioElement.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null