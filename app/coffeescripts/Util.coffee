# A class of static methods used to store general functions used by 
# many classes.
class window.sirius.Util
  @_round_dec: (num,dec) ->
    Math.round(num * Math.pow(10,dec)) / Math.pow(10,dec)

  @_getLat: (elem) ->
    @_getElementLatOrLng(elem, 'lat')

  @_getLng: (elem) ->
    @_getElementLatOrLng(elem, 'lng')
  
  # called by getLat and getLng to first get the position and point attribute
  # (this can be complicated depending on the type of element, some store
  # as display_position and some store as position). In some cases, there
  # is no position specified in this case we get the position of the node
  # or the links begin node that it is associated with.
  @_getElementLatOrLng: (elem, type) ->
    if elem.get('position')?
      pos = elem.get('position')
    else if elem.get('display_position')?
      pos = elem.get('display_position')
    else if elem.get('node')?
      pos = elem.get('node').get('position')
      @_offsetPosition(pos) # offset just to left of the node
    else if elem.get('link')?
      pos = elem.get('link').get('begin').get('node').get('position')
      @_offsetPosition(pos) # offset just to left of the link's begin node
       
    pos.get('point')[0].get(type)
  
  # used to move the symbol just off to the left of the node
  @_offsetPosition: (pos) ->
    pos.get('point')[0].set({'lng' : pos.get('point')[0].get('lng') - .0002})

  # returns a google LatLng obect by retrieving the latitude and longitude 
  # from the elements object. In some cases it is stored in position and
  # in others in display_position.
  @getLatLng: (elem) ->
    if @_getLng(elem)? && @_getLat(elem)?
      roundLat = @_round_dec(@_getLat(elem),4)
      roundLng = @_round_dec(@_getLng(elem),4)
      new google.maps.LatLng(roundLat, roundLng) 
    else 
      null
  
  # This method is used by View classes to create id names that are all
  # lowercased and have dashes for spaces
  @toLowerCaseAndDashed: (text) ->
    text.toLowerCase().replace(/\ /g,"-")

  # takes elem (eg. 'node','signal', 'link') and capitalizes
  # the first letter, lower cases the rest and will handle multiple words 
  # if needed. It is used to create the title for dialog box  
  @toStandardCasing: (elem) ->
    formattedWord = []
    for word in elem.split /\s+/
      formattedWord.push word[0].toUpperCase() + word[1..].toLowerCase() 
    formattedWord.join ' '
  
  # creates a copy of of item array. The items array is a list menu
  # items for context menus.
  @copy: (items) ->
    temp = []
    _.each(items, (item) =>
      temp.push {
        label: item.label
        className: item.className
        event: item.event
      }
    )
    temp
  
  # This makes an ajax call to the server in order to write the model's xml
  # file and download it back to the user. Call From "Save Local Network" 
  # menu item
  @writeAndDownloadXML: (attrs) ->
    xhReq = new XMLHttpRequest()
    xhReq.open("post", attrs.serverWrite, false)
    xhReq.setRequestHeader('Content-Type',"text/xml")
    xhReq.onload = (() -> 
      elemIF = document.createElement("iframe")
      elemIF.id = "download-iframe"
      elemIF.src = attrs.serverDownload
      elemIF.style.display = "none"
      $('body').append(elemIF)
      )
    xhReq.send(new XMLSerializer().serializeToString(attrs.xml))