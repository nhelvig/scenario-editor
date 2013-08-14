class window.beats.ColumnName extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.ColumnName()
    name = $(xml).attr('name')
    obj.set('name', name) if name? and name != ""
    key = $(xml).attr('key')
    obj.set('key', (key.toString().toLowerCase() == 'true') if key?) if key? and key != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('column_name')
    if @encode_references
      @encode_references()
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('key', @get('key')) if @has('key')
    xml
  
  deep_copy: -> ColumnName.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null