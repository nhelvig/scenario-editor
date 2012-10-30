describe("LinkListView", function() {
  $a = window.sirius;
  var models, network, begin, end;
  
  beforeEach(function() {
    loadFixtures('context.menu.view.fixture.html');
    network = $a.scenario.get('networklist').get('network')[0];
    models = network.get('linklist').get('link');
    spyOn($a.LinkListView.prototype, 'addAndRender').andCallThrough();
    spyOn($a.LinkListView.prototype, 'createAndDrawLink').andCallThrough();
    spyOn($a.LinkListView.prototype, 'removeLink').andCallThrough();
    
    this.lColl = new $a.LinkListCollection(models);
    this.view = new $a.LinkListView(this.lColl, network);
    begin = models[0].get('begin');
    end = models[0].get('end');
  });
    
  describe("Instantiation", function() {
    it("sets all its collection and network attributes", function() {
      expect(this.view.collection).not.toBeNull();
      expect(this.view.network).not.toBeNull();
    });
    
    it("should be watching addAndRender", function() {
      this.lColl.addLink({begin:begin,end:end});
      expect($a.LinkListView.prototype.addAndRender).toHaveBeenCalled();
    });
  
    it("should be watching createAndDrawLink", function() {
      $a.broker.trigger('map:draw_link', models[0]);
      expect($a.LinkListView.prototype.createAndDrawLink).toHaveBeenCalled();
    });
    
    it("should be watching removeLink", function() {
      this.lColl.trigger('remove', models[0]);
      expect($a.LinkListView.prototype.removeLink).toHaveBeenCalled();
    });
    
    it("should call getLinkGeometry, create GoogleRouteHandler", function() {
      expect(this.view.routeHandler).not.toBeNull();
    });
  });
   
  describe("createAndDrawLink", function() {
    it("should create MapLinkViews for link", function() {
      mlv = this.view.createAndDrawLink(models[0]);
      expect(mlv).not.toBeNull();
      expect(mlv.link.getMap()).toEqual($a.map);
    });
  });
    
  describe("addAndRender", function() {
    it("should create a MapNodeView and render it", function() {
      link = this.view.addAndRender(models[0], true);
      expect(link.get('linkgeometry')).not.toBeNull();
    });
  });
  
  describe("removeLink", function() {
    it("should remove the MapLinkView from views array", function() {
      var lengthBefore = this.view.views.length;
      this.view.removeLink(models[0]);
      expect(this.view.views.length).toEqual(lengthBefore - 2);
    });
  });
});