window.beats.NodeList::defaults =
  node: []
  
window.beats.NodeList::initialize = ->
  @set 'node', []
  
# we need to remove the nodes that are deleted before saving to xml and then
# put them back in the node list so the database can be updated correctly
window.beats.NodeList::old_to_xml = window.beats.NodeList::to_xml 
window.beats.NodeList::to_xml = (doc) ->
  xml = ''
  # If we are converting to xml to be saved to file remove all deleted elements from list
  if window.beats? and window.beats.fileSaveMode
    filter = ((node) => node.crud() == window.beats.CrudFlag.DELETE)
    deletedNodes = _.filter(@get('node'), filter)
    keepNodes = _.reject(@get('node'), filter)
    @set 'node', keepNodes
    xml = @old_to_xml(doc)
    @set('node', @get('node').concat(deletedNodes))
    # Otherwise we are converting to xml to goto the database, so keep delete CRUDFlag
  else
    xml = @old_to_xml(doc)
  xml