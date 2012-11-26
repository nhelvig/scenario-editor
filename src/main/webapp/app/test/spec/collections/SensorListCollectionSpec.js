describe("SensorListCollection", function() {
  $a = window.beats;
  var models;
  
  beforeEach(function() {
    spyOn($a.SensorListCollection.prototype, 'addSensor').andCallThrough();
    spyOn($a.SensorListCollection.prototype, 'removeSensor').andCallThrough();
    models = $a.models.sensors();
    this.sColl= new $a.SensorListCollection(models);
  });
  
  describe("Instantiation", function() {
    it("sets models to a collection of sensors", function() {
      expect(this.sColl.models).not.toBeNull();
    });
    
    it("sets all its models selected attribute to false", function() {
      mod = this.sColl.models;
      arrSel = mod.filter(function(sens){ return sens.selected() == false});
      expect(arrSel.length).toEqual(this.sColl.length);
    });
    it("should be watching addSensor", function() {
      $a.broker.trigger("sensors:add", new google.maps.LatLng(37,-122));
      expect($a.SensorListCollection.prototype.addSensor).toHaveBeenCalled();
    });
    it("should be watching removeSensor", function() {
      this.sColl.trigger("sensors:remove", 1);
      expect($a.SensorListCollection.prototype.removeSensor).toHaveBeenCalled();
    });
  });
  
   describe("getBrowserColumnData", function() {
     var desc = "should return id, type, link type, and link id for ";
     desc += "editor browser table";
     it(desc, function() {
       arrColumnsData = this.sColl.getBrowserColumnData();
       s = this.sColl.models[0];
       expect(arrColumnsData[0][0]).toEqual(s.ident());
       expect(arrColumnsData[0][1]).toEqual(s.type());
       expect(arrColumnsData[0][2]).toEqual(s.link().type());
       expect(arrColumnsData[0][3]).toEqual(s.link().ident());
     });
   });

  describe("setSelected ", function() {
    it("should sets the select field to true", function() {
      mod = this.sColl.models;
      this.sColl.setSelected(mod);
      arrSel = mod.filter(function(sens){ return sens.selected() == true});
      expect(arrSel.length).toEqual(this.sColl.length);
    });
  });
  
  describe("addSensor ", function() {
    it("should create a new sensor and add it to the collection", function() {
     var lengthBefore = this.sColl.length;
     this.sColl.addSensor(new google.maps.LatLng(37,-122));
     expect(lengthBefore + 1).toEqual(this.sColl.length);
    });
    it("should create a new sensor and add it to the models schema", function() {
     var lengthBefore = $a.models.sensors().length;
     this.sColl.addSensor(new google.maps.LatLng(37,-122));
     expect(lengthBefore + 1).toEqual($a.models.sensors().length);
    });
  });
  describe("removeSensor ", function() {
    it("should remove it from collection and schema", function() {
     sensor = scenarioAndFriends().sensor
     this.sColl.add(sensor)
     var lengthBefore = this.sColl.length;
     this.sColl.removeSensor(sensor.cid);
     expect(lengthBefore - 1).toEqual(this.sColl.length);
    });
  });
});