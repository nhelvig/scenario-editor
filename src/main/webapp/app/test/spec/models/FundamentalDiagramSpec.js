describe("FundamentalDiagram", function() {
  var  testFD;

  beforeEach(function() {
    testFD= new window.beats.FundamentalDiagram();
  });

  it("should have all fields set to defaults", function() {
    expect(testFD.crud()).toBeNull();
    expect(testFD.ident()).toBeNull();
    expect(testFD.order()).toBeNull();
    expect(testFD.capacity()).toBeNull();
    expect(testFD.capacity_drop()).toBeNull();
    expect(testFD.std_dev_capacity()).toBeNull();
    expect(testFD.free_flow_speed()).toBeNull();
    expect(testFD.congestion_speed()).toBeNull();
    expect(testFD.critical_speed()).toBeNull();
    expect(testFD.std_dev_free_flow_speed()).toBeNull();
    expect(testFD.std_dev_congestion_speed()).toBeNull();
    expect(testFD.jam_density()).toBeNull();
  });
  it("should set all fields", function() {
    testFD.set_crud(window.beats.CrudFlag.DELETE);
    testFD.set_ident(1);
    testFD.set_order(1);
    testFD.set_capacity(1);
    testFD.set_capacity_drop(1);
    testFD.set_std_dev_capacity(1);
    testFD.set_free_flow_speed(1);
    testFD.set_critical_speed(1);
    testFD.set_congestion_speed(1);
    testFD.set_std_dev_free_flow_speed(1);
    testFD.set_std_dev_congestion_speed(1);
    testFD.set_jam_density(1);
    expect(testFD.crud()).toEqual(window.beats.CrudFlag.DELETE);
    expect(testFD.ident()).toEqual(1);
    expect(testFD.order()).toEqual(1);
    expect(testFD.capacity()).toEqual(1);
    expect(testFD.capacity_drop()).toEqual(1);
    expect(testFD.std_dev_capacity()).toEqual(1);
    expect(testFD.free_flow_speed()).toEqual(1);
    expect(testFD.congestion_speed()).toEqual(1);
    expect(testFD.critical_speed()).toEqual(1);
    expect(testFD.std_dev_free_flow_speed()).toEqual(1);
    expect(testFD.std_dev_congestion_speed()).toEqual(1);
    expect(testFD.jam_density()).toEqual(1);
  });
  describe("to_xml", function() {
    beforeEach(function() {
      testFD.set_mod_stamp("01/01/01");
      testFD.set_crud(window.beats.CrudFlag.UPDATE);
      testFD.set_ident(1);
      testFD.set_order(1);
      testFD.set_capacity(1);
      testFD.set_capacity_drop(1);
      testFD.set_std_dev_capacity(1);
      testFD.set_free_flow_speed(1);
      testFD.set_critical_speed(1);
      testFD.set_congestion_speed(1);
      testFD.set_std_dev_free_flow_speed(1);
      testFD.set_std_dev_congestion_speed(1);
      testFD.set_jam_density(1);
    });
    msg = "should remove crud flags and mod stamp";
    msg += "and then replace them";
    it(msg, function(){   
      doc = document.implementation.createDocument(null, null, null)
      xml = testFD.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/mod_stamp/g)).toBeNull();
      expect(xmlS.match(/crudFlag/g)).toBeNull();
      expect(testFD.mod_stamp()).toEqual("01/01/01");
      expect(testFD.crud()).toEqual(window.beats.CrudFlag.UPDATE);
    });
  });
});