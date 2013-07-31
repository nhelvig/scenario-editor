class window.beats.DemandProfile extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.DemandProfile()
    demand = xml.children('demand')
    obj.set('demand', _.map($(demand), (demand_i) -> $a.Demand.from_xml2($(demand_i), deferred, object_with_id))) if demand? and demand != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    crudFlag = $(xml).attr('crudFlag')
    obj.set('crudFlag', crudFlag) if crudFlag? and crudFlag != ""
    knob = $(xml).attr('knob')
    obj.set('knob', Number(knob)) if knob? and knob != ""
    start_time = $(xml).attr('start_time')
    obj.set('start_time', Number(start_time)) if start_time? and start_time != ""
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt)) if dt? and dt != ""
    link_id_org = $(xml).attr('link_id_org')
    obj.set('link_id_org', Number(link_id_org)) if link_id_org? and link_id_org != ""
    destination_network_id = $(xml).attr('destination_network_id')
    obj.set('destination_network_id', Number(destination_network_id)) if destination_network_id? and destination_network_id != ""
    std_dev_add = $(xml).attr('std_dev_add')
    obj.set('std_dev_add', Number(std_dev_add)) if std_dev_add? and std_dev_add != ""
    std_dev_mult = $(xml).attr('std_dev_mult')
    obj.set('std_dev_mult', Number(std_dev_mult)) if std_dev_mult? and std_dev_mult != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('demandProfile')
    if @encode_references
      @encode_references()
    _.each(@get('demand') || [], (a_demand) -> xml.appendChild(a_demand.to_xml(doc)))
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('crudFlag', @get('crudFlag')) if @has('crudFlag')
    if @has('knob') && @knob != 1 then xml.setAttribute('knob', @get('knob'))
    if @has('start_time') && @start_time != 0 then xml.setAttribute('start_time', @get('start_time'))
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml.setAttribute('link_id_org', @get('link_id_org')) if @has('link_id_org')
    xml.setAttribute('destination_network_id', @get('destination_network_id')) if @has('destination_network_id')
    xml.setAttribute('std_dev_add', @get('std_dev_add')) if @has('std_dev_add')
    xml.setAttribute('std_dev_mult', @get('std_dev_mult')) if @has('std_dev_mult')
    xml.setAttribute('mod_stamp', @get('mod_stamp')) if @has('mod_stamp')
    xml
  
  deep_copy: -> DemandProfile.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null