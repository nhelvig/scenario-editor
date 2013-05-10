class window.beats.Splitratio extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Splitratio()
    crudFlag = $(xml).attr('crudFlag')
    obj.set('crudFlag', crudFlag)
    id = $(xml).attr('id')
    obj.set('id', Number(id))
    link_in = $(xml).attr('link_in')
    obj.set('link_in', Number(link_in))
    link_out = $(xml).attr('link_out')
    obj.set('link_out', Number(link_out))
    vehicleType_id = $(xml).attr('vehicleType_id')
    obj.set('vehicleType_id', Number(vehicleType_id))
    ratio_order = $(xml).attr('ratio_order')
    obj.set('ratio_order', Number(ratio_order))
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp)
    obj.set('text', xml.text())
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('splitratio')
    if @encode_references
      @encode_references()
    xml.setAttribute('crudFlag', @get('crudFlag')) if @has('crudFlag')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('link_in', @get('link_in')) if @has('link_in')
    xml.setAttribute('link_out', @get('link_out')) if @has('link_out')
    xml.setAttribute('vehicleType_id', @get('vehicleType_id')) if @has('vehicleType_id')
    xml.setAttribute('ratio_order', @get('ratio_order')) if @has('ratio_order')
    if @has('mod_stamp') && @mod_stamp != "0" then xml.setAttribute('mod_stamp', @get('mod_stamp'))
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Splitratio.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null