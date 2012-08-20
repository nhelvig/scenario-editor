describe("DemandProfile", function() {
  var testLinkId = 2;
  var testLink;
  var testDemandProfile;
  
  beforeEach(function() {
    testLink = new window.sirius.Link({id: testLinkId});
    testDemandProfile = new window.sirius.DemandProfile({link: testLink});
  });
  
  it("should not blow up on to_xml", function() {
    var doc = document.implementation.createDocument("document:xml", "begin", null);
    var out = testDemandProfile.to_xml(doc); 
    expect(out).not.toBeNull();
  });
  
  it("should contain test link", function() {
    expect(testDemandProfile.get('link')).toEqual(testLink);
  });
  
  it("should resolve link_id_origin as link", function() {
    var d = new window.sirius.DemandProfile({link_id_origin: testLinkId});
    expectResolution(d, 'link', testLink);
    expect(testLink.get('demand')).toEqual(d);
  });
  
  it("should encode link reference as link_id_origin", function() {
    // should not contain link_id at first
    expect(testDemandProfile.get('link_id')).toBeUndefined();
    testDemandProfile.encode_references();
    expect(testDemandProfile.get('link_id')).toEqual(testLinkId);
  });
});