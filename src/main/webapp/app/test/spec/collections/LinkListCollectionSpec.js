describe("LinkListCollection", function() {
  $a = window.beats;
  var models, network, begin, end;
  
  beforeEach(function() {
    loadFixtures('main.canvas.view.fixture.html');

    spyOn($a.LinkListCollection.prototype, 'addLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'removeLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'splitLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'splitLinkAddNode').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'reDrawLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'clear').andCallThrough();
    spyOn($a.LinkListCollection.prototype, '_setUpEvents').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'joinLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'duplicateLink').andCallThrough();

    scen = scenarioAndFriends();
    this.lColl= new $a.LinkListCollection([scen.link1, scen.link2, scen.link3]);
  });

  describe("Instantiation", function() {
    it("sets models to a collection of links", function() {
      expect(this.lColl.models).not.toBeNull();
    });
    
    it("should be watching addLink", function() {
      begin = scen.link1.begin_node();
      end = scen.link1.end_node();
      $a.broker.trigger("links_collection:add", {begin:begin,end:end});
      expect($a.LinkListCollection.prototype.addLink).toHaveBeenCalled();
    });

    it("should be watching removeLink", function() {
      this.lColl.trigger("links:remove", scen.link1.cid);
      expect($a.LinkListCollection.prototype.removeLink).toHaveBeenCalled();
    });
    it("should be watching splitLink", function() {
      this.lColl.trigger("links:split", scen.link1.cid);
      expect($a.LinkListCollection.prototype.splitLink).toHaveBeenCalled();
    });
    it("should be watching splitLinkAddNode", function() {
      this.lColl.trigger("links:split_add_node", scen.link1.cid, new google.maps.LatLng(0,0));
      expect($a.LinkListCollection.prototype.splitLinkAddNode).toHaveBeenCalled();
    });
    it("should be watching reDrawLink", function() {
      $a.broker.trigger("map:redraw_link", scen.link4);
      expect($a.LinkListCollection.prototype.reDrawLink).toHaveBeenCalled();
    });
    it("should be watching joinLink", function() {
      $a.broker.trigger("links_collection:join", scen.node2);
      expect($a.LinkListCollection.prototype.joinLink).toHaveBeenCalled();
    });
    it("should be watching duplicateLink", function() {
      this.lColl.models[0].set_geometry(scen.link1.geometry())
      this.lColl.trigger("links:duplicate", scen.link1.cid);
      expect($a.LinkListCollection.prototype.duplicateLink).toHaveBeenCalled();
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
  
  describe("removeLink", function() {
    it("should remove a link from the collection", function() {
      var lengthBefore = this.lColl.length;
      this.lColl.removeLink(scen.link1.cid);
      expect(lengthBefore - 1).toEqual(this.lColl.length);
    });
  });
  describe("splitLink", function() {
    it("should split a link from the collection", function() {
      var lengthBefore = this.lColl.length;
      numLinks = 2;
      newLength = lengthBefore + numLinks - 1;
      this.lColl.splitLink(scen.link1.cid, numLinks);
      expect(newLength).toEqual(this.lColl.length);
    });
  });
  describe("splitLinkAddNode", function() {
    it("should split a link add one node at position", function() {
      scen = scenarioAndFriends();
      linkColl= new $a.LinkListCollection([scen.link1, scen.link2, scen.link3]);
      var lengthBefore = linkColl.length;
      linkColl.splitLinkAddNode(scen.link1.cid, new google.maps.LatLng(0,0));
      expect(lengthBefore + 1).toEqual(linkColl.length);
    });
  });
  describe("addLink ", function() {
    beforeEach(function() {
      begin = scen.link1.begin_node();
      end = scen.link1.end_node();
    });
    var itMsg = "should create a new link and add it to the collection, schema";
    itMsg += " and update the begin and end nodes output and input fields";
    it(itMsg, function() {
      var lengthBefore = this.lColl.length;
      var schemaLength = $a.models.links().length
      link = this.lColl.addLink({begin:begin,end:end});
      outputs = link.begin_node().outputs()
      inputs = link.end_node().inputs()
      oLink = _.find(outputs, function(out){return out.link().id === link.id});
      iLink = _.find(inputs, function(inp){return inp.link().id === link.id});

      expect(lengthBefore + 1).toEqual(this.lColl.length);
      expect(schemaLength + 1).toEqual($a.models.links().length);
      expect(oLink).not.toBeNull();
      expect(iLink).not.toBeNull();
    });
  });
  
  describe("removeNodeReference", function() {
    it("should remove the begin or end node from link", function() {
      this.lColl.removeNodeReference(this.lColl.models[0],'end');
      expect(this.lColl.models[0].get('end').get('node')).toBeNull();
      scen.link1.get('end').set('node', end)
    });
  });
  
  describe("reDrawLink ", function() {
    it("should take link and redraw it after update called", function() {
      begin = scen.link1.begin_node();
      begin.updatePosition(new google.maps.LatLng(37.8579, -122.2995));
      links = this.lColl.reDrawLink(scen.link1);
      expect(this.lColl.length).toEqual(3);
    });
  });
  describe("joinLink ", function() {
    it("should join links when node is removed", function() {
      scen = scenarioAndFriends()
      linkColl= new $a.LinkListCollection([scen.link1, scen.link2, scen.link3]);
      links = linkColl.models
      lBefore = links.length
      linkColl.joinLink(scen.node2);
      expect(lBefore - 1).toEqual(linkColl.models.length);
    });
  });
  describe("duplicateLink ", function() {
    it("should create duplicate link", function() {
      scen = scenarioAndFriends();
      lengthBefore = this.lColl.models.length
      link =  this.lColl.models[0];
      link.set_geometry(scen.link1.geometry());
      this.lColl.duplicateLink(link.cid);
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