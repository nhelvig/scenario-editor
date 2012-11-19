describe("NodeListCollection", function() {
  $a = window.beats;
  var models;
  var network;
  
  beforeEach(function() {
    network = $a.models
.get('networklist').get('network')[0];
    models = network.get('nodelist').get('node');
    spyOn($a.NodeListCollection.prototype, 'addNode').andCallThrough();
    spyOn($a.NodeListCollection.prototype, 'addLink').andCallThrough();
    spyOn($a.NodeListCollection.prototype, 'addLinkOrigin').andCallThrough();
    spyOn($a.NodeListCollection.prototype, 'addLinkDest').andCallThrough();
    spyOn($a.NodeListCollection.prototype, 'removeNode').andCallThrough();
    
    this.nCollect = new $a.NodeListCollection(models);
  });

  describe("Instantiation", function() {
    it("sets models to a collection of nodes", function() {
      expect(this.nCollect.models).not.toBeNull();
    });

    it("sets all its models selected attribute to false", function() {
      mod = this.nCollect.models;
      arrSel = mod.filter(function(node){ return node.get('selected') == false});
      expect(arrSel.length).toEqual(this.nCollect.length);
    });
    
    it("should be watching addNode", function() {
      $a.broker.trigger("nodes:add", new google.maps.LatLng(37,-122));
      expect($a.NodeListCollection.prototype.addNode).toHaveBeenCalled();
    });
    it("should be watching addLink", function() {
      this.nCollect.trigger("nodes:add_link", new google.maps.LatLng(37,-122));
      expect($a.NodeListCollection.prototype.addLink).toHaveBeenCalled();
    });
    it("should be watching addLinkOrigin", function() {
      this.nCollect.trigger("nodes:add_origin", new google.maps.LatLng(37,-122));
      expect($a.NodeListCollection.prototype.addLinkOrigin).toHaveBeenCalled();
    });
    it("should be watching addLinkDest", function() {
      this.nCollect.trigger("nodes:add_dest", new google.maps.LatLng(37,-122));
      expect($a.NodeListCollection.prototype.addLinkDest).toHaveBeenCalled();
    });
    it("should be watching removeNode", function() {
      this.nCollect.trigger("nodes:remove", new google.maps.LatLng(37,-122));
      expect($a.NodeListCollection.prototype.removeNode).toHaveBeenCalled();
    });
  });
  
  describe("getBrowserColumnData", function() {
    it("should return id, name, type for editor browser table", function() {
      arrColumnsData = this.nCollect.getBrowserColumnData();
      expect(arrColumnsData[0][0]).toEqual(this.nCollect.models[0].get('id'));
      expect(arrColumnsData[0][1]).toEqual(this.nCollect.models[0].get_road_names());
      expect(arrColumnsData[0][2]).toEqual(this.nCollect.models[0].get('type'));
    });
  });
  
  describe("setSelected ", function() {
    it("should sets the select field to true", function() {
      mod = this.nCollect.models;
      this.nCollect.setSelected(mod);
      arrSel = mod.filter(function(node){ return node.get('selected') == true});
      expect(arrSel.length).toEqual(this.nCollect.length);
    });
  });
  
  describe("clearSelected ", function() {
    it("should sets the select field to false", function() {
      mod = this.nCollect.models;
      this.nCollect.clearSelected();
      arrSel = mod.filter(function(node){ return node.get('selected') == false});
      expect(arrSel.length).toEqual(this.nCollect.length);
    });
  });
  
  describe("addNode ", function() {
    it("should create a new node and add it to the collection", function() {
      var lengthBefore = this.nCollect.length;
      this.nCollect.addNode(new google.maps.LatLng(37,-122));
      expect(lengthBefore + 1).toEqual(this.nCollect.length);
    });
    it("should create a new node and add it to the models schema", function() {
      var lengthBefore = $a.models
.nodes().length;
      this.nCollect.addNode(new google.maps.LatLng(37,-122));
      expect(lengthBefore + 1).toEqual($a.models
.nodes().length);
    });
  });

  describe("addLink ", function() {
    it("should create a new node and trigger an add link", function() {
      var lengthBefore = this.nCollect.length;
      this.nCollect.models[0].set('selected', true)
      this.nCollect.addLink(new google.maps.LatLng(37,-122));
      expect(lengthBefore + 1).toEqual(this.nCollect.length);
    });
  });

  describe("addLinkOrigin ", function() {
    it("should create a new orgin node and trigger an add link", function() {
      var lengthBefore = this.nCollect.length;
      this.nCollect.models[0].set('selected', true)
      this.nCollect.addLinkOrigin(new google.maps.LatLng(37,-122), 'terminal');
      expect(lengthBefore + 1).toEqual(this.nCollect.length);
    });
  });
  
  describe("addLinkDest ", function() {
    it("should create a new dest node and trigger an add link", function() {
      var lengthBefore = this.nCollect.length;
      this.nCollect.models[0].set('selected', true)
      this.nCollect.addLink(new google.maps.LatLng(37,-122), 'terminal');
      expect(lengthBefore + 1).toEqual(this.nCollect.length);
    });
  });
  
  describe("removeNode ", function() {
    it("should find the correct node by id and remove it", function() {
      var lengthBefore = this.nCollect.length;
      this.nCollect.removeNode(this.nCollect.models[0].cid);
      expect(lengthBefore - 1).toEqual(this.nCollect.length);
    });
  });
  
  describe("isOneSelected ", function() {
    it("should return true if one node is selected", function() {
      expect(this.nCollect.isOneSelected()).not.toBeTruthy();
      this.nCollect.models[0].set('selected', true);
      expect(this.nCollect.isOneSelected()).toBeTruthy();
    });
  });
});