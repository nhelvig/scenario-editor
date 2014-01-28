describe("SensorListCollection", function() {
  $a = window.beats;
    var models;
    
    beforeEach(function() {
      spyOn($a.SensorListCollection.prototype, 'clear').andCallThrough();
      spyOn($a.SensorListCollection.prototype, 'clearSelected').andCallThrough();
      spyOn($a.SensorListCollection.prototype, 'addSensorWithPositionLink').andCallThrough();
      spyOn($a.SensorListCollection.prototype, 'addSensor').andCallThrough();
      spyOn($a.SensorListCollection.prototype, 'attachToLink').andCallThrough();
      spyOn($a.SensorListCollection.prototype, 'removeSensor').andCallThrough();
      models = scenarioAndFriends().scenario.sensors()
      $a.linkList = new $a.LinkListCollection(scenarioAndFriends().scenario.links());
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

      it("should be watching addSensorWithPositionLink", function() {
        $a.broker.trigger("sensors:add", new google.maps.LatLng(37,-122));
        expect($a.SensorListCollection.prototype.addSensorWithPositionLink).toHaveBeenCalled();
      });
      it("should be watching addSensor", function() {
        s = new $a.Sensor();
        s.updatePosition(new google.maps.LatLng(37,-122));
        $a.broker.trigger("sensors:add_sensor", s);
        expect($a.SensorListCollection.prototype.addSensor).toHaveBeenCalled();
      });
      it("should be watching removeSensor", function() {
        this.sColl.trigger("sensors:remove", 1);
        expect($a.SensorListCollection.prototype.removeSensor).toHaveBeenCalled();
      });

      it("should be watching clearSelected", function() {
         $a.broker.trigger('map:clear_selected');
         expect($a.SensorListCollection.prototype.clearSelected).toHaveBeenCalled();
      });
      it("should be watching attachToLink", function() {
        this.sColl.trigger('sensors:attach_to_link');
        expect($a.SensorListCollection.prototype.attachToLink).toHaveBeenCalled();
      });
    });
    
     describe("getBrowserColumnData", function() {
       var desc = "should return id, type, link type, and link id for ";
       desc += "editor browser table";
       it(desc, function() {
         arrColumnsData = this.sColl.getBrowserColumnData();
         s = this.sColl.models[0];
         expect(arrColumnsData[0][0]).toEqual(s.ident());
         expect(arrColumnsData[0][1]).toEqual(s.type_name());
         link = s.link_reference();
         expect(arrColumnsData[0][2]).toEqual(link.link_type().name());
         expect(arrColumnsData[0][3]).toEqual(link.ident());
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
    
    describe("addSensorWithPositionLink", function() {
      it("should create a new sensor and add it to the collection", function() {
       var lengthBefore = this.sColl.length;
       this.sColl.addSensorWithPositionLink(new google.maps.LatLng(37,-122));
       expect(lengthBefore + 1).toEqual(this.sColl.length);
      });
      it("should create a new sensor and add it to the models schema", function() {
       var lengthBefore = $a.models.sensors().length;
       this.sColl.addSensorWithPositionLink(new google.maps.LatLng(37,-122));
       expect(lengthBefore + 1).toEqual($a.models.sensors().length);
      });
    });
    
    describe("addSensor", function() {
      it("should create a new sensor and add it to the collection", function() {
       var lengthBefore = this.sColl.length;
       var s = new $a.Sensor();
       s.updatePosition(new google.maps.LatLng(37,-122));
       this.sColl.addSensor(s);
       expect(lengthBefore + 1).toEqual(this.sColl.length);
      });
      it("should create a new sensor and add it to the models schema", function() {
       var lengthBefore = $a.models.sensors().length;
       var s = new $a.Sensor();
       s.updatePosition(new google.maps.LatLng(37,-122));
       this.sColl.addSensor(s);
       expect(lengthBefore + 1).toEqual($a.models.sensors().length);
      });
    });
    
    describe("removeSensor ", function() {
      it("should remove it from collection and schema", function() {
       sensor = new $a.Sensor();
       this.sColl.add(sensor)
       var lengthBefore = this.sColl.length;
       this.sColl.removeSensor(sensor.cid);
       expect(lengthBefore - 1).toEqual(this.sColl.length);
      });
    });
    describe("attachToLink", function() {
       it("should attach selected link to sensor", function() {
         s = this.sColl.models[0]
         link = $a.linkList.models[0];
         link.set_selected(true);
         this.sColl.attachToLink(s.cid)
         expect(s.link_reference()).toEqual(link);
         expect(s.link_id()).toEqual(link.id);
      });
    });
    describe("_updateSensor", function(){
      msg = "should set crud flags to UPDATE for the sensor and sensorset";
      it(msg, function() {
         s = this.sColl.models[0]
         this.sColl._updateSensor(s)
         crud = $a.CrudFlag.UPDATE
         expect(s.crud()).toEqual(crud);
         expect($a.models.sensor_set().crud()).toEqual(crud);
      });
    });
    describe("clearSelected", function(){
      msg = "should clear all sensors selected attribute";
      it(msg, function() {
         s = this.sColl.models[0].set_selected(true);
         this.sColl.clearSelected();
         trues = _.filter(this.sColl.models, function(model){ 
            return model.selected() === true; 
         });
         expect(trues.length).toEqual(0);
      });
    });
    describe("clear", function(){
      msg = "should clear the sensors from the map and turn off events";
      it(msg, function() {
        $a.broker.trigger('map:clear_map');
        expect($a.SensorListCollection.prototype.clear).toHaveBeenCalled();
        expect(this.sColl.models.length).toEqual(0);
        expect($a.sensorList).toEqual({});
        this.sColl.clear();
       
        $a.broker.trigger("sensors:add", new google.maps.LatLng(37,-122));
        $a.broker.trigger("sensors:add_sensor", s);
        $a.broker.trigger("map:clear_map");
        $a.broker.trigger('map:clear_selected');
        this.sColl.trigger("sensors:remove", 1);
        this.sColl.trigger('sensors:attach_to_link');
  
        expect($a.SensorListCollection.prototype.addSensor).not.toHaveBeenCalled();
        expect($a.SensorListCollection.prototype.addSensorWithPositionLink).not.toHaveBeenCalled();
        expect($a.SensorListCollection.prototype.removeSensor).not.toHaveBeenCalled();
        expect($a.SensorListCollection.prototype.attachToLink).not.toHaveBeenCalled();
      });
    });
});