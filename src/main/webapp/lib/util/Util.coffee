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
      new google.maps.LatLng(@_getLat(elem), @_getLng(elem))
    else
      null

  # This method is used by View classes to create id names that are all
  # lowercased and have dashes for spaces
  toLowerCaseAndDashed: (text) ->
    text.toLowerCase().replace(/\ /g,"-")

  toStandardCasing: (elem) ->
    formattedWord = []
    for word in elem.split /\s+/
      # if word is not null or not "" (empty)
      if !!word
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
      mode: item.mode

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
  
  publishEvents : (obj, events, context) ->
    for key, value of events
      obj.on(key, context[value], context)
            
  unpublishEvents: (obj, events, context) ->
    for key, value of events
      obj.off(key, context[value], context)  

  setMode: (mode) ->
    if mode is 'view' then $a.Mode.VIEW = true else $a.Mode.VIEW = false
    if mode is 'network' then $a.Mode.NETWORK = true else $a.Mode.NETWORK = false
    if mode is 'scenario' then $a.Mode.SCENARIO = true else $a.Mode.SCENARIO = false
    if mode is 'route' then $a.Mode.ROUTE = true else $a.Mode.ROUTE = false
    
  #parallel lines
  parallelLines: (points, prj) ->
    pPts = [] #left side of center

    #shift the pts array away from the road
    #o = (gapPx + weight)/2
    offset = 0.00005
    for i in [1..points.length-1]
      p1 = prj.fromLatLngToPoint(points[i-1])
      p2 = prj.fromLatLngToPoint(points[i])
      theta = Math.atan2(p1.x-p2.x,p1.y-p2.y) + (Math.PI/2)
      theta -= Math.PI*2 if(theta > Math.PI)
      dx = offset * Math.sin(theta)
      dy = offset * Math.cos(theta)
      p1l = new google.maps.Point(p1.x+dx,p1.y+dy)
      p2l = new google.maps.Point(p2.x+dx,p2.y+dy)
      pPts.push(prj.fromPointToLatLng(p1l))

    pPts.push(prj.fromPointToLatLng(p2l)) #last point
    pPts

  # this function computes the intersection of the sent lines p0-p1 and p2-p3
  # and returns the intersection point,
  intersect: (p0, p1, p2, p3) ->
    # a1 b1 c1 a2 b2 c2 # constants of linear equations
    # det_inv  # the inverse of the determinant of the coefficient matrix
    # m1 m2    # the slopes of each line

    x0 = p0.x;
    y0 = p0.y;
    x1 = p1.x;
    y1 = p1.y;
    x2 = p2.x;
    y2 = p2.y;
    x3 = p3.x;
    y3 = p3.y;

    # compute slopes, note the cludge for infinity, however, this will
    # be close enough

    if ((x1-x0)!=0)
      m1 = (y1-y0)/(x1-x0)
    else
      m1 = 1e+10   # close enough to infinity

    if ((x3-x2)!=0)
      m2 = (y3-y2)/(x3-x2)
    else
      m2 = 1e+10   # close enough to infinity

    #compute constants
    a1 = m1
    a2 = m2

    b1 = -1
    b2 = -1

    c1 = (y0-m1*x0)
    c2 = (y2-m2*x2)

    #compute the inverse of the determinate
    det_inv = 1/(a1*b2 - a2*b1)

    # use Kramers rule to compute xi and yi
    xi=((b1*c2 - b2*c1)*det_inv)
    yi=((a2*c1 - a1*c2)*det_inv)

    return new google.maps.Point(Math.round(xi),Math.round(yi))

  convertPointsToGoogleLatLng : (pts) ->
    (new google.maps.LatLng(pt.lat(), pt.lng()) for pt in pts)

  # determine strokeweight for zoom
  getLinkStrokeWeight: ->
    zoomLevel = $a.map.getZoom()
    if (zoomLevel >= 18)
      newZoom = $a.Util.STROKE_WEIGHT_THICKER
    else if (zoomLevel >= 17)
      newZoom = $a.Util.STROKE_WEIGHT_THICK
    else if (zoomLevel >= 16)
      newZoom = $a.Util.STROKE_WEIGHT_THIN
    else
      newZoom = $a.Util.STROKE_WEIGHT_THINNER
    newZoom

  # Function to convert JSON to XML
  # Reference: http://goessner.net/download/prj/jsonxml/
  json2xml: (json, tab) ->
    xml = ""
    # Recursive function to transveres through child JSON objects
    toXml = (v, name, ind) ->
      # define XML variable to be global
      $a.xml = "";
      # If JSON element is an Array
      if v instanceof Array 
        for elm in v
          $a.xml += ind + toXml(elm, name, ind+"\t") + "\n"

      # If JSON element is an object 
      else if typeof(v) == "object" 
        hasChild = false
        $a.xml += ind + "<" + name
        for key of v
          # If element has "@" character at beginning it is an attribute
          if key.charAt(0) == "@"
            $a.xml += " " + key.substr(1) + "=\"" + v[key].toString() + "\""
          # Otherwise element is a tag
          else
            hasChild = true
        # Close brace dependent if it has children    
        $a.xml += if hasChild then ">" else "/>"
        
        # Continue on if JSON element has child elements
        if hasChild
          for key of v
            # If element key is of type text (no XML tag created)
            if key == "#text" or key == "$"
              $a.xml += v[key]
            else if key == "#cdata" 
              $a.xml += "<![CDATA[" + v[key] + "]]>"
            # Else if element is not an XML attribute it has children
            else if key.charAt(0) != "@"
              $a.xml += toXml v[key], key, ind+"\t"
            
          # Add indentation for new element if it is on a new line 
          if $a.xml.charAt($a.xml.length-1) == "\n"
            $a.xml += ind + "</" + name + ">"
          else
            $a.xml += "</" + name + ">"
      
      # If JSON element is just a string value
      else
         $a.xml += ind + "<" + name + ">" + v?.toString() +  "</" + name + ">"
      $a.xml

    for key of json
      xml += toXml(json[key], key, "");
    if tab? 
      xml.replace(/\t/g, tab)
    else
      xml.replace(/\t|\n/g, "")
    # return xml
    xml

  # Utility function used to convert a backbone Object to JSON
  obj2json: (obj) ->
    seen = []
    JSON.stringify(obj, (key, val) ->
      if typeof val == "object"
        if seen.indexOf(val) >= 0
          return
        seen.push(val)
      return val
    )
