class window.beats.SplitRatioProfile extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.SplitRatioProfile()
    splitratio = xml.children('splitratio')
    obj.set('splitratio', _.map($(splitratio), (splitratio_i) -> $a.Splitratio.from_xml2($(splitratio_i), deferred, object_with_id))) if splitratio? and splitratio != ""
    crudFlag = $(xml).attr('crudFlag')
    obj.set('crudFlag', crudFlag) if crudFlag? and crudFlag != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    node_id = $(xml).attr('node_id')
    obj.set('node_id', Number(node_id)) if node_id? and node_id != ""
    start_time = $(xml).attr('start_time')
    obj.set('start_time', Number(start_time)) if start_time? and start_time != ""
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt)) if dt? and dt != ""
    network_id = $(xml).attr('network_id')
    obj.set('network_id', Number(network_id)) if network_id? and network_id != ""
    destination_network_id = $(xml).attr('destination_network_id')
    obj.set('destination_network_id', Number(destination_network_id)) if destination_network_id? and destination_network_id != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('splitRatioProfile')
    if @encode_references
      @encode_references()
    _.each(@get('splitratio') || [], (a_splitratio) -> xml.appendChild(a_splitratio.to_xml(doc)))
    xml.setAttribute('crudFlag', @get('crudFlag')) if @has('crudFlag')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('node_id', @get('node_id')) if @has('node_id')
    if @has('start_time') && @start_time != 0 then xml.setAttribute('start_time', @get('start_time'))
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml.setAttribute('network_id', @get('network_id')) if @has('network_id')
    xml.setAttribute('destination_network_id', @get('destination_network_id')) if @has('destination_network_id')
    if @has('mod_stamp') && @mod_stamp != "0" then xml.setAttribute('mod_stamp', @get('mod_stamp'))
    xml
  
  deep_copy: -> SplitRatioProfile.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null