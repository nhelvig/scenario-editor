describe("ContextMenuHandler", function() {
  $a = window.beats;
  
    beforeEach(function() {
      googleMap();
      jasmine.getFixtures().load("context.menu.view.fixture.html");
      spyOn($a.ContextMenuView.prototype, 'show').andCallThrough();
      this.cmh = $a.ContextMenuHandler
    });
    
    describe("Instantiation", function() {
      it("should create the handler", function() {
        expect(this.cmh).not.toBeNull();
      });
      it("should create the menu", function() {
        expect($a.contextMenu).not.toBeNull();
      });
      it("should call show when map right-clicked", function() {
        //not figuring out how to trigger right click on map
      });
    });
    
   describe("createMenu", function (){
     beforeEach(function() {
       latLng = new google.maps.LatLng(370, -122)
       opt = {class: 'context_menu', id: "main-context-menu"}       
     });
     it("should create the main context menu correctly in VIEW mode", function(){
       runs(function() {
         flag = false;
         $a.Util.setMode("view");
         this.cmh.createMenu({items:$a.main_context_menu, options: opt},latLng );
         setTimeout(function() {flag = true;}, 1000);
       });
       waitsFor(function() {
         return flag;
       }, "The call back to create menu items should be done", 1500);
       runs(function() { 
        expect($a.contextMenu).not.toBeNull();  
        var expectedLength = _.filter($a.main_context_menu, function(item){
            return item.mode === null;
          }).length;
        expect($a.contextMenu.options.menuItems.length).toEqual(expectedLength);
        expect($a.ContextMenuView.prototype.show).toHaveBeenCalled();       
      });
     });
     it("should create the main context menu correctly in NETWORK mode", function(){
       runs(function() {
         flag = false;
         $a.Util.setMode("network");
         this.cmh.createMenu({items:$a.main_context_menu, options: opt},latLng );
         setTimeout(function() {flag = true;}, 1000);
       });
       waitsFor(function() {
         return flag;
       }, "The call back to create menu items should be done", 1500);
       runs(function() { 
        expect($a.contextMenu).not.toBeNull();  
        var expectedLength = _.filter($a.main_context_menu, function(item){
            return item.mode === "$a.Mode.NETWORK" || item.mode === null;
          }).length;
        expect($a.contextMenu.options.menuItems.length).toEqual(expectedLength);
        expect($a.ContextMenuView.prototype.show).toHaveBeenCalled();       
      });
     });
     it("should create the main context menu correctly in SCENARIO mode", function(){
       runs(function() {
         flag = false;
         $a.Util.setMode("scenario");
         this.cmh.createMenu({items:$a.main_context_menu, options: opt},latLng );
         setTimeout(function() {flag = true;}, 1000);
       });
       waitsFor(function() {
         return flag;
       }, "The call back to create menu items should be done", 1500);
       runs(function() { 
        expect($a.contextMenu).not.toBeNull();  
        var expectedLength = _.filter($a.main_context_menu, function(item){
            return item.mode === "$a.Mode.SCENARIO" || item.mode === null;
          }).length;
        expect($a.contextMenu.options.menuItems.length).toEqual(expectedLength);
        expect($a.ContextMenuView.prototype.show).toHaveBeenCalled();       
      });
     });
   });
   
   describe("populateMenu", function (){
       it("should not be null", function(){
         this.items = this.cmh._populateMenu({items:$a.main_context_menu});
         expect(this.items).not.toBeNull();
       });
       it("No Models: should return menu items with just standard", function(){
         $a.Util.setMode("view");
         this.items = this.cmh._populateMenu({items:$a.main_context_menu});
         var expectedLength = _.filter($a.main_context_menu, function(item){
            return item.mode === null;
         }).length;
         expect(this.items.length).toEqual(expectedLength);
       });
       it("Models node selected: return menu with standard and node selected actions", function(){ 
         $a.Util.setMode("view");
         this.items = this.cmh._populateMenu({items:$a.main_context_menu});
         var expectedLength = _.filter($a.main_context_menu, function(item){
            return item.mode === null;
         }).length;
         expect(this.items.length).toEqual(expectedLength);
       });
     });
});
