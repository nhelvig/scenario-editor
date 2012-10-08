describe("NodeListView", function() {
  $a = window.sirius;
  var models;
  var network;
  
  beforeEach(function() {
    loadFixtures('context.menu.view.fixture.html');
    network = $a.scenario.get('networklist').get('network')[0];
    models = network.get('nodelist').get('node');
    spyOn($a.NodeListView.prototype, 'addAndRender').andCallThrough();
    
    this.nCollect = new $a.NodeListCollection(models);
    this.view = new $a.NodeListView(this.nCollect, network);
  });
  
  describe("Instantiation", function() {
    it("sets all its collection and network attributes", function() {
      expect(this.view.collection).not.toBeNull();
      expect(this.view.network).not.toBeNull();
    });
    
    it("should be watching addAndRender", function() {
      $a.contextMenu.position = new google.maps.LatLng(37,-122);
      this.nCollect.addOne();
      expect($a.NodeListView.prototype.addAndRender).toHaveBeenCalled();
    });
  });

  describe("Rendering", function() {
    it("should create MapNodeViews for each Node model", function() {
      this.view.views = [];
      this.view.render();
      expect(this.view.collection.length).toEqual(this.view.views.length);
    });
  });
  
  describe("addOne", function() {
    it("should create a MapNodeView for a Node model", function() {
      this.view.addOne(models[0]);
      expect(this.view.mnv).not.toBeNull();
    });
  });
  
  describe("addAndRender", function() {
    it("should create a MapNodeView and render it", function() {
      mnv = this.view.addAndRender(models[0]);
      expect(mnv.marker.getMap()).toEqual($a.map);
    });
  });
});