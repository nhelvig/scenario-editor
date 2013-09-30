describe("FundamentalDiagramSet", function() {
  
  beforeEach(function() {
    f = new window.beats.FundamentalDiagramSet()
  });
  
  describe("Default Attributes", function() {
    it("should be set", function() {
      expect(f.name()).toBeNull();
      expect(f.description_text()).toBeNull();
      expect(f.ident()).toBeNull();
      expect(f.project_id()).toBeNull();
      expect(f.fd_profiles().length).toEqual(0);
      expect(f.locked_for_edit()).toBeFalsy();
      expect(f.locked_for_history()).toBeFalsy();
    });
  });
  
  describe("Attributes", function() {
    it("should be set", function() {
      f.set_name('FDS test');
      expect(f.name()).toEqual('FDS test');
      
      f.set_description_text('FDS Desc');
      expect(f.description_text()).toEqual('FDS Desc');
      
      f.set_id(12);
      expect(f.ident()).toEqual(12);
      
      f.set_project_id(12);
      expect(f.project_id()).toEqual(12);
      
      f.set_fd_profiles([new window.beats.FundamentalDiagramProfile()]);
      expect(f.fd_profiles().length).toEqual(1);
      
      f.set_locked_for_edit(true)
      expect(f.locked_for_edit()).toBeTruthy();

      f.set_locked_for_history(true)
      expect(f.locked_for_history()).toBeTruthy();
    });
  });
});