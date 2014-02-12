describe("DemandProfile", function() {
  var testLinkId = 2;
  var testLink;
  var testDemandProfile;
  
  beforeEach(function() {
    testLink = new window.beats.Link({id: testLinkId});
    testDemandProfile = new window.beats.DemandProfile({link: testLink});
    d = new window.beats.Demand;
    d.set_demand(100, 0);
    d.set_demand(200, 1);
    d.set_demand(300, 2);
    d.set_crud(window.beats.CrudFlag.DELETE, 0);
    d.set_crud(window.beats.CrudFlag.DELETE, 1);
    d.set_crud(window.beats.CrudFlag.DELETE, 2);
    testDemandProfile.set_demands([d])
  });
  
  it("should not blow up on to_xml", function() {
    var doc = document.implementation.createDocument("document:xml", "begin", null);
    var out = testDemandProfile.to_xml(doc); 
    expect(out).not.toBeNull();
  });
  
  it("should contain test link", function() {
    expect(testDemandProfile.get('link')).toEqual(testLink);
  });
  
  // it("should resolve link_id_origin as link", function() {
  //   var d = new window.beats.DemandProfile({link_id_origin: testLinkId});
  //   expectResolution(d, 'link', testLink);
  //   expect(testLink.get('demand')).toEqual(d);
  // });
  
  // it("should encode link reference as link_id_origin", function() {
  //   // should not contain link_id at first
  //   expect(testDemandProfile.get('link_id')).toBeUndefined();
  //   testDemandProfile.encode_references();
  //   expect(testDemandProfile.get('link_id')).toEqual(testLinkId);
  // });

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
  
  describe("to_xml", function() {
    msg = "should remove crud flags and mod stamp";
    msg += "and then replace them";
    it(msg, function(){
      window.beats.fileSaveMode = true;
      doc = document.implementation.createDocument(null, null, null)
      xml = testDemandProfile.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/mod_stamp/g)).toBeNull();
      expect(xmlS.match(/crudFlags/g)).toBeNull();
      expect(xmlS.match(/<demand>/g)).toBeNull();
    });
  });
});