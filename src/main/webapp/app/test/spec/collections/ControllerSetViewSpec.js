describe("ControllerSetView", function() {
  $a = window.beats;
  var models;
  var network, cCollect, view;
  
  beforeEach(function() {
    loadFixtures('context.menu.view.fixture.html');
    sc = scenarioAndFriends()
    models = sc.scenario.controllers(); 
    spyOn($a.ControllerSetView.prototype, 'addControllerView').andCallThrough();
    spyOn($a.ControllerSetView.prototype, 'render').andCallThrough();
    spyOn($a.ControllerSetView.prototype, 'removeController').andCallThrough();
   
    cCollect = new $a.ControllerSetCollection(models);
    view = new $a.ControllerSetView(cCollect);
    
  });
  
  describe("Instantiation", function() {
    it("sets its collection attributes", function() {
      expect(view.collection).not.toBeNull();
    });
    
    it("should be watching addControllerView", function() {
      cCollect.addController(new google.maps.LatLng(37,-122));
      expect($a.ControllerSetView.prototype.addControllerView).toHaveBeenCalled();
    });
    
    it("should be watching render", function() {
      $a.broker.trigger('map:init')
      expect($a.ControllerSetView.prototype.render).toHaveBeenCalled();
    });
    
    it("should be watching removeController", function() {
      cCollect.trigger('remove', sc.controller);
      expect($a.ControllerSetView.prototype.removeController).toHaveBeenCalled();
    });
  });

  describe("Rendering", function() {
    it("should create MapControllerViews for each Controller model", function() {
      view.views = [];
      view.render();
      expect(view.collection.length).toEqual(view.views.length);
    });
  });
  
  describe("addControllerView", function() {
    it("should create a MapControllerView for a Controller model", function() {
      view.addControllerView(sc.controller);
      expect(view.msv).not.toBeNull();
    });
  });
  
  describe("removeController", function() {
    it("should remove the MapControllerView from views array", function() {
      view.addControllerView(sc.controller);
      var lengthBefore = view.views.length;
      view.removeController(sc.controller);
      expect(view.views.length).toEqual(lengthBefore - 1);
    });
  });
});