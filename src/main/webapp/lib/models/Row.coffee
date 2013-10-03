class window.beats.Row extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Row()
    column = xml.children('column')
    obj.set('column', _.map($(column), (column_i) -> $a.Column.from_xml2($(column_i), deferred, object_with_id))) if column? and column != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('row')
    if @encode_references
      @encode_references()
    _.each(@get('column') || [], (a_column) -> xml.appendChild(a_column.to_xml(doc)))
    xml
  
  deep_copy: -> Row.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null