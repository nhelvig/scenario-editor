class window.aurora.Event extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Event()
    demand = xml.find('demand')
    obj.set 'demand', $a.Demand.from_xml2(demand, deferred, object_with_id)
    description = xml.find('description')
    obj.set 'description', $a.Description.from_xml2(description, deferred, object_with_id)
    fd = xml.find('fd')
    obj.set 'fd', $a.Fd.from_xml2(fd, deferred, object_with_id)
    srm = xml.find('srm')
    obj.set 'srm', $a.Srm.from_xml2(srm, deferred, object_with_id)
    qmax = xml.find('qmax')
    obj.set 'qmax', $a.Qmax.from_xml2(qmax, deferred, object_with_id)
    lkid = xml.find('lkid')
    obj.set 'lkid', $a.Lkid.from_xml2(lkid, deferred, object_with_id)
    controller = xml.find('controller')
    obj.set 'controller', $a.Controller.from_xml2(controller, deferred, object_with_id)
    wfm = xml.find('wfm')
    obj.set 'wfm', $a.Wfm.from_xml2(wfm, deferred, object_with_id)
    control = xml.find('control')
    obj.set 'control', $a.Control.from_xml2(control, deferred, object_with_id)
    lane_count_change = xml.find('lane_count_change')
    obj.set 'lane_count_change', $a.Lane_count_change.from_xml2(lane_count_change, deferred, object_with_id)
    display_position = xml.find('display_position')
    obj.set 'display_position', $a.Display_position.from_xml2(display_position, deferred, object_with_id)
    tstamp = xml.find('tstamp')
    obj.set 'tstamp', Number(tstamp)
    node_id = xml.find('node_id')
    obj.set 'node_id', (node_id.length() == 0 ? "" : node_id)
    link_id = xml.find('link_id')
    obj.set 'link_id', (link_id.length() == 0 ? "" : link_id)
    network_id = xml.find('network_id')
    obj.set 'network_id', (network_id.length() == 0 ? "" : network_id)
    enabled = xml.find('enabled')
    obj.set 'enabled', (enabled.toString().toLowerCase() == 'true')
    type = xml.find('type')
    obj.set 'type', xml.type
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('event')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('demand').to_xml()) if @has('demand')
    xml.appendChild(@get('description').to_xml()) if @has('description')
    xml.appendChild(@get('fd').to_xml()) if @has('fd')
    xml.appendChild(@get('srm').to_xml()) if @has('srm')
    xml.appendChild(@get('qmax').to_xml()) if @has('qmax')
    xml.appendChild(@get('lkid').to_xml()) if @has('lkid')
    xml.appendChild(@get('controller').to_xml()) if @has('controller')
    xml.appendChild(@get('wfm').to_xml()) if @has('wfm')
    xml.appendChild(@get('control').to_xml()) if @has('control')
    xml.appendChild(@get('lane_count_change').to_xml()) if @has('lane_count_change')
    xml.appendChild(@get('display_position').to_xml()) if @has('display_position')
    xml.setAttribute('tstamp', @get('tstamp'))
    if @has('node_id') && @node_id != "" then xml.setAttribute('node_id', @get('node_id'))
    if @has('link_id') && @link_id != "" then xml.setAttribute('link_id', @get('link_id'))
    if @has('network_id') && @network_id != "" then xml.setAttribute('network_id', @get('network_id'))
    xml.setAttribute('enabled', @get('enabled'))
    xml.setAttribute('type', @get('type'))
    xml
  
  deep_copy: -> Event.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null