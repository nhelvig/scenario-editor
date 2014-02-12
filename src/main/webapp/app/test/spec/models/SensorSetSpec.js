describe("SensorSet", function() {
  
  beforeEach(function() {
    s = new window.beats.SensorSet();
  });
  
  describe("Default Attributes", function() {
    it("should be set", function() {
      expect(s.name()).toEqual(null);
      expect(s.description_text()).toEqual(null);
      expect(s.ident()).toEqual(null);
      expect(s.project_id()).toEqual(null);
      expect(s.sensors().length).toEqual(0);
      expect(s.locked_for_edit()).toBeFalsy();
      expect(s.locked_for_history()).toBeFalsy();
    });
  });
  
  describe("Attributes", function() {
    it("should be set", function() {
      s.set_name('SS test');
      expect(s.name()).toEqual('SS test');
      
      s.set_description_text('SS Desc');
      expect(s.description_text()).toEqual('SS Desc');
      
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

      s.set_crud_flag(window.beats.CrudFlag.UPDATE)      
      expect(s.crud()).toEqual(window.beats.CrudFlag.UPDATE);
    });
  });
  describe("to_xml", function() {
    beforeEach(function() {
      s1 = new window.beats.Sensor();
      s1.set_crud(window.beats.CrudFlag.CREATE);
      s2 = new window.beats.Sensor();
      s2.set_crud(window.beats.CrudFlag.DELETE);
      s.set_sensors([s1, s2]);
      s.set_mod_stamp("01/01/01");
      s.set_crud(window.beats.CrudFlag.UPDATE);
    });
    msg = "should remove crud flags, mod stamp and deleted elements ";
    msg += "and then replace them";
    it(msg, function(){   
      doc = document.implementation.createDocument(null, null, null)
      xml = s.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/<sensor>/g).length).toEqual(1);
      expect(xmlS.match(/mod_stamp/g)).toBeNull();
      expect(xmlS.match(/crudFlag/g)).toBeNull();
      expect(s.sensors().length).toEqual(2);
      expect(s.mod_stamp()).toEqual("01/01/01");
      expect(s.crud()).toEqual(window.beats.CrudFlag.UPDATE);
    });
    msg = "should keep all crudFlags, mod_stamps and deleted elements when";
    msg += " saving to db";
    it(msg, function(){
      window.beats.fileSaveMode = false;
      doc = document.implementation.createDocument(null, null, null)
      xml = s.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/<\/sensor>/g).length).toEqual(2);
      expect(xmlS.match(/mod_stamp/g)).not.toBeNull();
      expect(xmlS.match(/crudFlag=\"UPDATE\"/g).length).toEqual(1);
      window.beats.fileSaveMode = true;
    });
  });
});
