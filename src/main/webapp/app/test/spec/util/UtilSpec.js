describe("Util", function() {
  $a = window.beats;
  
  beforeEach(function() {
    scen = scenarioAndFriends();
    this.linkList = scen.scenario.links();
  });
  
  describe("getNewElemId", function() {
    it("should get a unique id that is not contained in collection", function() {
      id  = $a.Util.getNewElemId(this.linkList)
      expect(id).toEqual(9999);
    });
  });
  describe("getLinkStrokeWeight", function() {
    it("should return stroke weight dependent on zoom level", function() {
      $a.map.setZoom(18)
      zoom  = $a.Util.getLinkStrokeWeight()
      expect(zoom).toEqual($a.Util.STROKE_WEIGHT_THICKER);
    });
  });
  
  describe("intersect", function() {
    it("should return the point of intersection of two lines", function() {
      var l1 = new google.maps.LatLng(37.84918895390219, -122.29227317790986);
      var l2 = new google.maps.LatLng(37.8483580821288, -122.29200482499436);
      var l3 = new google.maps.LatLng(37.84870922318135, -122.2929180171966);
      var l4 = new google.maps.LatLng(37.84894461433432, -122.29172904033658);
      
      var pt1 =  $a.map.getProjection().fromLatLngToPoint(l1);
      var pt2 =  $a.map.getProjection().fromLatLngToPoint(l2); 
      var pt3 =  $a.map.getProjection().fromLatLngToPoint(l3);
      var pt4 =  $a.map.getProjection().fromLatLngToPoint(l4);
      intersectionPoint  = $a.Util.intersect(pt1, pt2, pt3, pt4);
      latlng = $a.map.getProjection().fromPointToLatLng(intersectionPoint)
      expect(intersectionPoint).not.toBeNull();
    });
  });
  
  describe("parallelLines", function() {
    it("should return two sets of pts generated from one line", function() {
      link = scen.link1;
      path = google.maps.geometry.encoding.decodePath(link.geometry());
      lines  = $a.Util.parallelLines(path,$a.map.getProjection(),3,4);
      expect(lines.path1).not.toBeNull();
      expect(lines.path2).not.toBeNull();
    });
  });
});
