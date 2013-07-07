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
    var msg = "should instantiate the google map, File Upload View, Nav Bar, ";
    msg += "Context Menu, Layers Menu, and Message Panel";
    
    afterEach(function(){
      modelSetUp()
    });
    it(msg, function() {
     runs(function() {
         flag = false;
         this.view.render();
         setTimeout(function() {flag = true;}, 1000);
       });
       waitsFor(function() {
         return flag;
       }, "The request should be done", 1500);
       runs(function() { 
         expect($a.map).not.toBeNull();
         expect(this.view.fuv).not.toBeNull();
         expect(this.view.nbv).not.toBeNull();
         expect($a.contextMenu).not.toBeNull();
         expect(this.view.lmenu).not.toBeNull();
         expect(this.view.mpv).not.toBeNull();
       });
    });
  });
});