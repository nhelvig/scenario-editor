describe("Demand", function() {
  
  beforeEach(function() {
    d = new window.beats.Demand;
    d.set_mod_stamp("01/01/01");
    d.set_demand(100, 0);
    d.set_demand(200, 1);
    d.set_demand(300, 2);
    d.set_demand(400, 3);
    d.set_crud(window.beats.CrudFlag.DELETE, 0);
    d.set_crud(window.beats.CrudFlag.NONE, 1);
    d.set_crud(window.beats.CrudFlag.UPDATE, 2);
    d.set_crud(window.beats.CrudFlag.DELETE, 3);
  });
  
  describe("remove_deleted_vals", function() {
    msg = "should remove values from text string that are deleted"
    it(msg, function(){
      
      keep = d.remove_deleted_vals();
      expect(keep.split(",").length).toEqual(2);
    });
  });
  
  describe("to_xml", function() {
    msg = "should remove crud flags and mod stamp ";
    msg += "and then replace them as well as remove ";
    msg += "deleted values from the text string";
    it(msg, function(){
      window.beats.fileSaveMode = true;
      doc = document.implementation.createDocument(null, null, null)
      xml = d.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/mod_stamp/g)).toBeNull();
      expect(xmlS.match(/crudFlags/g)).toBeNull();
      expect(d.mod_stamp()).toEqual("01/01/01");
      expect(d.crud(0)).toEqual(window.beats.CrudFlag.DELETE);
    });
  });
});