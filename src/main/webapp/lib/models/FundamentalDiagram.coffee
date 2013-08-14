class window.beats.FundamentalDiagram extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.FundamentalDiagram()
    crudFlag = $(xml).attr('crudFlag')
    obj.set('crudFlag', crudFlag) if crudFlag? and crudFlag != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    order = $(xml).attr('order')
    obj.set('order', Number(order)) if order? and order != ""
    capacity = $(xml).attr('capacity')
    obj.set('capacity', Number(capacity)) if capacity? and capacity != ""
    capacity_drop = $(xml).attr('capacity_drop')
    obj.set('capacity_drop', Number(capacity_drop)) if capacity_drop? and capacity_drop != ""
    std_dev_capacity = $(xml).attr('std_dev_capacity')
    obj.set('std_dev_capacity', Number(std_dev_capacity)) if std_dev_capacity? and std_dev_capacity != ""
    free_flow_speed = $(xml).attr('free_flow_speed')
    obj.set('free_flow_speed', Number(free_flow_speed)) if free_flow_speed? and free_flow_speed != ""
    congestion_speed = $(xml).attr('congestion_speed')
    obj.set('congestion_speed', Number(congestion_speed)) if congestion_speed? and congestion_speed != ""
    critical_speed = $(xml).attr('critical_speed')
    obj.set('critical_speed', Number(critical_speed)) if critical_speed? and critical_speed != ""
    std_dev_free_flow_speed = $(xml).attr('std_dev_free_flow_speed')
    obj.set('std_dev_free_flow_speed', Number(std_dev_free_flow_speed)) if std_dev_free_flow_speed? and std_dev_free_flow_speed != ""
    std_dev_congestion_speed = $(xml).attr('std_dev_congestion_speed')
    obj.set('std_dev_congestion_speed', Number(std_dev_congestion_speed)) if std_dev_congestion_speed? and std_dev_congestion_speed != ""
    jam_density = $(xml).attr('jam_density')
    obj.set('jam_density', Number(jam_density)) if jam_density? and jam_density != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('fundamentalDiagram')
    if @encode_references
      @encode_references()
    xml.setAttribute('crudFlag', @get('crudFlag')) if @has('crudFlag')
    xml.setAttribute('id', @get('id')) if @has('id')
    if @has('mod_stamp') && @mod_stamp != "0" then xml.setAttribute('mod_stamp', @get('mod_stamp'))
    xml.setAttribute('order', @get('order')) if @has('order')
    xml.setAttribute('capacity', @get('capacity')) if @has('capacity')
    if @has('capacity_drop') && @capacity_drop != 0.0 then xml.setAttribute('capacity_drop', @get('capacity_drop'))
    xml.setAttribute('std_dev_capacity', @get('std_dev_capacity')) if @has('std_dev_capacity')
    xml.setAttribute('free_flow_speed', @get('free_flow_speed')) if @has('free_flow_speed')
    xml.setAttribute('congestion_speed', @get('congestion_speed')) if @has('congestion_speed')
    xml.setAttribute('critical_speed', @get('critical_speed')) if @has('critical_speed')
    xml.setAttribute('std_dev_free_flow_speed', @get('std_dev_free_flow_speed')) if @has('std_dev_free_flow_speed')
    xml.setAttribute('std_dev_congestion_speed', @get('std_dev_congestion_speed')) if @has('std_dev_congestion_speed')
    xml.setAttribute('jam_density', @get('jam_density')) if @has('jam_density')
    xml
  
  deep_copy: -> FundamentalDiagram.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null