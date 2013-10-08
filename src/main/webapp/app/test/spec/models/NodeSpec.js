describe("Node", function() {
  var testNodeId = 1;
  var testNodeId2 = 2;
  var testNode1, testNode2, testNode3;
  var testLink1, testLink2, testLink3;

  beforeEach(function() {
    pt = new window.beats.Point()
    pt.set('lat',0)
    pt.set('lng',0)
    pt.set('elevation', '')
    p = new window.beats.Position()
    p.get('point').push(pt)
    testNode1 = new window.beats.Node({id: testNodeId, position: p});
    testNode2 = new window.beats.Node({id: testNodeId2});
    testLink1 = simpleLink(1, testNode1, testNode2);
    testLink2 = simpleLink(2, testNode1, testNode2);
    testLink3 = simpleLink(3, testNode2, testNode1);    
  });
  describe("to_xml", function() {
    beforeEach(function() {
      doc = document.implementation.createDocument("document:xml", "begin", null);
      testNode1.set_crud(window.beats.CrudFlag.UPDATE);
      out = testNode1.to_xml(doc);
    });
    it("should not blow up on to_xml", function() {
      expect(out).not.toBeNull();

    });
    it("should not contain crudFlag or modstamp attributes", function() {  
      var strOut = new XMLSerializer().serializeToString(out);
      var matchC = strOut.indexOf('crudFlag');
      var matchM = strOut.indexOf('mod_stamp');
      expect(matchC).toEqual(-1);
      expect(matchM).toEqual(-1);
    });
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
  
  describe("remove_input_output", function() {
    it("should remove the input and output link from node", function() {
      beforeIns = testNode1.inputs().length
      beforeOuts = testNode2.outputs().length
      testNode1.remove_input_output(testLink3);
      testNode2.remove_input_output(testLink3);
      expect(testNode1.inputs().length).toEqual(beforeIns - 1);
      expect(testNode2.outputs().length).toEqual(beforeOuts - 1);
    });
  });
});