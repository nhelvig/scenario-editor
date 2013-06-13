describe("MapNodeView", function() {
  var $s = window.beats;
  var network, model;

  beforeEach(function() {
    loadFixtures('context.menu.view.fixture.html');
    network = $a.models.get('networkset').get('network')[0];
    model = network.get('nodelist').get('node')[0];
    
    spyOn($s.MapNodeView.prototype, 'selectLink').andCallThrough();
    spyOn($s.MapNodeView.prototype, 'selectMyInLinks').andCallThrough();
    spyOn($s.MapNodeView.prototype, 'selectMyOutLinks').andCallThrough();
    spyOn($s.MapNodeView.prototype, 'selectSelfandMyLinks').andCallThrough();
    this.view = new $a.MapNodeView(model, network);
  });

  afterEach(function() {
    this.view.remove();
  });

  describe("Rendering", function() {
    it("should return the view object", function() {
      expect(this.view.render()).toEqual(this.view);
    });
  });

  describe("Event response", function() {
   it("should handle select all connected links", function() {
     $s.broker.trigger("map:select_neighbors:" + model.cid);
     expect($s.MapNodeView.prototype.selectSelfandMyLinks).toHaveBeenCalled();
     expect($s.MapNodeView.prototype.selectLink).toHaveBeenCalled();
     expect($s.MapNodeView.prototype.selectLink.calls.length).toEqual(3);
   });

   it("should handle select all incoming links", function() {
     $s.broker.trigger("map:select_neighbors_in:" + model.cid);
     expect($s.MapNodeView.prototype.selectMyInLinks).toHaveBeenCalled();
     expect($s.MapNodeView.prototype.selectLink).toHaveBeenCalled();
     expect($s.MapNodeView.prototype.selectLink.calls.length).toEqual(1);
   });
       
   it("should handle select all outgoing links", function() {
     $s.broker.trigger("map:select_neighbors_out:" + model.cid);
     expect($s.MapNodeView.prototype.selectMyOutLinks).toHaveBeenCalled();
     expect($s.MapNodeView.prototype.selectLink).toHaveBeenCalled();
     expect($s.MapNodeView.prototype.selectLink.calls.length).toEqual(2);
   });
  });
});