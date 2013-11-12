describe("SplitratioProfile", function() {
  var testNodeId = 2;
  var testNode;
  var testSplitratioProfile;
  var tSplitRatioSet;

  beforeEach(function() {
    testNode = new window.beats.Node({id: testNodeId});
    tSplitratioProfile = new window.beats.SplitRatioProfile({node: testNode});
    tSplitratioProfile2 = new window.beats.SplitRatioProfile({node: testNode});
    profs = [tSplitratioProfile, tSplitratioProfile2];
    tSplitRatioSet = new window.beats.SplitRatioSet();
    tSplitRatioSet.set_split_ratio_profiles(profs);
    tSplitRatioSet.set_crud(window.beats.CrudFlag.UPDATE);
    tSplitRatioSet.set_mod_stamp("01/01/2000");
    s = new window.beats.Splitratio;
    s.set_split_ratio(0.1,0);
    s.set_split_ratio(0.2,1);
    s.set_split_ratio(0.3,2);
    s.set_crud(window.beats.CrudFlag.UPDATE, 0);
    s.set_crud(window.beats.CrudFlag.DELETE, 1);
    s.set_crud(window.beats.CrudFlag.DELETE, 2);
    tSplitratioProfile.set_split_ratios ([s]);
    tSplitratioProfile2.set_crud(window.beats.CrudFlag.DELETE);
  });

  it("should not blow up on to_xml", function() {
    var doc = document.implementation.createDocument("document:xml", "begin", null);
    var out = tSplitRatioSet.to_xml(doc); 
    expect(out).not.toBeNull();
  });
  
  describe("to_xml", function() {
    msg = "should remove crud flags and mod stamp";
    msg += "and then replace them";
    it(msg, function(){
      window.beats.fileSaveMode = true;
      doc = document.implementation.createDocument(null, null, null)
      xml = tSplitRatioSet.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/mod_stamp/g)).toBeNull();
      expect(xmlS.match(/crudFlags/g)).toBeNull();
      expect(xmlS.match(/<\/splitRatioProfile>/g).length).toEqual(1);
      expect(tSplitRatioSet.crud()).toEqual(window.beats.CrudFlag.UPDATE);
      expect(tSplitRatioSet.mod_stamp()).toEqual("01/01/2000");
    });
  });
});