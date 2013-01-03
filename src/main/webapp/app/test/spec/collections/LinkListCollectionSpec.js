describe("LinkListCollection", function() {
  $a = window.beats;
  var models, network, begin, end;
  
  beforeEach(function() {
    network = $a.models.get('networklist').get('network')[0];
    models = network.get('linklist').get('link');
    spyOn($a.LinkListCollection.prototype, 'addLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'removeLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'splitLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'reDrawLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'clear').andCallThrough();
    spyOn($a.LinkListCollection.prototype, '_setUpEvents').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'joinLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'parallelLink').andCallThrough();

    this.lColl= new $a.LinkListCollection(models);
  });

  describe("Instantiation", function() {
    it("sets models to a collection of links", function() {
      expect(this.lColl.models).not.toBeNull();
    });
    
    it("should be watching addLink", function() {
        begin = models[0].begin_node();
        end = models[0].end_node();
      $a.broker.trigger("links_collection:add", {begin:begin,end:end});
      expect($a.LinkListCollection.prototype.addLink).toHaveBeenCalled();
    });

    it("should be watching removeLink", function() {
      this.lColl.trigger("links:remove", models[0].cid);
      expect($a.LinkListCollection.prototype.removeLink).toHaveBeenCalled();
    });
    it("should be watching splitLink", function() {
      scen = scenarioAndFriends();
      models[0].set('shape', scen.link1.get('shape'));
      this.lColl.trigger("links:split", models[0].cid);
      expect($a.LinkListCollection.prototype.splitLink).toHaveBeenCalled();
    });
    it("should be watching reDrawLink", function() {
      $a.broker.trigger("map:redraw_link", begin);
      expect($a.LinkListCollection.prototype.reDrawLink).toHaveBeenCalled();
    });
    it("should be watching joinLink", function() {
      scen = scenarioAndFriends()
      $a.broker.trigger("links_collection:join", scen.node2);
      expect($a.LinkListCollection.prototype.joinLink).toHaveBeenCalled();
    });
    it("should be watching parallelLink", function() {
      this.lColl.trigger("links:parallel", 1);
      expect($a.LinkListCollection.prototype.parallelLink).toHaveBeenCalled();
    });
    it("should call _setUpEvents", function() {
      expect($a.LinkListCollection.prototype._setUpEvents).toHaveBeenCalled();
    });
    it("should be watching clear", function() {
      $a.broker.trigger("map:clear_map");
      this.after(function() { 
        $a.models = $a.Scenario.from_xml($(xml).children()); 
      });
      expect($a.LinkListCollection.prototype.clear).toHaveBeenCalled();
    });
  });
    
  describe("getBrowserColumnData", function() {
      var desc = "should return id, name,road_name, type, lanes, ";
      desc += "begin node name, and end node name for editor browser table";
       it(desc, function() {
       arrColumnsData = this.lColl.getBrowserColumnData();
       lColl = this.lColl.models[0];
       expect(arrColumnsData[0][0]).toEqual(lColl.get('id'));
       expect(arrColumnsData[0][1]).toEqual(lColl.road_names());
       expect(arrColumnsData[0][2]).toEqual(lColl.get('type'));
       expect(arrColumnsData[0][3]).toEqual(lColl.get('lanes'));
       nodeB = lColl.get('begin').get('node');
       nodeE = lColl.get('end').get('node');
       expect(arrColumnsData[0][4]).toEqual(nodeB.road_names());
       expect(arrColumnsData[0][5]).toEqual(nodeE.road_names());
     });
   });
  
  describe("removeLink ", function() {
    it("should remove a link from the collection", function() {
      var lengthBefore = this.lColl.length;
      this.lColl.removeLink(models[0].cid);
      expect(lengthBefore - 1).toEqual(this.lColl.length);
    });
  });
  describe("splitLink ", function() {
    it("should split a link from the collection", function() {
      scen = scenarioAndFriends();
      models[0].set('shape', scen.link1.get('shape'));
      var lengthBefore = this.lColl.length;
      numLinks = 2;
      newLength = lengthBefore + numLinks - 1;
      this.lColl.splitLink(models[0].cid, numLinks);
      expect(newLength).toEqual(this.lColl.length);
    });
  });
  
  describe("addLink ", function() {
    beforeEach(function() {
      begin = models[0].begin_node();
      end = models[0].end_node();
    });
    it("should create a new link and add it to the collection", function() {
      var lengthBefore = this.lColl.length;
      this.lColl.addLink({begin:begin,end:end});
      expect(lengthBefore + 1).toEqual(this.lColl.length);
    });
    it("should create a new link and add it to the schema", function() {
      var lengthBefore = $a.models.links().length;
      this.lColl.addLink({begin:begin,end:end});
      expect(lengthBefore + 1).toEqual($a.models.links().length);
    })
  });
  
  describe("removeNodeReference", function() {
    it("should remove the begin or end node from link", function() {
      this.lColl.removeNodeReference(this.lColl.models[0],'end');
      expect(this.lColl.models[0].get('end').get('node')).toBeNull();
      models[0].get('end').set('node', end)
    });
  });
  
  describe("reDrawLink ", function() {
    it("should find links connected to the node and redraw them", function() {
      begin = models[0].begin_node();
      links = this.lColl.reDrawLink(begin);
      expect(links.length > 0).toBeTruthy();
    });
  });
  describe("joinLink ", function() {
    it("should join links when node is removed", function() {
      scen = scenarioAndFriends()
      linkColl= new $a.LinkListCollection([scen.link1, scen.link2, scen.link3]);
      links = linkColl.models
      lBefore = links.length
      $a.broker.trigger("links_collection:join", scen.node2);
      expect(lBefore - 1).toEqual(linkColl.models.length);
    });
  });
  describe("parallelLink ", function() {
    it("should create parallel link", function() {
      lengthBefore = this.lColl.model.length
      link =  this.lColl.models[0]
      this.lColl.trigger("links:parallel", link);
      expect(lengthBefore + 1).toEqual(this.lColl.models.length);
    });
  });
  describe("clear ", function() {
    beforeEach(function() {
      this.lColl.clear();
    });
    afterEach(function() {
      $a.models = $a.Scenario.from_xml($(xml).children());
    });
    it("should de-reference $a.linkList", function() {
      expect($a.linkList).toEqual({});
    });
    it("should stop listening to map:redraw_link", function() {
      $a.broker.trigger('map:redraw_link')    
      expect($a.LinkListCollection.prototype.reDrawLink).not.toHaveBeenCalled();
    }); 
    it("should stop listening to links_collection:add", function() {
      $a.broker.trigger('links_collection:add')    
      expect($a.LinkListCollection.prototype.addLink).not.toHaveBeenCalled();
    });
    it("should stop listening to links:remove", function() {
      this.lColl.trigger('links:remove')
      expect($a.LinkListCollection.prototype.removeLink).not.toHaveBeenCalled();
    });
  });
});