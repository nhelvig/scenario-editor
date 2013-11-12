describe("SplitratioProfile", function() {
  var testNodeId = 2;
  var testNode;
  var testSplitratioProfile;

  beforeEach(function() {
    testNode = new window.beats.Node({id: testNodeId});
    testSplitratioProfile = new window.beats.SplitRatioProfile({node: testNode});
  });

  it("should not blow up on to_xml", function() {
    var doc = document.implementation.createDocument("document:xml", "begin", null);
    var out = testSplitratioProfile.to_xml(doc); 
    expect(out).not.toBeNull();
  });

  it("should contain test node", function() {
    expect(testSplitratioProfile.get('node')).toEqual(testNode);
  });

  it("should resolve node_id as node", function() {
    var s = new window.beats.SplitRatioProfile({node_id: testNodeId});
    expectResolution(s, 'node', testNode);
  });

  it("should encode node reference as node_id", function() {
    // should not contain node_id at first
    expect(testSplitratioProfile.get('node_id')).toBeNull();
    testSplitratioProfile.encode_references();
    expect(testSplitratioProfile.get('node_id')).toEqual(testNodeId);
  });
  
  describe("to_xml", function() {
    beforeEach(function() {
      s = new window.beats.Splitratio;
      s.set_mod_stamp("01/01/01");
      s.set_split_ratio(.02, 0)
      s.set_crud(window.beats.CrudFlag.UPDATE, 0);

      s1 = new window.beats.Splitratio;
      s1.set_split_ratio(.02, 0)
      s1.set_crud(window.beats.CrudFlag.DELETE, 0);
      testSplitratioProfile.set_split_ratios([s,s1]);
    });
    msg = "should remove crud flags and mod stamp";
    msg += "and then replace them";
    it(msg, function(){
      window.beats.fileSaveMode = true;
      doc = document.implementation.createDocument(null, null, null)
      xml = testSplitratioProfile.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/mod_stamp/g)).toBeNull();
      expect(xmlS.match(/crudFlags/g)).toBeNull();
      expect(xmlS.match(/<\/splitratio>/g).length).toEqual(1);
    });
  });
});