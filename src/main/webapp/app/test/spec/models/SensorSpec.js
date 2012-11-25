describe("Sensor", function() {
  var testSensor;
  
  beforeEach(function() {
    scen = scenarioAndFriends();
    testSensor = scen.sensor; 
    pt = new window.beats.Point()
    pt.set('lat',0)
    pt.set('lng',0)
    pt.set('elevation', NaN)
    p = new window.beats.Position()
    p.get('point').push(pt)
    testSensor.set('display_position', p)
  });
  
  describe("updatePosition", function() {
    it("should change the sensor's position", function() {
      var latLng = new google.maps.LatLng(37.83999, -122.29681);
      testSensor.updatePosition(latLng);
      expect(testSensor.display_lat()).toEqual(latLng.lat());
      expect(testSensor.display_lng()).toEqual(latLng.lng());
    });
  });
});