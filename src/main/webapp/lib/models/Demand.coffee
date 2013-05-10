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
    crudFlag = xml.children('crudFlag')
    obj.set('crudflag', $a.CrudFlag.from_xml2(crudFlag, deferred, object_with_id))
    id = $(xml).attr('id')
    obj.set('id', Number(id))
    content = $(xml).attr('content')
    obj.set('content', content)
    demandProfile_id = $(xml).attr('demandProfile_id')
    obj.set('demandProfile_id', Number(demandProfile_id))
    vehicleType_id = $(xml).attr('vehicleType_id')
    obj.set('vehicleType_id', Number(vehicleType_id))
    demand_order = $(xml).attr('demand_order')
    obj.set('demand_order', Number(demand_order))
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('demand')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('crudflag').to_xml(doc)) if @has('crudflag')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('content', @get('content')) if @has('content')
    xml.setAttribute('demandProfile_id', @get('demandProfile_id')) if @has('demandProfile_id')
    xml.setAttribute('vehicleType_id', @get('vehicleType_id')) if @has('vehicleType_id')
    xml.setAttribute('demand_order', @get('demand_order')) if @has('demand_order')
    if @has('mod_stamp') && @mod_stamp != "0" then xml.setAttribute('mod_stamp', @get('mod_stamp'))
    xml
  
  deep_copy: -> Demand.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null