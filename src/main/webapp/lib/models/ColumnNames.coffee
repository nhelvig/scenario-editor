class window.beats.ColumnNames extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.ColumnNames()
    column_name = xml.children('column_name')
    obj.set('column_name', _.map($(column_name), (column_name_i) -> $a.ColumnName.from_xml2($(column_name_i), deferred, object_with_id))) if column_name? and column_name != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('column_names')
    if @encode_references
      @encode_references()
    _.each(@get('column_name') || [], (a_column_name) -> xml.appendChild(a_column_name.to_xml(doc)))
    xml
  
  deep_copy: -> ColumnNames.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null