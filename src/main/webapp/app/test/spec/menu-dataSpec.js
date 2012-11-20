describe("menu-data", function() {
  $a = window.beats;
  
  beforeEach(function() {
    spyOn($a.NodeListCollection.prototype, 'addNode').andCallThrough();
    
    network = $a.models.get('networklist').get('network')[0];
    models = network.get('nodelist').get('node');
    $a.nodeList = new $a.NodeListCollection(models);
    loadFixtures('main.canvas.view.fixture.html');
    new $a.AppView().render();
    
    $a.contextMenu = new $a.ContextMenuView({});
    $a.contextMenu.position = new google.maps.LatLng(37,-122);
  });
  
  describe("Main Context Menu Events", function() {
    it("should trigger zoom in for 'Zoom in'", function() {  
      var newZoom = $a.map.zoom + 1;
      ($a.main_context_menu[0].event)();
      expect(newZoom).toEqual($a.map.zoom);
    });
    it("should trigger zoom out for 'Zoom out'", function() {  
      var newZoom = $a.map.zoom - 1;
      ($a.main_context_menu[1].event)();
      expect(newZoom).toEqual($a.map.zoom);
    });
    it("should trigger pan for 'Center Map Here'", function() {  
      ($a.main_context_menu[3].event)();
      var pos = $a.contextMenu.position;
      expect(Math.floor($a.map.center.lat())).toEqual(pos.lat());
    });
  });
});