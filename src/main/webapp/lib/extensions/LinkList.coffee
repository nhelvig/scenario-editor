window.beats.LinkList::defaults =
  link: []
  
window.beats.LinkList::initialize = ->
  @set 'link', [] if link?

# we need to remove the links that are deleted before saving to xml and then
# put them in the link list so the database can be updated correctly
window.beats.LinkList::old_to_xml = window.beats.LinkList::to_xml 
window.beats.LinkList::to_xml = (doc) ->
  filter = ((link) => link.crud() == window.beats.CrudFlag.DELETE)
  deletedLinks = _.filter(@get('link'), filter)
  keepLinks = _.reject(@get('link'), filter)
  @set 'link', keepLinks
  xml = @old_to_xml(doc)
  @set('link', @get('link').concat(deletedLinks))
  xml
  