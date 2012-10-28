describe("SensorListCollection", function() {
  $a = window.sirius;
  var models, network, begin, end;
  
  beforeEach(function() {
    network = $a.scenario.get('networklist').get('network')[0];
    models = network.get('sensorlist').get('sensor');
    this.sColl= new $a.SensorListCollection(models);
  });
  
  describe("Instantiation", function() {
    it("sets models to a collection of sensors", function() {
      expect(this.sColl.models).not.toBeNull();
    });
    
   it("sets all its models selected attribute to false", function() {
      mod = this.sColl.models;
      arrSel = mod.filter(function(sens){ return sens.get('selected') == false});
      expect(arrSel.length).toEqual(this.sColl.length);
    });
  });
  
   describe("getBrowserColumnData", function() {
     var desc = "should return id, type, link_reference, description for ";
     desc += "editor browser table";
     it(desc, function() {
       arrColumnsData = this.sColl.getBrowserColumnData();
       sColl = this.sColl.models[0];
       expect(arrColumnsData[0][0]).toEqual(sColl.get('id'));
       expect(arrColumnsData[0][1]).toEqual(sColl.get('type'));
       expect(arrColumnsData[0][2]).toEqual(sColl.get('link_reference').get('id'));
       expect(arrColumnsData[0][6]).toEqual(sColl.get('description').get('text'));
     });
   });
  
  describe("setSelected ", function() {
    it("should sets the select field to true", function() {
      mod = this.sColl.models;
      this.sColl.setSelected(mod);
      arrSel = mod.filter(function(sens){ return sens.get('selected') == true});
      expect(arrSel.length).toEqual(this.sColl.length);
    });
  });
});