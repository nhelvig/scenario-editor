describe("Demand", function() {
  
  beforeEach(function() {
    d = new window.beats.Demand;
    d.set_mod_stamp("01/01/01");
    d.set_crud(window.beats.CrudFlag.UPDATE);
  });
  
  describe("to_xml", function() {
    msg = "should remove crud flags and mod stamp";
    msg += "and then replace them";
    it(msg, function(){
      window.beats.fileSaveMode = true;
      doc = document.implementation.createDocument(null, null, null)
      xml = d.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/mod_stamp/g)).toBeNull();
      expect(xmlS.match(/crudFlags/g)).toBeNull();
      expect(d.mod_stamp()).toEqual("01/01/01");
      expect(d.crud(0)).toEqual(window.beats.CrudFlag.UPDATE);
    });
  });
});