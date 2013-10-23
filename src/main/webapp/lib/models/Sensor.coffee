class window.beats.Sensor extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Sensor()
    display_position = xml.children('display_position')
    obj.set('display_position', $a.DisplayPosition.from_xml2(display_position, deferred, object_with_id)) if display_position? and display_position != ""
    parameters = xml.children('parameters')
    obj.set('parameters', _.reduce(parameters.find("parameter"),
          (acc,par_xml) ->
            wrapped_xml = $(par_xml);
            acc[wrapped_xml.attr('name')] = wrapped_xml.attr('value')
            acc
          {}
    )) if parameters? and parameters != ""
    table = xml.children('table')
    obj.set('table', $a.Table.from_xml2(table, deferred, object_with_id)) if table? and table != ""
    sensor_type = xml.children('sensor_type')
    obj.set('sensor_type', $a.SensorType.from_xml2(sensor_type, deferred, object_with_id)) if sensor_type? and sensor_type != ""
    crudFlag = $(xml).attr('crudFlag')
    obj.set('crudFlag', crudFlag) if crudFlag? and crudFlag != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    link_position = $(xml).attr('link_position')
    obj.set('link_position', Number(link_position)) if link_position? and link_position != ""
    link_id = $(xml).attr('link_id')
    obj.set('link_id', Number(link_id)) if link_id? and link_id != ""
    java_class = $(xml).attr('java_class')
    obj.set('java_class', java_class) if java_class? and java_class != ""
    sensor_id_original = $(xml).attr('sensor_id_original')
    obj.set('sensor_id_original', sensor_id_original) if sensor_id_original? and sensor_id_original != ""
    link_type_original = $(xml).attr('link_type_original')
    obj.set('link_type_original', link_type_original) if link_type_original? and link_type_original != ""
    data_feed_id = $(xml).attr('data_feed_id')
    obj.set('data_feed_id', Number(data_feed_id)) if data_feed_id? and data_feed_id != ""
    lane_number = $(xml).attr('lane_number')
    obj.set('lane_number', Number(lane_number)) if lane_number? and lane_number != ""
    link_offset = $(xml).attr('link_offset')
    obj.set('link_offset', Number(link_offset)) if link_offset? and link_offset != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    health_status = $(xml).attr('health_status')
    obj.set('health_status', Number(health_status)) if health_status? and health_status != ""
    if object_with_id.sensor
      object_with_id.sensor[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('sensor')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('display_position').to_xml(doc)) if @has('display_position')
    if @has('parameters')
      parameters_xml = doc.createElement('parameters')
      _.each(@get('parameters'), (par_val, par_name) ->
          parameter_xml = doc.createElement('parameter')
          parameter_xml.setAttribute('name',par_name)
          parameter_xml.setAttribute('value', par_val)
          parameters_xml.appendChild(parameter_xml)
      )
      xml.appendChild(parameters_xml)
    
    xml.appendChild(@get('table').to_xml(doc)) if @has('table')
    xml.appendChild(@get('sensor_type').to_xml(doc)) if @has('sensor_type')
    xml.setAttribute('crudFlag', @get('crudFlag')) if @has('crudFlag')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('link_position', @get('link_position')) if @has('link_position')
    xml.setAttribute('link_id', @get('link_id')) if @has('link_id')
    xml.setAttribute('java_class', @get('java_class')) if @has('java_class')
    xml.setAttribute('sensor_id_original', @get('sensor_id_original')) if @has('sensor_id_original')
    xml.setAttribute('link_type_original', @get('link_type_original')) if @has('link_type_original')
    xml.setAttribute('data_feed_id', @get('data_feed_id')) if @has('data_feed_id')
    xml.setAttribute('lane_number', @get('lane_number')) if @has('lane_number')
    xml.setAttribute('link_offset', @get('link_offset')) if @has('link_offset')
    xml.setAttribute('mod_stamp', @get('mod_stamp')) if @has('mod_stamp')
    xml.setAttribute('health_status', @get('health_status')) if @has('health_status')
    xml
  
  deep_copy: -> Sensor.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null