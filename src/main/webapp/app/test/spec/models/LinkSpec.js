describe("Link", function() {
  var testNodeId = 2;
  var testNodeId2 = 3;
  var testNodeId3 = 4;
  var testNodeId4 = 5;

  var testNode, testNode2, testNode3, testNode4;
  var testLink1;
  var testLink2;

  beforeEach(function() {
    testNode = new window.beats.Node({id: testNodeId});
    testNode2 = new window.beats.Node({id: testNodeId2});
    testNode3 = new window.beats.Node({id: testNodeId3});
    testLink1 = simpleLink(testNode, testNode2);
    testLink2 = simpleLink(testNode, testNode3);
    testLink3 = simpleLink(testNode, testNode3);
  });

  it("should not blow up on to_xml", function() {
    var doc = document.implementation.createDocument("document:xml", "begin", null);
    var out = testLink1.to_xml(doc);
    expect(out).not.toBeNull();
  });

  describe("parallel_links", function() {
    it("should return parallel links", function() {
      expect(testLink2.parallel_links()).toContain(testLink3);
      expect(testLink3.parallel_links()).toContain(testLink2);
    });
    it("should not return non-parallel links", function() {
      expect(testLink1.parallel_links()).not.toContain(testLink2);
      expect(testLink1.parallel_links()).not.toContain(testLink3);
    });
  });
  
  describe("get_road_names", function() {
    it("should return road_names concatenated with comma", function() {
      expect(testLink1.get_road_names()).toEqual("name1, name2");
    });
  });
});