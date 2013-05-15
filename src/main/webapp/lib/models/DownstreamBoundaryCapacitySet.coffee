class window.beats.DownstreamBoundaryCapacitySet extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.DownstreamBoundaryCapacitySet()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    downstreamBoundaryCapacityProfile = xml.children('downstreamBoundaryCapacityProfile')
    obj.set('downstreamboundarycapacityprofile', _.map($(downstreamBoundaryCapacityProfile), (downstreamBoundaryCapacityProfile_i) -> $a.DownstreamBoundaryCapacityProfile.from_xml2($(downstreamBoundaryCapacityProfile_i), deferred, object_with_id)))
    project_id = $(xml).attr('project_id')
    obj.set('project_id', Number(project_id))
    id = $(xml).attr('id')
    obj.set('id', Number(id))
    name = $(xml).attr('name')
    obj.set('name', name)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('DownstreamBoundaryCapacitySet')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    _.each(@get('downstreamboundarycapacityprofile') || [], (a_downstreamboundarycapacityprofile) -> xml.appendChild(a_downstreamboundarycapacityprofile.to_xml(doc)))
    if @has('project_id') && @project_id != 0 then xml.setAttribute('project_id', @get('project_id'))
    xml.setAttribute('id', @get('id')) if @has('id')
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    xml
  
  deep_copy: -> DownstreamBoundaryCapacitySet.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null