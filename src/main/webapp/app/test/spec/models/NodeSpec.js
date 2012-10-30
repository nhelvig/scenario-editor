describe("Node", function() {
  var testNodeId = 1;
  var testNodeId2 = 2;
  var testNode1, testNode2, testNode3;
  var testLink1, testLink2, testLink3;

  beforeEach(function() {
    pt = new window.sirius.Point()
    pt.set('lat',0)
    pt.set('lng',0)
    pt.set('elevation', NaN)
    p = new window.sirius.Position()
    p.get('point').push(pt)
    testNode1 = new window.sirius.Node({id: testNodeId, position: p});
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
  
  describe("updatePosition", function() {
    it("should change the node's position", function() {
      var latLng = new google.maps.LatLng(37.83999, -122.29681);
      testNode1.updatePosition(latLng);
      expect(testNode1.get('position').get('point')[0].get('lat')).toEqual(latLng.lat());
      expect(testNode1.get('position').get('point')[0].get('lng')).toEqual(latLng.lng());
    });
  });
});