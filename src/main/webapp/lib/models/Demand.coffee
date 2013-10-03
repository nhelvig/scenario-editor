class window.beats.Demand extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Demand()
    vehicle_type_id = $(xml).attr('vehicle_type_id')
    obj.set('vehicle_type_id', Number(vehicle_type_id)) if vehicle_type_id? and vehicle_type_id != ""
    ids = $(xml).attr('ids')
    obj.set('ids', ids) if ids? and ids != ""
    crudFlags = $(xml).attr('crudFlags')
    obj.set('crudFlags', crudFlags) if crudFlags? and crudFlags != ""
    mod_stamps = $(xml).attr('mod_stamps')
    obj.set('mod_stamps', mod_stamps) if mod_stamps? and mod_stamps != ""
    obj.set('text', xml.text())
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('demand')
    if @encode_references
      @encode_references()
    xml.setAttribute('vehicle_type_id', @get('vehicle_type_id')) if @has('vehicle_type_id')
    xml.setAttribute('ids', @get('ids')) if @has('ids')
    xml.setAttribute('crudFlags', @get('crudFlags')) if @has('crudFlags')
    xml.setAttribute('mod_stamps', @get('mod_stamps')) if @has('mod_stamps')
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Demand.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null