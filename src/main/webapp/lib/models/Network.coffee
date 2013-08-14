class window.beats.Network extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Network()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id)) if description? and description != ""
    NodeList = xml.children('NodeList')
    obj.set('nodelist', $a.NodeList.from_xml2(NodeList, deferred, object_with_id)) if NodeList? and NodeList != ""
    LinkList = xml.children('LinkList')
    obj.set('linklist', $a.LinkList.from_xml2(LinkList, deferred, object_with_id)) if LinkList? and LinkList != ""
    position = xml.children('position')
    obj.set('position', $a.Position.from_xml2(position, deferred, object_with_id)) if position? and position != ""
    name = $(xml).attr('name')
    obj.set('name', name) if name? and name != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp) if mod_stamp? and mod_stamp != ""
    lockedForEdit = $(xml).attr('lockedForEdit')
    obj.set('lockedForEdit', (lockedForEdit.toString().toLowerCase() == 'true') if lockedForEdit?) if lockedForEdit? and lockedForEdit != ""
    lockedForHistory = $(xml).attr('lockedForHistory')
    obj.set('lockedForHistory', (lockedForHistory.toString().toLowerCase() == 'true') if lockedForHistory?) if lockedForHistory? and lockedForHistory != ""
    if object_with_id.network
      object_with_id.network[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('network')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    xml.appendChild(@get('nodelist').to_xml(doc)) if @has('nodelist')
    xml.appendChild(@get('linklist').to_xml(doc)) if @has('linklist')
    xml.appendChild(@get('position').to_xml(doc)) if @has('position')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('mod_stamp', @get('mod_stamp')) if @has('mod_stamp')
    if @has('lockedForEdit') && @lockedForEdit != false then xml.setAttribute('lockedForEdit', @get('lockedForEdit'))
    if @has('lockedForHistory') && @lockedForHistory != false then xml.setAttribute('lockedForHistory', @get('lockedForHistory'))
    xml
  
  deep_copy: -> Network.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null