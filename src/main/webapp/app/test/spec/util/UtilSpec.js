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

  describe("publish/unpublish Events", function() {
    it("should publish an event and unpublish correctly", function() {
      $a.test = function() {};
      spyOn($a, 'test').andCallThrough();
      $a.Util.publishEvents($a.broker, {'test_event' : 'test'}, $a);
      $a.broker.trigger('test_event');
      expect($a.test).toHaveBeenCalled();
      $a.test.reset();
      $a.Util.unpublishEvents($a.broker, {'test_event' : 'test'}, $a);
      $a.broker.trigger('test_event');
      expect($a.test).not.toHaveBeenCalled();
    });
  });
});
