class window.sirius.Table extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Table()
    column_names = xml.children('column_names')
    obj.set('column_names', $a.Column_names.from_xml2(column_names, deferred, object_with_id))
    row = xml.children('row')
    obj.set('row', _.map($(row), (row_i) -> $a.Row.from_xml2($(row_i), deferred, object_with_id)))
    name = $(xml).attr('name')
    obj.set('name', name)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('table')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('column_names').to_xml(doc)) if @has('column_names')
    _.each(@get('row') || [], (a_row) -> xml.appendChild(a_row.to_xml(doc)))
    xml.setAttribute('name', @get('name')) if @has('name')
    xml
  
  deep_copy: -> Table.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null