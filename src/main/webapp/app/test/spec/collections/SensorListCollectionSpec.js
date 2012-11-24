describe("SensorListCollection", function() {
  $a = window.beats;
  var models, network, begin, end;
  
  beforeEach(function() {
    spyOn($a.SensorListCollection.prototype, 'addSensor').andCallThrough();
    models = $a.models.sensors();
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
    it("should be watching addSensor", function() {
      this.sColl.trigger("sensors:add", new google.maps.LatLng(37,-122));
      expect($a.SensorListCollection.prototype.addSensor).toHaveBeenCalled();
    });
  });
  
   describe("getBrowserColumnData", function() {
     var desc = "should return id, type, link_reference, description for ";
     desc += "editor browser table";
     it(desc, function() {
       arrColumnsData = this.sColl.getBrowserColumnData();
       s = this.sColl.models[0];
       expect(arrColumnsData[0][0]).toEqual(s.get('id'));
       expect(arrColumnsData[0][1]).toEqual(s.get('type'));
       expect(arrColumnsData[0][2]).toEqual(s.get('link_type'));
       expect(arrColumnsData[0][3]).toEqual(s.get('link_reference').get('id'));
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