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
  
});
