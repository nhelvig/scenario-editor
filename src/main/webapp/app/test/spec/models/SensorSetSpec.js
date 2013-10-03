describe("SensorSet", function() {
  
  beforeEach(function() {
    s = new window.beats.SensorSet()
  });
  
  describe("Default Attributes", function() {
    it("should be set", function() {
      expect(s.name()).toEqual('');  
      expect(s.description()).toEqual('');
      expect(s.ident()).toEqual(null);
      expect(s.project_id()).toEqual(null);
      expect(s.sensors().length).toEqual(0);
      expect(s.locked_for_edit()).toBeFalsy();
      expect(s.locked_for_history()).toBeFalsy();
      expect(s.crud()).toEqual(window.beats.CrudFlag.CREATE);
    });
  });
  
  describe("Attributes", function() {
    it("should be set", function() {
      s.set_name('SS test');
      expect(s.name()).toEqual('SS test');
      
      s.set_description('SS Desc');
      expect(s.description()).toEqual('SS Desc');
      
      s.set_id(12);
      expect(s.ident()).toEqual(12);
      
      s.set_project_id(12);
      expect(s.project_id()).toEqual(12);
      
      s.set_sensors([new window.beats.Sensor()]);
      expect(s.sensors().length).toEqual(1);
      
      s.set_locked_for_edit(true)
      expect(s.locked_for_edit()).toBeTruthy();

      s.set_locked_for_history(true)
      expect(s.locked_for_history()).toBeTruthy();

      s.set_crud(window.beats.CrudFlag.UPDATE)      
      expect(s.crud()).toEqual(window.beats.CrudFlag.CREATE);
    });
  });
});
