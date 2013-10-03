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
});