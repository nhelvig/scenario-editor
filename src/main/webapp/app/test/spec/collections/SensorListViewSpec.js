describe("SensorListView", function() {
  $a = window.beats;
  var models;
  var network;
  
  beforeEach(function() {
    loadFixtures('context.menu.view.fixture.html');
    network = $a.models.network();
    spyOn($a.SensorListView.prototype,'addSensorView').andCallThrough();
    spyOn($a.SensorListView.prototype,'render').andCallThrough();
    spyOn($a.SensorListView.prototype,'removeSensor').andCallThrough();
    spyOn($a.SensorListView.prototype,'clear').andCallThrough();
    spyOn($a.SensorListView.prototype,'selectSelfAndConnected').andCallThrough();
    spyOn($a.SensorListView.prototype,'clearSelfAndConnected').andCallThrough();
    scen = scenarioAndFriends();
    sA = [scen.sensor1, scen.sensor2, scen.sensor3, scen.sensor4]
    this.sCollect = new $a.SensorListCollection(sA);
    $a.models = scen.scenario
    this.view = new $a.SensorListView(this.sCollect, network);
    googleMap();
  });
  
  describe("Instantiation", function() {
      it("sets all its collection and network attributes", function() {
        expect(this.view.collection).not.toBeNull();
        expect(this.view.network).not.toBeNull();
      });
      
      it("should be watching addSensorView", function() {
        this.sCollect.addSensor(scen.sensor);
        expect($a.SensorListView.prototype.addSensorView).toHaveBeenCalled();
      });
      
      it("should be watching render", function() {
        $a.broker.trigger('map:init')
        expect($a.SensorListView.prototype.render).toHaveBeenCalled();
      });
      it("should be watching clear", function() {
        $a.broker.trigger('map:clear_map');
        expect($a.SensorListView.prototype.clear).toHaveBeenCalled();
      });    
    
      it("should be watching removeSensor", function() {
        this.sCollect.trigger('remove', scen.sensor1);
        expect($a.SensorListView.prototype.removeSensor).toHaveBeenCalled();
      });
      it("should be watching selectSelfAndConnected", function() {
        cid = this.view.views[0].model.cid
        this.view.trigger('sensors:selectSelfAndConnected', cid);
        expect($a.SensorListView.prototype.selectSelfAndConnected).toHaveBeenCalled();
      });
      it("should be watching clearSelfAndConnected", function() {
        cid = this.view.views[0].model.cid
        this.view.trigger('sensors:clearSelfAndConnected', cid);
        expect($a.SensorListView.prototype.clearSelfAndConnected).toHaveBeenCalled();
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
        this.view.addSensorView(this.sCollect.models[0]);
        expect(this.view.msv).not.toBeNull();
      });
    });
    
    describe("removeSensor", function() {
      it("should remove the MapSensorView from views array", function() {
        var lengthBefore = this.view.views.length;
        this.view.removeSensor(scen.sensor2);
        expect(this.view.views.length).toEqual(lengthBefore - 1);
      });
    });
    
    describe("clear", function(){
      msg = "should turn off events and empty the sensorListView";
      it(msg, function() {
        this.view.clear();
        expect($a.sensorListView).toEqual({});
        $a.SensorListView.prototype.clear.reset();
        $a.SensorListView.prototype.addSensorView.reset();
        $a.SensorListView.prototype.render.reset();
        $a.SensorListView.prototype.removeSensor.reset();
        $a.broker.trigger('map:init');
        $a.broker.trigger('map:clear_map');
        this.sCollect.trigger('remove', scen.sensor1);
        this.sCollect.trigger('add', scen.sensor1);
        this.view.trigger('sensors:selectSelfAndConnected', "c123");
        this.view.trigger('sensors:clearSelfAndConnected', "c123");
       
        expect($a.SensorListView.prototype.addSensorView).not.toHaveBeenCalled();
        expect($a.SensorListView.prototype.render).not.toHaveBeenCalled();
        expect($a.SensorListView.prototype.removeSensor).not.toHaveBeenCalled();
        expect($a.SensorListView.prototype.clear).not.toHaveBeenCalled();
        expect($a.SensorListView.prototype.selectSelfAndConnected).not.toHaveBeenCalled();
        expect($a.SensorListView.prototype.clearSelfAndConnected).not.toHaveBeenCalled();
      });
    });
    
    describe("selectSelfAndConnected", function(){
      msg = "should have its model and connected links selected field set true";
      it(msg, function() {
        model = this.view.views[0].model;
        cid = model.cid
        before = model.selected();
        linkBefore = model.link_reference().selected(); 
        this.view.selectSelfAndConnected(cid);
        after = model.selected();
        linkAfter = model.link_reference().selected(); 
        
        expect(before).toBeFalsy();
        expect(after).toBeTruthy();
        expect(linkBefore).toBeFalsy();
        expect(linkAfter).toBeTruthy();   
      });
    });
    describe("clearSelfAndConnected", function(){
      msg = "should have its model and connected links selected field set false";
      it(msg, function() {
        model = this.view.views[0].model;
        cid = model.cid
        model.set_selected(true);
        linkBefore = model.link_reference().set_selected(true); 
        this.view.clearSelfAndConnected(cid);
        after = model.selected();
        linkAfter = model.link_reference().selected(); 
        
        expect(after).toBeFalsy();
        expect(linkAfter).toBeFalsy();   
      });
    });

});