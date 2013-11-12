describe("FundamentalDiagramProfile", function() {
  var  testFDP;

  beforeEach(function() {
    testFDP= new window.beats.FundamentalDiagramProfile();
  });

  it("should have all fields set to defaults", function() {
    expect(testFDP.crud()).toBeNull();
    expect(testFDP.fdp_id()).toBeNull();
    expect(testFDP.link_id()).toBeNull();
    expect(testFDP.sensor_id()).toBeNull();
    expect(testFDP.start_time()).toEqual(0);
    expect(testFDP.dt()).toEqual(0);
    expect(testFDP.agg_run_id()).toBeNull();
  });
  it("should set all fields", function() {
    testFDP.set_crud(window.beats.CrudFlag.DELETE);
    testFDP.set_fdp_id(1);
    testFDP.set_link_id(1);
    testFDP.set_sensor_id(1);
    testFDP.set_start_time(1);
    testFDP.set_dt(1);
    testFDP.set_agg_run_id(1);
    expect(testFDP.crud()).toEqual(window.beats.CrudFlag.DELETE);
    expect(testFDP.fdp_id()).toEqual(1);
    expect(testFDP.link_id()).toEqual(1);
    expect(testFDP.sensor_id()).toEqual(1);
    expect(testFDP.start_time()).toEqual(1);
    expect(testFDP.dt()).toEqual(1);
    expect(testFDP.agg_run_id()).toEqual(1);
  });
  describe("to_xml", function() {
    beforeEach(function() {
      fd = new window.beats.FundamentalDiagram();
      fd1 = new window.beats.FundamentalDiagram();
      fd1.set_crud(window.beats.CrudFlag.DELETE);
      fd.set_mod_stamp("01/01/01");
      fd.set_crud(window.beats.CrudFlag.UPDATE);
      fd.set_ident(1);
      fd.set_order(1);
      fd.set_capacity(1);
      fd.set_capacity_drop(1);
      fd.set_std_dev_capacity(1);
      fd.set_free_flow_speed(1);
      fd.set_critical_speed(1);
      fd.set_congestion_speed(1);
      fd.set_std_dev_free_flow_speed(1);
      fd.set_std_dev_congestion_speed(1);
      fd.set_jam_density(1);
      testFDP.set_fundamental_diagram([fd,fd1]);
      testFDP.set_link(new window.beats.Link({id: 2}));
    });
    msg = "should remove crud flags and mod stamp";
    msg += "and then replace them";
    it(msg, function(){
      window.beats.fileSaveMode = true;
      doc = document.implementation.createDocument(null, null, null)
      xml = testFDP.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/mod_stamp/g)).toBeNull();
      expect(xmlS.match(/crudFlags/g)).toBeNull();
      expect(xmlS.match(/<fundamentalDiagram /g).length).toEqual(1);
    });
  });
});