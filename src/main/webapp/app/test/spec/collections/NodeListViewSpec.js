describe("NodeListView", function() {
  $a = window.beats;
  var models;
  var network;
  
  beforeEach(function() {
    loadFixtures('context.menu.view.fixture.html');
    googleMap();
    network = scenarioAndFriends().scenario.network();
    models = scenarioAndFriends().scenario.nodes();
    spyOn($a.NodeListView.prototype, 'addNodeView').andCallThrough();
    spyOn($a.NodeListView.prototype, 'render').andCallThrough();
    spyOn($a.NodeListView.prototype, 'removeNode').andCallThrough();
  
    this.nCollect = new $a.NodeListCollection(models);
    this.view = new $a.NodeListView(this.nCollect, network);
  });
  
  describe("Instantiation", function() {
    it("sets all its collection and network attributes", function() {
      expect(this.view.collection).not.toBeNull();
      expect(this.view.network).not.toBeNull();
    });
    
    it("should be watching addNodeView", function() {
      this.nCollect.addNode(new google.maps.LatLng(37,-122));
      expect($a.NodeListView.prototype.addNodeView).toHaveBeenCalled();
    });
    
    it("should be watching render", function() {
      $a.broker.trigger('map:init')
      expect($a.NodeListView.prototype.render).toHaveBeenCalled();
    });
    
    it("should be watching removeNode", function() {
      this.nCollect.trigger('remove', models[0]);
      expect($a.NodeListView.prototype.removeNode).toHaveBeenCalled();
    });
  });

  describe("Rendering", function() {
    it("should create MapNodeViews for each Node model", function() {
      this.view.views = [];
      this.view.render();
      expect(this.view.collection.length).toEqual(this.view.views.length);
    });
  });
  
  describe("addNodeView", function() {
    it("should create a MapNodeView for a Node model", function() {
      this.view.addNodeView(models[0]);
      expect(this.view.mnv).not.toBeNull();
    });
  });
  
  describe("removeNode", function() {
    it("should remove the MapNodeView from views array", function() {
      var lengthBefore = this.view.views.length;
      this.view.removeNode(models[1]);
      expect(this.view.views.length).toEqual(lengthBefore - 1);
    });
  });
});