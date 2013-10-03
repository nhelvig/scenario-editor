class window.beats.NetworkSet extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.NetworkSet()
    network = xml.children('network')
    obj.set('network', _.map($(network), (network_i) -> $a.Network.from_xml2($(network_i), deferred, object_with_id))) if network? and network != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    project_id = $(xml).attr('project_id')
    obj.set('project_id', Number(project_id)) if project_id? and project_id != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('NetworkSet')
    if @encode_references
      @encode_references()
    _.each(@get('network') || [], (a_network) -> xml.appendChild(a_network.to_xml(doc)))
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('project_id', @get('project_id')) if @has('project_id')
    xml
  
  deep_copy: -> NetworkSet.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null