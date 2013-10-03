describe("menu-data", function() {
  $a = window.beats;
  
  beforeEach(function() {
    googleMap();
    spyOn($a.NodeListCollection.prototype, 'addNode').andCallThrough();
    models = $a.models.nodes();
    $a.nodeList = new $a.NodeListCollection(models);   
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
      $a.contextMenu = new $a.ContextMenuView({});
      $a.contextMenu.position = new google.maps.LatLng(37,-122);

      ($a.main_context_menu[3].event)();
      var pos = $a.contextMenu.position;
      expect(Math.floor($a.map.center.lat())).toEqual(pos.lat());
    });
  });
  describe("Main Context Menu Events", function() {
    it("should contain 9 items", function() {
      expect($a.main_context_menu.length).toEqual(9);
    });
  });
  describe("Link Context Menu Events", function() {
    it("should contain 14 items", function() {
      expect($a.link_context_menu.length).toEqual(14);
    });
  });
});
