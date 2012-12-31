window.beats.LinkList::defaults =
  link: []
  
window.beats.LinkList::initialize = ->
  @set 'link', [] if link?
  