class window.beats.SignalSet extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.SignalSet()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id)) if description? and description != ""
    signal = xml.children('signal')
    obj.set('signal', _.map($(signal), (signal_i) -> $a.Signal.from_xml2($(signal_i), deferred, object_with_id))) if signal? and signal != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    project_id = $(xml).attr('project_id')
    obj.set('project_id', Number(project_id)) if project_id? and project_id != ""
    name = $(xml).attr('name')
    obj.set('name', name) if name? and name != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('SignalSet')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    _.each(@get('signal') || [], (a_signal) -> xml.appendChild(a_signal.to_xml(doc)))
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('project_id', @get('project_id')) if @has('project_id')
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    xml
  
  deep_copy: -> SignalSet.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null