describe("Sensor", function() {

  beforeEach(function() {
    window.beats.sensorList = new window.beats.SensorListCollection(window.beats.models.sensors())
    s = new window.beats.Sensor; 
    pt = new window.beats.Point()
    pt.set('lat',0)
    pt.set('lng',0)
    pt.set('elevation', '')
    p = new window.beats.Position()
    p.get('point').push(pt)
    s.set('display_position', p)
  });

  describe("add", function() {
    var msg = "should add the sensor to the models schema and update the ";
    msg += "SensorSet crud flag";
    it(msg, function() {
      var lengthBefore = $a.models.sensors().length;
      s.add();
      expect(lengthBefore + 1).toEqual($a.models.sensors().length);
      expect(s.crud()).toEqual(window.beats.CrudFlag.CREATE);
      var crud = window.beats.models.sensor_set().crud();
      if(crud == window.beats.CrudFlag.CREATE)
        expect(crud).toEqual(window.beats.CrudFlag.CREATE);
      else
        expect(crud).toEqual(window.beats.CrudFlag.UPDATE);
    });
    it("should add on id to the sensor", function() {
      s.add();
      s.set_id()
    });
  });
  describe("remove", function() {
    var msg = "should ONLY remove the sensor from he models schema because the ";
    msg += "sensor was created and never saved to the database";
    it(msg, function() {
      s.add();
      var lengthBefore = $a.models.sensors().length;
      s.remove();
      expect(s.crud()).toEqual(window.beats.CrudFlag.CREATE);
      expect(lengthBefore - 1).toEqual($a.models.sensors().length);
    });
    
    msg = "should remove the sensor from he models schema and update the ";
    msg += "SensorSet crud flag";
    it(msg, function() {
      s.add();
      s.set('crudFlag', window.beats.CrudFlag.NONE); //assume loaded from db
      s.remove();
      expect(s.crud()).toEqual(window.beats.CrudFlag.DELETE);
      var crud = window.beats.models.sensor_set().crud();
      if(crud == window.beats.CrudFlag.CREATE)
        expect(crud).toEqual(window.beats.CrudFlag.CREATE);
      else
        expect(crud).toEqual(window.beats.CrudFlag.UPDATE);
    });
  });  
  describe("updatePosition", function() {
    it("should change the sensor's position", function() {
      var latLng = new google.maps.LatLng(37.83999, -122.29681);
      s.updatePosition(latLng);
      expect(s.display_lat()).toEqual(latLng.lat());
      expect(s.display_lng()).toEqual(latLng.lng());
    });
  });
  describe("set_display_position", function() {
    it("should set the display poistion", function() {
      s.set_display_position('lat', 99);
      expect(s.display_lat()).toEqual(99);
      s.set_display_position('lng', 98);
      expect(s.display_lng()).toEqual(98);
      s.set_display_position('elevation', 97);
      expect(s.display_elev()).toEqual(97);
    });
  });
  describe("point", function() {
    it("should return the display position's point", function() {
      expect(s.point()).toEqual(pt);
    });
    describe("when no point is define", function() {
      it("should return a point object with default lat/lng", function() {
        s.get('display_position').set('point',[])
        expect(s.point().lat()).toEqual(0);
      });
    });
  });
  
   describe("to_xml", function() {
    beforeEach(function() {
      s.set_mod_stamp("01/01/01");
      s.set_crud(window.beats.CrudFlag.UPDATE);
    });
    msg = "should remove crud flags and mod stamp";
    msg += "and then replace them";
    it(msg, function(){   
      doc = document.implementation.createDocument(null, null, null)
      xml = s.to_xml(doc);
      xmlS = new XMLSerializer().serializeToString(xml)
      expect(xmlS.match(/mod_stamp/g)).toBeNull();
      expect(xmlS.match(/crudFlag/g)).toBeNull();
      expect(s.mod_stamp()).toEqual("01/01/01");
      expect(s.crud()).toEqual(window.beats.CrudFlag.UPDATE);
    });
  });
});