describe("MapNodeView", function() {
  $a = window.sirius;
  var network, model;

  beforeEach(function() {
    loadFixtures('context.menu.view.fixture.html');
    network = $a.scenario.get('networklist').get('network')[0];
    model = network.get('nodelist').get('node')[0];
    this.view = new $a.MapNodeView(model, network)
  });

  describe("Rendering", function() {
    it("should return the view object", function() {
      expect(this.view.render()).toEqual(this.view);
    });
  });
});