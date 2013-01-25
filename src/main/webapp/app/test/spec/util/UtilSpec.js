describe("Util", function() {
  $a = window.beats;
  
  beforeEach(function() {
    scen = scenarioAndFriends();
    this.linkList = scen.scenario.links();
  });
  
  describe("getNewElemId", function() {
    it("should get a unique id that is not contained in collection", function() {
      id  = $a.Util.getNewElemId(this.linkList)
      expect(id).toEqual(1);
    });
  });
  describe("getLinkStrokeWeight", function() {
    it("should return stroke weight dependent on zoom level", function() {
      $a.map.setZoom(18)
      zoom  = $a.Util.getLinkStrokeWeight()
      expect(zoom).toEqual($a.Util.STROKE_WEIGHT_THICKER);
    });
  });
});
