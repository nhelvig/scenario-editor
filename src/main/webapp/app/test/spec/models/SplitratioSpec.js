describe("Splitratio", function() {
  
  beforeEach(function() {
    s = new window.beats.Splitratio;
    s.set_mod_stamp("01/01/01");
    s.set_crud(window.beats.CrudFlag.UPDATE,0);
    s.set_split_ratio(0.2,0);

  });
  
  describe("to_xml", function() {
    msg = "should remove crud flags and mod stamp";
    msg += "and then replace them";
    it(msg, function(){   
      doc = document.implementation.createDocument(null, null, null)
      xml = s.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/mod_stamp/g)).toBeNull();
      expect(xmlS.match(/crudFlag/g)).toBeNull();
      expect(s.mod_stamp()).toEqual("01/01/01");
      expect(s.crud(0)).toEqual(window.beats.CrudFlag.UPDATE);
    });
  });
});