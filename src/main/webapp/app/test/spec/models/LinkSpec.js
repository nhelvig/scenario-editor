describe("Link", function() {
  var testNodeId = 2;
  var testNodeId2 = 3;
  var testNodeId3 = 4;
  var testNodeId4 = 5;

  var testNode, testNode2, testNode3, testNode4;
  var testLink1;
  var testLink2;
  var doc;
  var out;
  
  beforeEach(function() {
    testNode = new window.beats.Node({id: testNodeId});
    testNode2 = new window.beats.Node({id: testNodeId2});
    testNode3 = new window.beats.Node({id: testNodeId3});
    testLink1 = simpleLink(1, testNode, testNode2);
    testLink2 = simpleLink(2, testNode, testNode3);
    testLink3 = simpleLink(3, testNode, testNode3);
    scen = scenarioAndFriends();
  });

  describe("to_xml", function() {
    beforeEach(function() {
      window.beats.fileSaveMode = true;
      doc = document.implementation.createDocument("document:xml", "begin", null);
      testLink1.set_crud(window.beats.CrudFlag.UPDATE);
      out = testLink1.to_xml(doc);
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
  
  describe("road_names", function() {
    it("should return road_names concatenated with comma", function() {
      expect(testLink1.road_names()).toEqual("name1, name2");
    });
  });
  
  describe("remove if CREATE", function() {
    msg = "should remove the link from the links list of models if the CrudFlag";
    msg += "is CREATE and remove it from Inputs and Outputs of its begin "
    msg += "end nodes";
    it(msg, function() {
      $a.models.links().push(scen.link1);
      var length = $a.models.links().length;
      var oLength = scen.link1.begin_node().outputs().length
      var iLength = scen.link1.end_node().inputs().length

      scen.link1.set_crud($a.CrudFlag.CREATE);
      scen.link1.remove();
      var afterOLength = scen.link1.begin_node().outputs().length;
      var afterILength = scen.link1.end_node().inputs().length;
      expect(oLength - 1).toEqual(afterOLength);
      expect(iLength - 1).toEqual(afterILength);
      expect(length-1).toEqual($a.models.links().length);
    });
  });
  
});