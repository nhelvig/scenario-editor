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

  describe("profile parsing", function() {
    it("should return '3' as [[3]]", function() {
      testDemandProfile.set('text', '3');
      expect(testDemandProfile.demands_by_vehicle_type()).toEqual([[3]]);
    });

    it("should separate vehicle types in output array", function() {
      testDemandProfile.set('text', '3:4,5:6,7:8');
      expect(testDemandProfile.demands_by_vehicle_type()).
	toEqual([[3,5,7],[4,6,8]]);
    });

    it("should handle 1 vehicle type, multiple values", function() {
      testDemandProfile.set('text', '1,2,3,4');
      expect(testDemandProfile.demands_by_vehicle_type()).
	toEqual([[1,2,3,4]]);
    });
  });

  it("should distinguish between constant and non-constant demands", function() {
    testDemandProfile.set('text','1');
    expect(testDemandProfile.is_constant()).toEqual(true);
    testDemandProfile.set('text','1,2');
    expect(testDemandProfile.is_constant()).toEqual(false);
  });
});