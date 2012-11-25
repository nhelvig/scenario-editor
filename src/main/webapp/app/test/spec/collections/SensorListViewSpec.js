describe("SensorListView", function() {
  $a = window.beats;
  var models;
  var network;
  
  beforeEach(function() {
    loadFixtures('context.menu.view.fixture.html');
    network = $a.models.network();
    models = $a.models.sensors();
    spyOn($a.SensorListView.prototype, 'addSensorView').andCallThrough();
    spyOn($a.SensorListView.prototype, 'render').andCallThrough();
    spyOn($a.SensorListView.prototype, 'removeSensor').andCallThrough();
   
    this.sCollect = new $a.SensorListCollection(models);
    this.view = new $a.SensorListView(this.sCollect, network);
    
  });
  
  describe("Instantiation", function() {
    it("sets all its collection and network attributes", function() {
      expect(this.view.collection).not.toBeNull();
      expect(this.view.network).not.toBeNull();
    });
    
    it("should be watching addSensorView", function() {
      this.sCollect.addSensor(new google.maps.LatLng(37,-122));
      expect($a.SensorListView.prototype.addSensorView).toHaveBeenCalled();
    });
    
    it("should be watching render", function() {
      $a.broker.trigger('map:init')
      expect($a.SensorListView.prototype.render).toHaveBeenCalled();
    });
    
    it("should be watching removeSensor", function() {
      this.sCollect.trigger('remove', models[0]);
      expect($a.SensorListView.prototype.removeSensor).toHaveBeenCalled();
    });
  });

  describe("Rendering", function() {
    it("should create MapSensorViews for each Sensor model", function() {
      this.view.views = [];
      this.view.render();
      expect(this.view.collection.length).toEqual(this.view.views.length);
    });
  });
  
  describe("addSensorView", function() {
    it("should create a MapSensorView for a Sensor model", function() {
      this.view.addSensorView(models[0]);
      expect(this.view.msv).not.toBeNull();
    });
  });
  
  describe("removeSensor", function() {
    it("should remove the MapSensorView from views array", function() {
      var lengthBefore = this.view.views.length;
      this.view.removeSensor(models[1]);
      expect(this.view.views.length).toEqual(lengthBefore - 1);
    });
  });
});