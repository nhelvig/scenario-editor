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
  describe("set_display_position", function() {
    it("should set the display poistion", function() {
      s.set_display_position('lat', 99);
      expect(s.display_lat()).toEqual(99);
      s.set_display_position('lng', 98);
      expect(s.display_lng()).toEqual(98);
      s.set_display_position('elevation', 97);
      expect(s.display_elev()).toEqual(97);
    });
  });
  describe("point", function() {
    it("should return the display position's point", function() {
      expect(s.point()).toEqual(pt);
    });
    describe("when no point is define", function() {
      it("should return a point object with default lat/lng", function() {
        s.get('display_position').set('point',[])
        expect(s.point().lat()).toEqual(0);
      });
    });
  });
});