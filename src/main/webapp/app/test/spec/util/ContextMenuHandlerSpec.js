describe("ContextMenuHandler", function() {
  $a = window.beats;
  
  beforeEach(function() {
      loadFixtures("context.menu.view.fixture.html");
      spyOn($a.ContextMenuView.prototype, 'show').andCallThrough();
      this.cmh = new $a.ContextMenuHandler({  
                                              items:$a.main_context_menu,
                                              map: $a.map != null
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
       this.cmh._createMenu({items:$a.main_context_menu},latLng );
     });
     it("should create the menu", function(){
        expect($a.contextMenu).not.toBeNull();
      });
      it("should have items based on context", function(){
        var expectedLength = $a.main_context_menu.length;
        expect($a.contextMenu.options.menuItems.length).toEqual(expectedLength);
      });
      it("should call show", function(){
         expect($a.ContextMenuView.prototype.show).toHaveBeenCalled();
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
     it("Models but no node selected: return menu with just standard and add node", function(){
       $a.models = $a.scenario;
       this.items = this.cmh._populateMenu({items:$a.main_context_menu});
       var expectedLength = $a.node_add.length + $a.main_context_menu.length;
       expect(this.items.length).toEqual(expectedLength);
     });
     it("Models node selected: return menu with standard and node selected actions", function(){
       $a.models = $a.scenario;
       list = $a.models.get('networklist').get('network')[0].get('nodelist');
       
       $a.nodeList = new $a.NodeListCollection(list.get('node'));
       $a.nodeList.models[0].set('selected',true);
       this.items = this.cmh._populateMenu({items:$a.main_context_menu});
       var expectedLength = $a.node_add.length + $a.main_context_menu.length + $a.node_selected.length
       expect(this.items.length).toEqual(expectedLength);
     });
   });
});
