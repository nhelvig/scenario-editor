class window.beats.FundamentalDiagramProfile extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.FundamentalDiagramProfile()
    fundamentalDiagram = xml.children('fundamentalDiagram')
    obj.set('fundamentaldiagram', _.map($(fundamentalDiagram), (fundamentalDiagram_i) -> $a.FundamentalDiagram.from_xml2($(fundamentalDiagram_i), deferred, object_with_id))) if fundamentalDiagram? and fundamentalDiagram != ""
    fundamentalDiagramType = xml.children('fundamentalDiagramType')
    obj.set('fundamentaldiagramtype', $a.FundamentalDiagramType.from_xml2(fundamentalDiagramType, deferred, object_with_id)) if fundamentalDiagramType? and fundamentalDiagramType != ""
    calibrationAlgorithmType = xml.children('calibrationAlgorithmType')
    obj.set('calibrationalgorithmtype', $a.CalibrationAlgorithmType.from_xml2(calibrationAlgorithmType, deferred, object_with_id)) if calibrationAlgorithmType? and calibrationAlgorithmType != ""
    crudFlag = $(xml).attr('crudFlag')
    obj.set('crudFlag', crudFlag) if crudFlag? and crudFlag != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    link_id = $(xml).attr('link_id')
    obj.set('link_id', Number(link_id)) if link_id? and link_id != ""
    sensor_id = $(xml).attr('sensor_id')
    obj.set('sensor_id', Number(sensor_id)) if sensor_id? and sensor_id != ""
    start_time = $(xml).attr('start_time')
    obj.set('start_time', Number(start_time)) if start_time? and start_time != ""
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt)) if dt? and dt != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    agg_run_id = $(xml).attr('agg_run_id')
    obj.set('agg_run_id', Number(agg_run_id)) if agg_run_id? and agg_run_id != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('fundamentalDiagramProfile')
    if @encode_references
      @encode_references()
    _.each(@get('fundamentaldiagram') || [], (a_fundamentaldiagram) -> xml.appendChild(a_fundamentaldiagram.to_xml(doc)))
    xml.appendChild(@get('fundamentaldiagramtype').to_xml(doc)) if @has('fundamentaldiagramtype')
    xml.appendChild(@get('calibrationalgorithmtype').to_xml(doc)) if @has('calibrationalgorithmtype')
    xml.setAttribute('crudFlag', @get('crudFlag')) if @has('crudFlag')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('link_id', @get('link_id')) if @has('link_id')
    xml.setAttribute('sensor_id', @get('sensor_id')) if @has('sensor_id')
    if @has('start_time') && @start_time != 0 then xml.setAttribute('start_time', @get('start_time'))
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    if @has('mod_stamp') && @mod_stamp != "0" then xml.setAttribute('mod_stamp', @get('mod_stamp'))
    xml.setAttribute('agg_run_id', @get('agg_run_id')) if @has('agg_run_id')
    xml
  
  deep_copy: -> FundamentalDiagramProfile.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null