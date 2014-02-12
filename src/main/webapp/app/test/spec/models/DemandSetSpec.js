describe("DemandProfile", function() {
  var testLinkId = 2;
  var testLink;
  var testDemandProfile;
  var tDemandSet;
  
  beforeEach(function() {
    testLink = new window.beats.Link({id: testLinkId});
    tDemandProfile = new window.beats.DemandProfile({link: testLink});
    tDemandProfile2 = new window.beats.DemandProfile({link: testLink});
    profs = [tDemandProfile, tDemandProfile2];
    tDemandSet = new window.beats.DemandSet({demandprofile:profs});
    tDemandSet.set_crud(window.beats.CrudFlag.UPDATE);
    tDemandSet.set_mod_stamp("01/01/2000");
    d = new window.beats.Demand;
    d.set_demand(100, 0);
    d.set_demand(200, 1);
    d.set_demand(300, 2);
    d.set_crud(window.beats.CrudFlag.UPDATE, 0);
    d.set_crud(window.beats.CrudFlag.DELETE, 1);
    d.set_crud(window.beats.CrudFlag.DELETE, 2);
    tDemandProfile.set_demands([d]);
    tDemandProfile2.set_crud(window.beats.CrudFlag.DELETE);
  });
  
  it("should not blow up on to_xml", function() {
    var doc = document.implementation.createDocument("document:xml", "begin", null);
    var out = tDemandSet.to_xml(doc); 
    expect(out).not.toBeNull();
  });
  
  it("should contain demand Profile", function() {
    expect(tDemandSet.demand_profiles()[0]).toEqual(tDemandProfile);
  });
  
  describe("to_xml", function() {
    msg = "should remove crud flags and mod stamp";
    msg += "and then replace them";
    it(msg, function(){
      window.beats.fileSaveMode = true;
      doc = document.implementation.createDocument(null, null, null)
      xml = tDemandSet.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/mod_stamp/g)).toBeNull();
      expect(xmlS.match(/crudFlags/g)).toBeNull();
      expect(xmlS.match(/<\/demandProfile>/g).length).toEqual(1);
      expect(tDemandSet.crud()).toEqual(window.beats.CrudFlag.UPDATE);
      expect(tDemandSet.mod_stamp()).toEqual("01/01/2000");
    });
  });
});