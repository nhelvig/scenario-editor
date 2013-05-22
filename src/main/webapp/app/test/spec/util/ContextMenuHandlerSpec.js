describe("ContextMenuHandler", function() {
  $a = window.beats;
  
  beforeEach(function() {
      googleMap();
      jasmine.getFixtures().load("context.menu.view.fixture.html");
      spyOn($a.ContextMenuView.prototype, 'show').andCallThrough();
      this.cmh = new $a.ContextMenuHandler({  
                                              items:$a.main_context_menu,
                                              element: $a.map,
                                          });
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
     it("should create the menu correctly", function(){
       runs(function() {
         flag = false;
         this.cmh._createMenu({items:$a.main_context_menu, options: opt},latLng );
         setTimeout(function() {flag = true;}, 500);
       });
       waitsFor(function() {
         return flag;
       }, "The call back to create menu items should be done", 750);
       runs(function() { 
        expect($a.contextMenu).not.toBeNull();
        var expectedLength = $a.main_context_menu.length;
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
         this.items = this.cmh._populateMenu({items:$a.main_context_menu});
         var expectedLength =  $a.main_context_menu.length;
         expect(this.items.length).toEqual(expectedLength);
       });
       it("Models but no node selected: return menu with just standard including add node", function(){
         this.items = this.cmh._populateMenu({items:$a.main_context_menu});
         var expectedLength = $a.main_context_menu.length;
         expect(this.items.length).toEqual(expectedLength);
       });
       it("Models node selected: return menu with standard and node selected actions", function(){
         scen = scenarioAndFriends()
         list = scen.scenario.nodes();  
         $a.nodeList = new $a.NodeListCollection(list);
         $a.nodeList.models[0].set('selected',true);
         this.items = this.cmh._populateMenu({items:$a.main_context_menu});
         var expectedLength = $a.main_context_menu.length + $a.node_selected.length
         expect(this.items.length).toEqual(expectedLength);
       });
     });
});
