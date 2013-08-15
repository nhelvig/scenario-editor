# ImportPemsView 
class window.beats.ImportPemsView extends google.maps.OverlayView
  $a = window.beats
  el: {}
  vertices : []
  tmpMarkers : []
  
  constructor: (@options) ->
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
      @manageDraw(e.latLng)
    )
    gme.addListener(@poly, 'click', (e) =>
      @vertices.splice(e.vertex, 1)
      @manageDraw(e.latLng)
    )
  
  manageDraw : (latLng) ->
    if(@vertices.length < 3)
      @poly.setPaths([])
      @drawMarker(latLng)
    if(@vertices.length == 3)
      @removeMarker()  
    if(@vertices.length > 2)
      @poly.setPaths(@vertices)

  drawMarker : (latLng) ->
    @marker = new google.maps.Marker({
      map: $a.map
      strokeColor: '#FF0000'
      strokeWeight: 2
      strokeOpacity: 0.7
      position: latLng
      icon: {
        strokeColor: '#FF0000'
        strokeWeight: 1
        strokeOpacity: 0.7
        fillColor: '#FFFFFF'
        fillOpacity : 0.2
        path: google.maps.SymbolPath.CIRCLE
        scale: 5
      }
    })
    @tmpMarkers.push @marker
  
  removeMarker: ->
    _.each(@tmpMarkers, (m) => m.setMap(null))
    @tmpMarkers = []