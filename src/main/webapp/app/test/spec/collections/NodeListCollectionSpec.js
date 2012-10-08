describe("NodeListCollection", function() {
  $a = window.sirius;
  var models;
  var network;
  
  beforeEach(function() {
    network = $a.scenario.get('networklist').get('network')[0];
    models = network.get('nodelist').get('node');
    spyOn($a.NodeListCollection.prototype, 'addOne').andCallThrough();
    
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
    
    it("should be watching addOne", function() {
      this.nCollect.trigger("nodes:add");
      expect($a.NodeListCollection.prototype.addOne).toHaveBeenCalled();
    });
  });
  
  describe("getBrowserColumnData", function() {
    it("should return id, name, type for editor browser table", function() {
      arrColumnsData = this.nCollect.getBrowserColumnData();
      expect(arrColumnsData[0][0]).toEqual(this.nCollect.models[0].get('id'));
      expect(arrColumnsData[0][1]).toEqual(this.nCollect.models[0].get('name'));
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
  
  describe("addOne ", function() {
    it("should create a new node and add it to the collection", function() {
      $a.contextMenu.position = new google.maps.LatLng(37,-122);
      var lengthBefore = this.nCollect.length;
      this.nCollect.addOne();
      expect(lengthBefore + 1).toEqual(this.nCollect.length);
    });
  });
});