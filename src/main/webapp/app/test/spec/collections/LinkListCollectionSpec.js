describe("LinkListCollection", function() {
  $a = window.beats;
  var models, network, begin, end;
  
  beforeEach(function() {
    loadFixtures('main.canvas.view.fixture.html');
    spyOn($a.LinkListCollection.prototype, 'addLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'removeLink').andCallThrough();
    //spyOn($a.LinkListCollection.prototype, 'reDrawLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'splitLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'splitLinkAddNode').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'splitLinkByDistance').andCallThrough();
    spyOn($a.LinkListCollection.prototype, '_setUpEvents').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'joinLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'duplicateLink').andCallThrough();
    scen = scenarioAndFriends();
    links = [scen.link1, scen.link2, scen.link3];
    this.lColl= new $a.LinkListCollection(links);
    model = scen.scenario
    $a.nodeList = new $a.NodeListCollection(model.nodes());
  });
  
  describe("Instantiation", function() {
    it("sets models to a collection of links", function() {
      expect(this.lColl.models).not.toBeNull();
    });
    
    it("should be watching addLink", function() {
      begin = this.lColl.models[0].begin_node();
      end = this.lColl.models[0].end_node();
      $a.broker.trigger("links_collection:add", {begin:begin,end:end});
      expect($a.LinkListCollection.prototype.addLink).toHaveBeenCalled();
    });
    // it("should be watching reDrawLink after updatePosition called on node", 
    //   function() {
    //     begin = $a.linkList.models[0].begin_node()
    //     begin.updatePosition(new google.maps.LatLng(37.8579, -122.2995));
    //     expect($a.LinkListCollection.prototype.reDrawLink).toHaveBeenCalled();
    // });
    it("should be watching removeLink", function() {
      $a.broker.trigger("links:remove", scen.link1.cid);
      expect($a.LinkListCollection.prototype.removeLink).toHaveBeenCalled();
    });
    it("should be watching splitLink", function() {
      this.lColl.trigger("links:split", scen.link1.cid);
      expect($a.LinkListCollection.prototype.splitLink).toHaveBeenCalled();
    });
    it("should be watching splitLinkByDistance", function() {
      scen.link1.set_subdivide(3);
      expect($a.LinkListCollection.prototype.splitLinkByDistance).toHaveBeenCalled();
    });
    it("should be watching splitLinkAddNode", function() {
      this.lColl.trigger("links:split_add_node", scen.link1.cid, new google.maps.LatLng(0,0));
      expect($a.LinkListCollection.prototype.splitLinkAddNode).toHaveBeenCalled();
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
    // it("should be watching clear", function() {
    //   $a.broker.trigger("map:clear_map");
    //   expect($a.linkList.clear).toHaveBeenCalled();
    // });
  });
    
  describe("getBrowserColumnData", function() {
      var desc = "should return id, name,road_name, type, lanes, ";
      desc += "begin node name, and end node name for editor browser table";
       it(desc, function() {
       arrColumnsData = this.lColl.getBrowserColumnData();
       lColl = this.lColl.models[0];
       expect(arrColumnsData[0][0]).toEqual(lColl.ident());
       expect(arrColumnsData[0][1]).toEqual(lColl.link_name());
       expect(arrColumnsData[0][2]).toEqual(lColl.type_name());
       expect(arrColumnsData[0][3]).toEqual(lColl.lanes());
       nodeB = lColl.begin_node();
       nodeE = lColl.end_node();
       expect(arrColumnsData[0][4]).toEqual(nodeB.name());
       expect(arrColumnsData[0][5]).toEqual(nodeE.name());
     });
   });
  //  describe("reDrawLink ", function() {
  //     it("should take link and redraw it after update called", function() {
  //       var oldLength = $a.linkList.length;
  //       var oldLink = $a.linkList.models[0];
  //       newLink = $a.linkList.reDrawLink(oldLink);
  //       expect(oldLink.crud()).toEqual($a.CrudFlag.DELETE);
  //       expect(newLink.crud()).toEqual($a.CrudFlag.CREATE);
  //       expect(newLink.link_name()).toEqual(oldLink.link_name());
  //       expect(newLink.lanes()).toEqual(oldLink.lanes());
  //       expect(newLink.lane_offset()).toEqual(oldLink.lane_offset());
  //       expect(newLink.in_sync()).toEqual(oldLink.in_sync());
  //       expect(newLink.type_name()).toEqual(oldLink.type_name());
  //       expect(newLink.type_id()).toEqual(oldLink.type_id());
  //       expect($a.linkList.length).toEqual(oldLength);
  //     });
  // });  
  describe("removeLink", function() {
    msg = "should remove a link from the collection as well as remove the ";
    msg += "link from its begin and end node input and output arrays." 
    it(msg, function() {
      var lengthBefore = this.lColl.length;
      var oLength = scen.link1.begin_node().outputs().length;
      var iLength = scen.link1.end_node().inputs().length;
      this.lColl.removeLink(scen.link1.cid);
      var afterOLength = scen.link1.begin_node().outputs().length;
      var afterILength = scen.link1.end_node().inputs().length;
      expect(oLength - 1).toEqual(afterOLength);
      expect(iLength - 1).toEqual(afterILength);
      expect(lengthBefore - 1).toEqual(this.lColl.length);

    });

    msg = "should remove a link without an error if begin or end node are ";
    msg += "missing from link";
    it(msg, function() {
      var removedNoError = true;
      try{
        scen.link1.set('begin', null);
        scen.link1.set('end', null);
        this.lColl.removeLink(scen.link1.cid);
      }catch(error) {
        removedNoError = false;
      }
      expect(removedNoError).toBeTruthy();
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
      var lengthBefore = this.lColl.length;
      this.lColl.splitLinkAddNode(scen.link1.cid, new google.maps.LatLng(0,0));
      expect(lengthBefore + 1).toEqual(this.lColl.length);
    });
  });
  describe("splitLinkByDistance", function() {
    it("should split a link by the distance", function() {
      var lengthBefore = this.lColl.length;
      this.lColl.splitLinkByDistance(scen.link1);
      expect(lengthBefore + 2).toEqual(this.lColl.length);
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
      expect(this.lColl.models[0].end_node()).toBeNull();
      scen.link1.set_end_node(end)
    });
  });
  
  describe("joinLink ", function() {
    it("should join links when node is removed", function() {
      links = this.lColl.models
      lBefore = links.length
      n = scen.node2
      args = {out:n.outputs(), in:n.inputs(), nodeId: n.id}
      this.lColl.joinLink(args);
      expect(lBefore - 1).toEqual(this.lColl.models.length);
    });
  });
  describe("duplicateLink ", function() {
    it("should create duplicate link", function() {
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