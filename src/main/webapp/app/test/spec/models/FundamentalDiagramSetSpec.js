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
  
  describe("to_xml", function() {
    beforeEach(function() {
      testFDP= new window.beats.FundamentalDiagramProfile();
      testFDP1= new window.beats.FundamentalDiagramProfile();
      testFDP1.set_crud(window.beats.CrudFlag.DELETE);
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
      f.set_fd_profiles([testFDP,testFDP1])
      f.set_crud(window.beats.CrudFlag.UPDATE);
      f.set_mod_stamp("01/01/2000");
    });
    msg = "should remove crud flags and mod stamp";
    msg += "and then replace them";
    it(msg, function(){
      window.beats.fileSaveMode = true;
      doc = document.implementation.createDocument(null, null, null)
      xml = f.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/mod_stamp/g)).toBeNull();
      expect(xmlS.match(/crudFlags/g)).toBeNull();
      expect(xmlS.match(/<\/fundamentalDiagramProfile>/g).length).toEqual(1);
      expect(f.crud()).toEqual(window.beats.CrudFlag.UPDATE);
      expect(f.mod_stamp()).toEqual("01/01/2000");
    });
  });
});