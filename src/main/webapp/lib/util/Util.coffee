# A class of static methods used to store general functions used by
# many classes.
$a = window.beats

window.beats.Util =
  
  # Constants for Unit Names
  UNITS_US: 'US'
  UNITS_METRIC: 'Metric'
  UNITS_SI: 'SI'

  _round_dec: (num,dec) ->
    Math.round(num * Math.pow(10,dec)) / Math.pow(10,dec)

  _getLat: (elem) ->
    @_getElementLatOrLng(elem, 'lat')

  _getLng: (elem) ->
    @_getElementLatOrLng(elem, 'lng')

  _getElementLatOrLng: (elem, type) ->
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

  # returns a google LatLng obect by retrieving the latitude and longitude
  # from the elements object. In some cases it is stored in position and in
  # others in display_position.
  getLatLng: (elem) ->
    if @_getLng(elem)? && @_getLat(elem)?
      roundLat = @_round_dec(@_getLat(elem),4)
      roundLng = @_round_dec(@_getLng(elem),4)
      new google.maps.LatLng(roundLat, roundLng)
    else
      null

  # This method is used by View classes to create id names that are all
  # lowercased and have dashes for spaces
  toLowerCaseAndDashed: (text) ->
    text.toLowerCase().replace(/\ /g,"-")

  toStandardCasing: (elem) ->
    formattedWord = []
    for word in elem.split /\s+/
      formattedWord.push word[0].toUpperCase() + word[1..].toLowerCase()
    formattedWord.join ' '

  # This method is used to grab the model elements from object model by id.
  # The list is the list you want to iterate over and the id is what you want
  # to find
  getElement: (id, list) ->
    _.find(list, (elem) ->  elem.get('id') == id)
  
  # if there is no position specified and the elem is trying to use the
  # link or node it is attached too to find a position, we then move the
  # event, controller, signal or sensor slightly to the left
  _offsetPosition: (pos) ->
    pos.get('point')[0].set(lng: pos.get('point')[0].get('lng') - .0002)

  # creates a copy of of item array. The items array is a list menu items for 
  # context menus.
  copy: (items) ->
    _.map items, (item) =>
      label: item.label
      className: item.className
      event: item.event

  # This makes an ajax call to the server in order to write the model's xml 
  # file and download it back to the user. Call From "Save Local Network" menu 
  # item
  writeAndDownloadXML: (attrs) ->
    servletPath = "../ScenarioDownload.do"
    xhReq = new XMLHttpRequest()
    xhReq.open("post", servletPath, false)
    xhReq.setRequestHeader('Content-Type',"text/xml")
    xhReq.onload = ->
      elemIF = document.createElement("iframe")
      elemIF.id = "download-iframe"
      elemIF.src =servletPath
      elemIF.style.display = "none"
      $('body').append(elemIF)
    xhReq.send(new XMLSerializer().serializeToString(attrs.xml))
  
  # this takes seconds and returns an array hold the extracted hours,
  # minutes, seconds
  convertSecondsToHoursMinSec: (secs) ->
    # extract hours
    hours = Math.floor(secs / (3600));
 
    # extract minutes
    divisorMinutes = secs % (3600);
    minutes = Math.floor(divisorMinutes / 60);
 
    # extract the remaining seconds
    divisorSeconds = divisorMinutes % 60;
    seconds = Math.ceil(divisorSeconds);
 
    # return the final array
    {
      "h": hours
      "m": minutes
      "s": seconds
    }
  
  # this takes an array of hours, minutes, seconds and converts to seconds
  convertToSeconds: (hms) ->
    seconds = hms['h'] * 3600
    seconds += hms['m'] * 60
    seconds += hms['s'] * 1
    seconds

  # Used to convert meters to km, since google API call only returns SI units
  # Eventually conversions should be done elsewhere (server or DB)
  convertSIToKilometers: (meters) ->
    ret = meters/1000
    ret

  # Used to convert meters to miles, since google API call only returns SI units
  # Eventually conversions should be done elsewhere (server or DB)
  convertSIToMiles: (meters) ->
    ret = meters/1609.34
    ret

  # this method retrieves the geometry from the any model
  getGeometry: (opts) ->
    _.map(opts.models, (m) -> 
                  m.get('position').get('point')[0].get(opts.geom)).join(", ")
  
  
  # this returns a new id that is not taken from the collection passed in
  getNewElemId: (collection) ->
    newId = 1
    while(true)
      test = _.filter(collection, (elem) -> elem.ident() is newId)
      if test?.length == 0
        return newId
      newId++