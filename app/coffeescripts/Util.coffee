# A class of static methods used to store general functions used by 
# many classes.
class window.sirius.Util
  @_round_dec: (num,dec) ->
    Math.round(num * Math.pow(10,dec)) / Math.pow(10,dec)

  @_getLat: (elem) ->
    if elem.get('position')?
      lat = elem.get('position').get('point')[0].get('lat')
    if elem.get('display_position')
      lat = elem.get('display_position').get('point')[0].get('lat')
    lat 

  @_getLng: (elem) ->
    if elem.get('position')?
      lng = elem.get('position').get('point')[0].get('lng')
    if elem.get('display_position')
      lng = elem.get('display_position').get('point')[0].get('lng')
    lng

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