describe("AppView", function() {
  $a = window.beats;
  var msg = "";

  beforeEach(function() {
    loadFixtures('main.canvas.view.fixture.html');
    this.view = new $a.AppView();
  });
  
  afterEach(function() {
    this.view.remove();
  });

  describe("Instantiation", function() {
    it("should instantiate broker", function() {
      expect($a.broker).not.toBeNull();
    });
  });
  
  describe("Rendering", function() {
    beforeEach(function() {
      this.view.render();
      msg = "should instantiate the google map, File Upload View, Nav Bar, "
      msg += "Context Menu, Layers Menu, and Message Panel"
    });
    afterEach(function(){
      modelSetUp()
    });
    it(msg, function() {
      expect($a.map).not.toBeNull();
      expect(this.view.fuv).not.toBeNull();
      expect(this.view.nbv).not.toBeNull();
      expect($a.contextMenu).not.toBeNull();
      expect(this.view.lmenu).not.toBeNull();
      expect(this.view.mpv).not.toBeNull();
    });
  });
});