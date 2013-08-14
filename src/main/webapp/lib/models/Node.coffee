class window.beats.Node extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Node()
    roadway_markers = xml.children('roadway_markers')
    obj.set('roadway_markers', $a.RoadwayMarkers.from_xml2(roadway_markers, deferred, object_with_id)) if roadway_markers? and roadway_markers != ""
    outputs = xml.children('outputs')
    obj.set('outputs', $a.Outputs.from_xml2(outputs, deferred, object_with_id)) if outputs? and outputs != ""
    inputs = xml.children('inputs')
    obj.set('inputs', $a.Inputs.from_xml2(inputs, deferred, object_with_id)) if inputs? and inputs != ""
    position = xml.children('position')
    obj.set('position', $a.Position.from_xml2(position, deferred, object_with_id)) if position? and position != ""
    node_type = xml.children('node_type')
    obj.set('node_type', $a.NodeType.from_xml2(node_type, deferred, object_with_id)) if node_type? and node_type != ""
    crudFlag = $(xml).attr('crudFlag')
    obj.set('crudFlag', crudFlag) if crudFlag? and crudFlag != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    node_name = $(xml).attr('node_name')
    obj.set('node_name', node_name) if node_name? and node_name != ""
    in_sync = $(xml).attr('in_sync')
    obj.set('in_sync', (in_sync.toString().toLowerCase() == 'true') if in_sync?) if in_sync? and in_sync != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    if object_with_id.node
      object_with_id.node[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('node')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('roadway_markers').to_xml(doc)) if @has('roadway_markers')
    xml.appendChild(@get('outputs').to_xml(doc)) if @has('outputs')
    xml.appendChild(@get('inputs').to_xml(doc)) if @has('inputs')
    xml.appendChild(@get('position').to_xml(doc)) if @has('position')
    xml.appendChild(@get('node_type').to_xml(doc)) if @has('node_type')
    xml.setAttribute('crudFlag', @get('crudFlag')) if @has('crudFlag')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('node_name', @get('node_name')) if @has('node_name')
    if @has('in_sync') && @in_sync != true then xml.setAttribute('in_sync', @get('in_sync'))
    xml.setAttribute('mod_stamp', @get('mod_stamp')) if @has('mod_stamp')
    xml
  
  deep_copy: -> Node.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null