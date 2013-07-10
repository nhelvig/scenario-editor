window.beats.LinkList::defaults =
  link: []
  
window.beats.LinkList::initialize = ->
  @set 'link', []

# we need to remove the links that are deleted before saving to xml and then
# put them in the link list so the database can be updated correctly
window.beats.LinkList::old_to_xml = window.beats.LinkList::to_xml 
window.beats.LinkList::to_xml = (doc) ->
  xml = ''
  # If we are converting to xml to be saved to file remove all deleted elements from list
  if window.beats? and window.beats.fileSaveMode
    filter = ((link) => link.crud() == window.beats.CrudFlag.DELETE)
    deletedLinks = _.filter(@get('link'), filter)
    keepLinks = _.reject(@get('link'), filter)
    @set 'link', keepLinks
    xml = @old_to_xml(doc)
    @set('link', @get('link').concat(deletedLinks))
  # Otherwise we are converting to xml to goto the database, so keep delete CRUDFlag
  else
    xml = @old_to_xml(doc)
  xml
  