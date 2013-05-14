window.beats.Point::defaults =
  lat: 0
  lng: 0
  elevation: 0

window.beats.Point::set_lat = (lat) -> @set('lat', lat)
window.beats.Point::set_lng = (lng) -> @set('lng', lng)
window.beats.Point::set_elevation = (elev) -> @set('elevation', elev)

window.beats.Point::lat = -> @get('lat')
window.beats.Point::lng = -> @get('lng')
window.beats.Point::elevation = -> @get('elevation')
