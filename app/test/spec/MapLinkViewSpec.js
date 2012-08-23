describe("MapLinkView", function() {
  $a = window.sirius;
  
  beforeEach(function() {
    loadFixtures('context.menu.view.fixture.html');
    network = $a.scenario.get('networklist').get('network')[0];
    model = network.get('linklist').get('link')[0];
    expetedEncodedPath = "}r}eF`bmiVuGn@c@DwIhAiBT";
    legs = [
      {
        steps: [
          {
            path : [
              new google.maps.LatLng(37.83999, -122.29681000000001),
              new google.maps.LatLng(37.84138, -122.29705000000001),
              new google.maps.LatLng(37.84156, -122.29708000000001),
              new google.maps.LatLng(37.84328, -122.29745000000001),
              new google.maps.LatLng(37.84381000000001, -122.29756)
            ]
          }
        ]
      }
    ]
    this.view = new $a.MapLinkView(model, network, legs);
  });
  
  afterEach(function() {
    this.view.remove();
  }); 
  
  describe("Instantiation", function() {
    it("should encode the path", function() {
      expect(this.view.encodedPath).toEqual(expetedEncodedPath);
    });
    
    it("should save encoded the path to linkgeometry", function() {
      lg = this.view.model.get('linkgeometry');
      encodedPath = lg.get('encodedpolyline').get('points').get('text');
      expect(encodedPath).toEqual(expetedEncodedPath);
    });
    
    it("should have made polyline object", function() {
      link = this.view.link
      expect(link).not.toBe(null);
    });
    
    it("should have made context menu for itself", function() {
      cm = model.get('contextMenu');
      expect(cm).not.toBe(null);
      menuItemLabels = _.pluck(cm.options.menuItems, 'label');
      expect(menuItemLabels).toEqual(_.pluck($a.link_context_menu,'label'));
    });
  });
  
  describe("Rendering", function() {
    it("should return the view object", function() {
      expect(this.view.render()).toEqual(this.view);
    });
    
    it("should set its links map", function() {
      this.view.render();
      expect(this.view.link.getMap()).toEqual($a.map)
    });
  });
  
  describe("Events", function() {
      describe("When map:init fired -> render is called", function() {  
        it("should set the links map", function() {  
          $a.broker.trigger("map:init");
          googleMap();
          expect(this.view.link.getMap()).toEqual($a.map);
        });
      });
      describe("When map:hide_link_layer fired -> hideLink is called", function() { 
        it("should set the links map to null", function() {
          $a.broker.trigger("map:hide_link_layer");
          googleMap();
          expect(this.view.link.getMap()).toEqual(null);
        });
      });
  });  
});