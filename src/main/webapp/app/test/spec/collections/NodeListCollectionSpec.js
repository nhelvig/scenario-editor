describe("NodeListCollection", function() {
  $a = window.beats;
  var models;
  var network;
  
  beforeEach(function() {
    spyOn($a.NodeListCollection.prototype, 'addNode').andCallThrough();
    spyOn($a.NodeListCollection.prototype, 'addLink').andCallThrough();
    spyOn($a.NodeListCollection.prototype, 'addLinkOrigin').andCallThrough();
    spyOn($a.NodeListCollection.prototype, 'addLinkDest').andCallThrough();
    spyOn($a.NodeListCollection.prototype, 'removeNode').andCallThrough();
    spyOn($a.NodeListCollection.prototype, 'removeNodeAndLinks').andCallThrough();
    spyOn($a.NodeListCollection.prototype, 'removeNodeAndJoinLinks').andCallThrough();
    this.nColl = new $a.NodeListCollection($a.models.nodes());
  });
  
  describe("Instantiation", function() {
       it("sets models to a collection of nodes", function() {
         expect(this.nColl.models).not.toBeNull();
       });
       it("sets all its models selected attribute to false", function() {
         mod = this.nColl.models;
         arrSel = mod.filter(function(node){ return node.get('selected') === false});
         expect(arrSel.length).toEqual(this.nColl.length);
       });
       it("should be watching addNode", function() {
         $a.broker.trigger("nodes:add", new google.maps.LatLng(35,-122));
         expect($a.NodeListCollection.prototype.addNode).toHaveBeenCalled();
       });
       it("should be watching addLink", function() {
         this.nColl.trigger("nodes:add_link", new google.maps.LatLng(37,-123));
         expect($a.NodeListCollection.prototype.addLink).toHaveBeenCalled();
       });
       it("should be watching addLinkOrigin", function() {
         this.nColl.trigger("nodes:add_origin", new google.maps.LatLng(37,-125));
         expect($a.NodeListCollection.prototype.addLinkOrigin).toHaveBeenCalled();
       });
       it("should be watching addLinkDest", function() {
         this.nColl.trigger("nodes:add_dest", new google.maps.LatLng(36,-122));
         expect($a.NodeListCollection.prototype.addLinkDest).toHaveBeenCalled();
       });
       it("should be watching removeNode", function() {
         $a.broker.trigger("nodes:remove", this.nColl.models[0].cid);
         expect($a.NodeListCollection.prototype.removeNode).toHaveBeenCalled();
       });
       it("should be watching removeNodeAndJoinLinks", function() {
         $a.broker.trigger("nodes:remove_and_join", this.nColl.models[0].cid);
         expect($a.NodeListCollection.prototype.removeNodeAndJoinLinks).toHaveBeenCalled();
       });
       it("should be watching removeNodeAndLinks", function() {
         $a.broker.trigger("nodes:remove_and_links", this.nColl.models[0].cid);
         expect($a.NodeListCollection.prototype.removeNodeAndLinks).toHaveBeenCalled();
       });
  });
     
  describe("getBrowserColumnData", function() {
     it("should return id, name, type for editor browser table", function() {
       arrColumnsData = this.nColl.getBrowserColumnData();
       expect(arrColumnsData[0][0]).toEqual(this.nColl.models[0].ident());
       expect(arrColumnsData[0][1]).toEqual(this.nColl.models[0].name());
       expect(arrColumnsData[0][2]).toEqual(this.nColl.models[0].type_name());
     });
  });
     
  describe("setSelected ", function() {
     it("should sets the select field to true", function() {
       mod = this.nColl.models;
       this.nColl.setSelected(mod);
       arrSel = mod.filter(function(node){ return node.get('selected') == true});
       expect(arrSel.length).toEqual(this.nColl.length);
       this.nColl.clearSelected();
     });
  });
     
  describe("clearSelected ", function() {
     it("should sets the select field to false", function() {
       mod = this.nColl.models;
       this.nColl.clearSelected();
       arrSel = mod.filter(function(node){ return node.get('selected') == false});
       expect(arrSel.length).toEqual(this.nColl.length);
     });
  });
     
  describe("addNode ", function() {
    it("should create a new node and add it to the collection", function() {
     var lengthBefore = this.nColl.length;
     this.nColl.addNode(new google.maps.LatLng(37,-122));
     expect(lengthBefore + 1).toEqual(this.nColl.length);
    });
    it("should create a new node and add it to the models schema", function() {
     var lengthBefore = $a.models.nodes().length;
     this.nColl.addNode(new google.maps.LatLng(37,-122));
     expect(lengthBefore + 1).toEqual($a.models.nodes().length);
    });
  });

   describe("addLink ", function() {
     it("should create a new node and trigger an add link", function() {
       var lengthBefore = this.nColl.length;
       this.nColl.models[0].set('selected', true)
       this.nColl.addLink(new google.maps.LatLng(37,-122));
       expect(lengthBefore + 1).toEqual(this.nColl.length);
     });
   });
   
   describe("addLinkOrigin ", function() {
     it("should create a new orgin node and trigger an add link", function() {
       var lengthBefore = this.nColl.length;
       this.nColl.models[0].set('selected', true)
       this.nColl.addLinkOrigin(new google.maps.LatLng(37,-122), 'terminal');
       expect(lengthBefore + 1).toEqual(this.nColl.length);
     });
   });
   
   describe("addLinkDest ", function() {
     it("should create a new dest node and trigger an add link", function() {
       var lengthBefore = this.nColl.length;
       this.nColl.models[0].set('selected', true)
       this.nColl.addLink(new google.maps.LatLng(37,-122), 'terminal');
       expect(lengthBefore + 1).toEqual(this.nColl.length);
     });
   });
   
   describe("removeNode ", function() {
     it("should find the correct node by id and remove it", function() {
       var lengthBefore = this.nColl.length;
       this.nColl.removeNode(this.nColl.models[2].cid, true);
       expect(lengthBefore - 1).toEqual(this.nColl.length);
     });
   });
   
  describe("removeNodeAndLinks ", function() {
     it("should remove node and its links", function() {
       nodesLengthBefore = this.nColl.length;
       this.nColl.removeNodeAndLinks(this.nColl.models[2].cid);
       nodesLengthAfter = this.nColl.length;
       expect(nodesLengthBefore - 1).toEqual(this.nColl.length);
     });
   });
   
   describe("isOneSelected ", function() {
     it("should return true if one node is selected", function() {
       expect(this.nColl.isOneSelected()).not.toBeTruthy();
       this.nColl.models[0].set('selected', true);
       expect(this.nColl.isOneSelected()).toBeTruthy();
       this.nColl.clearSelected();
     });
   });
});