# PolygonDynamicView allows you to create a dynamically-sized bounded-polygon
# based on mouse clicks
class window.beats.PolygonDynamicView extends google.maps.OverlayView
  $a = window.beats
  vertices : []
  markerIconOpts: {
        strokeColor: '#FF0000'
        strokeWeight: 1
        strokeOpacity: 0.7
        fillOpacity : 0.5
        path: google.maps.SymbolPath.CIRCLE
        scale: 5
      }
  
  constructor: ->
    $a.map.setOptions({draggableCursor:'crosshair'})
    @drawPolygon()
  
  manageDraw : () ->
    @removeMarker()
    @removeLine()
    @removePolygon()
    if(@vertices.length == 1)
      @drawMarker()
    else if(@vertices.length == 2)
      @drawLine()
    else if(@vertices.length > 2)
      @poly.setPaths(@vertices)

  drawPolygon: () ->
    @poly = new google.maps.Polygon({
      path: []
      map: $a.map
      strokeColor: '#FF0000'
      strokeWeight: 2
      strokeOpacity: 0.7
      fillColor: '#FF0000'
      fillOpacity : 0.2
      editable: true
      draggable: true
    })
    gme = google.maps.event
    gme.addListener($a.map, 'click', (e) =>
      @vertices.push e.latLng
      @manageDraw()
    )
    gme.addListener(@poly, 'click', (e) =>
      @vertices.splice(e.vertex, 1)
      @manageDraw()
    )
  
  removePolygon : ->
    @poly.setPaths([])
  
  drawMarker : () ->
    @marker = new google.maps.Marker({
      map: $a.map
      strokeColor: '#FF0000'
      strokeWeight: 2
      strokeOpacity: 0.7
      position: @vertices[0]
      draggable: true
      icon: @_getMarkerOpts("#FFFFFF")
    })
    gme = google.maps.event
    gme.addListener(@marker, 'click', (e) =>
      @vertices.splice(e.vertex, 1)
      @manageDraw()
    )
    gme.addListener(@marker, 'mouseover', (e) =>
      @marker.setIcon(@_getMarkerOpts("#FF0000"))
    )
    gme.addListener(@marker, 'mouseout', (e) =>
      @marker.setIcon(@_getMarkerOpts("#FFFFFF"))
    )
    gme.addListener(@marker, 'dragend', (e) =>
      @vertices.pop()
      @vertices.push(e.latLng)
    )
    
  removeMarker: ->
    @marker?.setMap(null)
  
  drawLine: ->
    @line = new google.maps.Polyline({
      map: $a.map
      strokeColor: '#FF0000'
      strokeWeight: 2
      strokeOpacity: 0.7
      path: @vertices
      editable: true
      icon: @markerIconOpts
    })
    gme = google.maps.event
    gme.addListener(@line, 'click', (e) =>
      @vertices.splice(e.vertex, 1)
      @manageDraw()
    )
  
  removeLine: ->
    @line?.setMap(null)
  
  _getMarkerOpts : (color) ->
    @markerIconOpts.fillColor = color
    @markerIconOpts