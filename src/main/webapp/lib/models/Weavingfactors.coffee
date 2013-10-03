class window.beats.Weavingfactors extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Weavingfactors()
    vehicle_type_id = $(xml).attr('vehicle_type_id')
    obj.set('vehicle_type_id', Number(vehicle_type_id)) if vehicle_type_id? and vehicle_type_id != ""
    link_in = $(xml).attr('link_in')
    obj.set('link_in', Number(link_in)) if link_in? and link_in != ""
    link_out = $(xml).attr('link_out')
    obj.set('link_out', Number(link_out)) if link_out? and link_out != ""
    obj.set('text', xml.text())
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('weavingfactors')
    if @encode_references
      @encode_references()
    xml.setAttribute('vehicle_type_id', @get('vehicle_type_id')) if @has('vehicle_type_id')
    xml.setAttribute('link_in', @get('link_in')) if @has('link_in')
    xml.setAttribute('link_out', @get('link_out')) if @has('link_out')
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Weavingfactors.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null