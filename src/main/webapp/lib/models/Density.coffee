class window.beats.Density extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Density()
    vehicle_type_id = $(xml).attr('vehicle_type_id')
    obj.set('vehicle_type_id', Number(vehicle_type_id)) if vehicle_type_id? and vehicle_type_id != ""
    crudFlag = $(xml).attr('crudFlag')
    obj.set('crudFlag', crudFlag) if crudFlag? and crudFlag != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    link_id = $(xml).attr('link_id')
    obj.set('link_id', Number(link_id)) if link_id? and link_id != ""
    destination_network_id = $(xml).attr('destination_network_id')
    obj.set('destination_network_id', Number(destination_network_id)) if destination_network_id? and destination_network_id != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    obj.set('text', xml.text())
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('density')
    if @encode_references
      @encode_references()
    xml.setAttribute('vehicle_type_id', @get('vehicle_type_id')) if @has('vehicle_type_id')
    xml.setAttribute('crudFlag', @get('crudFlag')) if @has('crudFlag')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('link_id', @get('link_id')) if @has('link_id')
    xml.setAttribute('destination_network_id', @get('destination_network_id')) if @has('destination_network_id')
    xml.setAttribute('mod_stamp', @get('mod_stamp')) if @has('mod_stamp')
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Density.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null