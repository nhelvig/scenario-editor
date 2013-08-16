class window.beats.VehicleTypeSet extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.VehicleTypeSet()
    vehicleType = xml.children('vehicleType')
    obj.set('vehicletype', _.map($(vehicleType), (vehicleType_i) -> $a.VehicleType.from_xml2($(vehicleType_i), deferred, object_with_id))) if vehicleType? and vehicleType != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    project_id = $(xml).attr('project_id')
    obj.set('project_id', Number(project_id)) if project_id? and project_id != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('VehicleTypeSet')
    if @encode_references
      @encode_references()
    _.each(@get('vehicletype') || [], (a_vehicletype) -> xml.appendChild(a_vehicletype.to_xml(doc)))
    xml.setAttribute('id', @get('id')) if @has('id')
    if @has('project_id') && @project_id != 0 then xml.setAttribute('project_id', @get('project_id'))
    xml
  
  deep_copy: -> VehicleTypeSet.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null