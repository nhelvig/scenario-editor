describe("AppView", function() {
  $a = window.beats;

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
    });
    it("should instantiate the google map", function() {
      expect($a.map).not.toBeNull();
    });
    it("should instantiate a File Upload View", function() {
      expect(this.view.fuv).not.toBeNull();
    });
    it("should instantiate a Nav Bar", function() {
      expect(this.view.nbv).not.toBeNull();
    });
    it("should instantiate a Context Menu", function() {
      expect($a.contextMenu).not.toBeNull();
    });
    it("should instantiate a Layers Menu", function() {
      expect(this.view.lmenu).not.toBeNull();
    });
    it("should instantiate a Message Panel", function() {
      expect(this.view.mpv).not.toBeNull();
    });
  });
});