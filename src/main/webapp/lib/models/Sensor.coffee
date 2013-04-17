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
    obj.set('display_position', $a.Display_position.from_xml2(display_position, deferred, object_with_id))
    link_reference = xml.children('link_reference')
    obj.set('link_reference', $a.Link_reference.from_xml2(link_reference, deferred, object_with_id))
    parameters = xml.children('parameters')
    obj.set('parameters', _.reduce(parameters.find("parameter"),
          (acc,par_xml) ->
            wrapped_xml = $(par_xml);
            acc[wrapped_xml.attr('name')] = wrapped_xml.attr('value')
            acc
          {}
    ))
    table = xml.children('table')
    obj.set('table', $a.Table.from_xml2(table, deferred, object_with_id))
    id = $(xml).attr('id')
    obj.set('id', id)
    link_position = $(xml).attr('link_position')
    obj.set('link_position', Number(link_position))
    type = $(xml).attr('type')
    obj.set('type', type)
    sensor_id_original = $(xml).attr('sensor_id_original')
    obj.set('sensor_id_original', sensor_id_original)
    lane_number = $(xml).attr('lane_number')
    obj.set('lane_number', Number(lane_number))
    health_status = $(xml).attr('health_status')
    obj.set('health_status', Number(health_status))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('sensor')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('display_position').to_xml(doc)) if @has('display_position')
    xml.appendChild(@get('link_reference').to_xml(doc)) if @has('link_reference')
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
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('link_position', @get('link_position')) if @has('link_position')
    xml.setAttribute('type', @get('type')) if @has('type')
    xml.setAttribute('sensor_id_original', @get('sensor_id_original')) if @has('sensor_id_original')
    xml.setAttribute('lane_number', @get('lane_number')) if @has('lane_number')
    xml.setAttribute('health_status', @get('health_status')) if @has('health_status')
    xml
  
  deep_copy: -> Sensor.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null