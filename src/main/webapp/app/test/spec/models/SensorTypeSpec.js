describe("SensorType", function() {
  
  beforeEach(function() {
    s = new window.beats.SensorType()
  });
  
  describe("Default Attributes", function() {
    it("should be set", function() {
      expect(s.name()).toEqual('Loop');  
      expect(s.description()).toEqual('');
      expect(s.ident()).toEqual(1);
    });
  });
  
  describe("Attributes", function() {
    it("should be set", function() {
      s.set_name('ST test');
      expect(s.name()).toEqual('ST test');
      
      s.set_description('ST Desc');
      expect(s.description()).toEqual('ST Desc');
      
      s.set_id(12);
      expect(s.ident()).toEqual(12);
    });
  });
});
