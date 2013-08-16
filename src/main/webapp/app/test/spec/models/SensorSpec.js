describe("Sensor", function() {

  beforeEach(function() { 
    s = new window.beats.Sensor; 
    pt = new window.beats.Point()
    pt.set('lat',0)
    pt.set('lng',0)
    pt.set('elevation', '')
    p = new window.beats.Position()
    p.get('point').push(pt)
    s.set('display_position', p)
  });
  
  describe("updatePosition", function() {
    it("should change the sensor's position", function() {
      var latLng = new google.maps.LatLng(37.83999, -122.29681);
      s.updatePosition(latLng);
      expect(s.display_lat()).toEqual(latLng.lat());
      expect(s.display_lng()).toEqual(latLng.lng());
    });
  });
});