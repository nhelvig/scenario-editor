describe("Node", function() {
  var testNodeId = 1;
  var testNodeId2 = 2;
  var testNode1, testNode2, testNode3;
  var testLink1, testLink2, testLink3;

  beforeEach(function() {
    testNode1 = new window.sirius.Node({id: testNodeId});
    testNode2 = new window.sirius.Node({id: testNodeId2});
    testLink1 = simpleLink(testNode1, testNode2);
    testLink2 = simpleLink(testNode1, testNode2);
    testLink3 = simpleLink(testNode2, testNode1);    
  });

  describe("input indexes", function() {
    it("should return link1 and link2 for inputs to node2 from node1",function() {
      var ii = testNode2.input_indexes(testNode1);
      expect(ii).toContain([testLink1, 0]);
      expect(ii).toContain([testLink2, 1]);
    });
    
    it("should return link3 for inputs to node1 from node2", function() {
      var ii = testNode1.input_indexes(testNode2);
      expect(ii).toContain([testLink3, 0]);
    });
  });

  describe("output indexes", function() {
    it("should return link1 and link2 for outputs to node2 from node1",function() {
      var ii = testNode1.output_indexes(testNode2);
      expect(ii).toContain([testLink1, 0]);
      expect(ii).toContain([testLink2, 1]);
    });

    it("should return link3 for outputs to node1 from node2", function() {
      var ii = testNode2.output_indexes(testNode1);
      expect(ii).toContain([testLink3, 0]);
    });
  });

  describe("ios", function() {
    it("should return every link", function() {
      var links = _.map(testNode1.ios(), function (io) { return io.get('link'); });
      expect(links).toContain(testLink1);
      expect(links).toContain(testLink2);
      expect(links).toContain(testLink3);
    });
  });
});