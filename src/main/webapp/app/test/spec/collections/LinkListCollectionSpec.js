describe("LinkListCollection", function() {
  $a = window.sirius;
  var models, network, begin, end;
  
  beforeEach(function() {
    network = $a.scenario.get('networklist').get('network')[0];
    models = network.get('linklist').get('link');
    spyOn($a.LinkListCollection.prototype, 'addLink').andCallThrough();
    
    this.lColl= new $a.LinkListCollection(models);
    begin = models[0].get('begin');
    end = models[0].get('end');
  });
  
  describe("Instantiation", function() {
    it("sets models to a collection of links", function() {
      expect(this.lColl.models).not.toBeNull();
    });
    
    it("should be watching addLink", function() {
      $a.broker.trigger("link_coll:add", {begin:begin,end:end});
      expect($a.LinkListCollection.prototype.addLink).toHaveBeenCalled();
    });
  });
  
   describe("getBrowserColumnData", function() {
      var desc = "should return id, name,road_name, type, lanes, ";
      desc += "begin node name, and end node name for editor browser table";
       it(desc, function() {
       arrColumnsData = this.lColl.getBrowserColumnData();
       lColl = this.lColl.models[0];
       expect(arrColumnsData[0][0]).toEqual(lColl.get('id'));
       expect(arrColumnsData[0][1]).toEqual(lColl.get('name'));
       expect(arrColumnsData[0][2]).toEqual(lColl.get('road_name'));
       expect(arrColumnsData[0][3]).toEqual(lColl.get('type'));
       expect(arrColumnsData[0][4]).toEqual(lColl.get('lanes'));
       node = lColl.get('begin').get('node');
       expect(arrColumnsData[0][5]).toEqual(node.get('name'));
       expect(arrColumnsData[0][6]).toEqual(node.get('name'));
     });
   });
  
  describe("addLink ", function() {
    it("should create a new link and add it to the collection", function() {
      var lengthBefore = this.lColl.length;
      this.lColl.addLink({begin:begin,end:end});
      expect(lengthBefore + 1).toEqual(this.lColl.length);
    });
  });
});