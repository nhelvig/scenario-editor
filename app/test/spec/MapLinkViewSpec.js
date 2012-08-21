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
    this.view = new $a.MapLinkView(model,network,legs);
  });
  
  afterEach(function() {
    this.view.remove();
  }); 
  
  describe("Instantiation", function() {
    it("should encode the path", function() {
      expect(this.view.encodedPath == expetedEncodedPath);
    });
    
    it("should save encoded the path to linkgeometry", function() {
      expect(this.view.encodedPath == "");
    });
  });
});