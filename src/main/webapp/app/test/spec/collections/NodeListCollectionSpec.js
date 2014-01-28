describe("NodeListCollection", function() {
  $a = window.beats;
  var models;
  var network;
  
  beforeEach(function() {
    nlc = $a.NodeListCollection.prototype;
    spyOn($a.LinkListCollection.prototype, 'addLink');
    spyOn(nlc, 'clear').andCallThrough();
    spyOn(nlc, 'clearSelected').andCallThrough();
    spyOn(nlc, 'addNode').andCallThrough();
    spyOn(nlc, 'addLink').andCallThrough();
    spyOn(nlc, 'addConnectingLinkDest').andCallThrough();
    spyOn(nlc, 'addConnectingLinkOrigin').andCallThrough();
    spyOn(nlc, 'addLinkOrigin').andCallThrough();
    spyOn(nlc, 'addLinkDest').andCallThrough();
    spyOn(nlc, 'removeNode').andCallThrough();
    spyOn(nlc, 'removeNodeAndLinks').andCallThrough();
    spyOn(nlc, 'removeNodeAndJoinLinks').andCallThrough();
    model = scenarioAndFriends().scenario
    this.nColl = new $a.NodeListCollection(model.nodes());
    this.lColl = new $a.LinkListCollection(model.links());
   
  });
  
  describe("Instantiation", function() {
       latLng = new google.maps.LatLng(37,-125);
       it("sets models to a collection of nodes", function() {
         expect(this.nColl.models).not.toBeNull();
       });
       it("sets all its models selected attribute to false", function() {
         mod = this.nColl.models;
         arrSel = mod.filter(function(node){ 
           return node.get('selected') === false
         });
         expect(arrSel.length).toEqual(this.nColl.length);
       });
       it("should be watching clear", function() {
         $a.broker.trigger("map:clear_map");
         expect(nlc.clear).toHaveBeenCalled();
       });
       it("should be watching clearSelected", function() {
         $a.broker.trigger('map:clear_selected');
         expect(nlc.clearSelected).toHaveBeenCalled();
       })
       it("should be watching addNode", function() {
         $a.broker.trigger("nodes:add", new google.maps.LatLng(35,-122));
         expect(nlc.addNode).toHaveBeenCalled();
       });
       it("should be watching addLink", function() {
         this.nColl.trigger("nodes:add_link", new google.maps.LatLng(37,-123));
         expect(nlc.addLink).toHaveBeenCalled();
       });
       it("should be watching addConnectingLinkDest", function() {
         this.nColl.trigger('nodes:add_connecting_link_dest', latLng);
         expect(nlc.addConnectingLinkDest).toHaveBeenCalled();
       });
       it("should be watching addLinkDest", function() {
         this.nColl.trigger("nodes:add_dest", new google.maps.LatLng(36,-122));
         expect(nlc.addLinkDest).toHaveBeenCalled();
       });
       it("should be watching addConnectingLinkOrigin", function() {
         this.nColl.trigger("nodes:add_connecting_link_orig", latLng);
         expect(nlc.addConnectingLinkOrigin).toHaveBeenCalled();
       });
       it("should be watching addLinkDest", function() {
         this.nColl.trigger("nodes:add_dest", new google.maps.LatLng(36,-122));
         expect(nlc.addLinkDest).toHaveBeenCalled();
       });
       it("should be watching removeNode", function() {
         $a.broker.trigger("nodes:remove", this.nColl.models[0].cid);
         expect(nlc.removeNode).toHaveBeenCalled();
       });
       it("should be watching removeNodeAndJoinLinks", function() {
         $a.broker.trigger("nodes:remove_and_join", this.nColl.models[0].cid);
         expect(nlc.removeNodeAndJoinLinks).toHaveBeenCalled();
       });
       it("should be watching removeNodeAndLinks", function() {
         $a.broker.trigger("nodes:remove_and_links", this.nColl.models[0].cid);
         expect(nlc.removeNodeAndLinks).toHaveBeenCalled();
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
       arrSel = mod.filter(function(node){ 
         return node.get('selected') == false
       });
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

   describe("addLink", function() {
     it("should create a new node and trigger an add link", function() {
       var lengthBefore = this.nColl.length;
       this.nColl.models[0].set('selected', true)
       this.nColl.addLink(new google.maps.LatLng(37,-122));
       expect(lengthBefore + 1).toEqual(this.nColl.length);
     });
   });
   
   describe("addLinkOrigin", function() {
     it("should create a new orgin node and trigger an add link", function(){
       var lengthBefore = this.nColl.length;
       this.nColl.models[0].set('selected', true)
       this.nColl.addLinkOrigin(new google.maps.LatLng(37,-122), 'terminal');
       expect(lengthBefore + 1).toEqual(this.nColl.length);
     });
   });
   
   describe("addConnectingLinkOrigin", function() {
     it("should use selected and clicked node to create a link", function() {
       this.nColl.models[0].set('selected', true)
       this.nColl.addConnectingLinkOrigin(this.nColl.models[1].cid)
       expect($a.LinkListCollection.prototype.addLink).toHaveBeenCalled();
     });
   });
   describe("addConnectingLinkDest", function() {
     it("should use selected and clicked node to create a link", function() {
       this.nColl.models[0].set('selected', true)
       this.nColl.addConnectingLinkDest(this.nColl.models[1].cid)
       expect($a.LinkListCollection.prototype.addLink).toHaveBeenCalled();

     });
   });
   
   describe("addLinkDest", function() {
     it("should create a new dest node and trigger an add link", function() {
       var lengthBefore = this.nColl.length;
       this.nColl.models[0].set('selected', true)
       this.nColl.addLink(new google.maps.LatLng(37,-122), 'terminal');
       expect(lengthBefore + 1).toEqual(this.nColl.length);
     });
   });
   
   describe("removeNode", function() {
     it("should find the correct node by id and remove it", function() {
       var lengthBefore = this.nColl.length;
       this.nColl.removeNode(this.nColl.models[2].cid, true);
       expect(lengthBefore - 1).toEqual(this.nColl.length);
     });
   });
   
  describe("removeNodeAndLinks", function() {
     it("should remove node and its links", function() {
       nodesLengthBefore = this.nColl.length;
       this.nColl.removeNodeAndLinks(this.nColl.models[2].cid);
       nodesLengthAfter = this.nColl.length;
       expect(nodesLengthBefore - 1).toEqual(this.nColl.length);
     });
   });
   
  describe("removeNodeAndJoinLinks", function() {
     it("should remove node and join its links", function() {
       nodesLengthBefore = this.nColl.length;
       this.nColl.removeNodeAndJoinLinks(this.nColl.models[0].cid);
       nodesLengthAfter = this.nColl.length;
       expect(nodesLengthBefore - 1).toEqual(this.nColl.length);
     });
  });
  
  describe("_getSelectedNode", function() {
    it("should return an array of selected nodes", function() {
      models = this.nColl.models;
      _.each(models, function(n){
        n.set_selected(false);
      });
      models[0].set_selected(true);
      models[1].set_selected(true);
      arr = this.nColl._getSelectedNode();
      expect(arr.length).toEqual(2);
    });
  }); 

  describe("_setUpEvents", function() {
    it("should set up events related to the collection on the node", function(){
      this.nColl._setUpEvents(this.nColl.models[0]);
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
  describe("clear", function(){
    msg = "should clear the nodes from the map and turn off events";
    it(msg, function() {
        nlc = $a.NodeListCollection
        this.nColl.clear();
        expect(this.nColl.models.length).toEqual(0);
        expect($a.nodeList).toEqual({});
        nlc.prototype.clear.reset();
        nlc.prototype.clearSelected.reset();
        latLng = new google.maps.LatLng(37,-123)
        $a.broker.trigger("map:clear_map");
        $a.broker.trigger('map:clear_selected');
        $a.broker.trigger("nodes:add", latLng);
        $a.broker.trigger("nodes:remove");
        $a.broker.trigger("nodes:remove_and_join");
        $a.broker.trigger("nodes:remove_and_links");
  
        this.nColl.trigger("nodes:add_link", latLng);
        this.nColl.trigger('nodes:add_connecting_link_dest', latLng);
        this.nColl.trigger("nodes:add_dest", latLng);
        this.nColl.trigger("nodes:add_connecting_link_orig", latLng);  
        this.nColl.trigger("nodes:add_dest", latLng);
        
        expect(nlc.prototype.addNode).not.toHaveBeenCalled();
        expect(nlc.prototype.addLink).not.toHaveBeenCalled();
        expect(nlc.prototype.addConnectingLinkDest).not.toHaveBeenCalled();
        expect(nlc.prototype.addConnectingLinkOrigin).not.toHaveBeenCalled();   
        expect(nlc.prototype.addLinkOrigin).not.toHaveBeenCalled();
        expect(nlc.prototype.addLinkDest).not.toHaveBeenCalled();
        expect(nlc.prototype.removeNode).not.toHaveBeenCalled();
        expect(nlc.prototype.removeNodeAndLinks).not.toHaveBeenCalled();
        expect(nlc.prototype.removeNodeAndJoinLinks).not.toHaveBeenCalled();
   });
  });
});