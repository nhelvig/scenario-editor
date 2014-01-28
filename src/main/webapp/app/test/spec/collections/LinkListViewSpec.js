describe("LinkListView", function() {
  $a = window.beats;
  var models, network, begin, end, scen;
  
  beforeEach(function() {
    loadFixtures('context.menu.view.fixture.html');
    googleMap();
    scen = scenarioAndFriends().scenario;
    network = scen.network();
    models = scen.links();
    spyOn($a.LinkListView.prototype, 'addAndRender').andCallThrough();
    spyOn($a.LinkListView.prototype, 'createAndDrawLink').andCallThrough();
    spyOn($a.LinkListView.prototype, 'resetPath').andCallThrough();
    spyOn($a.LinkListView.prototype, 'removeLink').andCallThrough();
    spyOn($a.LinkListView.prototype, 'setStrokeWeight').andCallThrough();
    this.lColl = new $a.LinkListCollection(models, network);
    this.view = new $a.LinkListView(this.lColl, network);
    begin = models[0].begin_node();
    end = models[0].end_node();
    
  });
    
  describe("Instantiation", function() {
           it("sets all its collection and network attributes", function() {
              expect(this.view.collection).not.toBeNull();
              expect(this.view.network).not.toBeNull();
            });
            
            it("should be watching addAndRender", function() {
                l = scen.links()[0];
                args = {begin:l.begin_node(),end:l.end_node(),path:l.geometry(), parallel:true};
                link = this.lColl.addLink(args);
                args = {begin:l.begin_node(),end:l.end_node(),path:l.geometry(), parallel:true};
                link = this.lColl.addLink(args);
                expect($a.LinkListView.prototype.addAndRender).toHaveBeenCalled();
                this.lColl.removeLink(link.cid);
            });
        
            it("should be watching resetPath", function() {
                link = this.lColl.models[0];
                latLng = new google.maps.LatLng(37.8579, -122.2995);
                runs(function() {
                    flag = false;
                    link.begin_node().updatePosition(latLng);
                    setTimeout(function() {flag = true;}, 1000);
                });
                waitsFor(function() {
                  return flag;
                }, "The request should be done", 1500);
                runs(function() { 
                  expect($a.LinkListView.prototype.resetPath).toHaveBeenCalled();
                });
             });   
           it("should be watching createAndDrawLink", function() {
             $a.broker.trigger('map:draw_link', models[0]);
             expect($a.LinkListView.prototype.createAndDrawLink).toHaveBeenCalled();
           });
           
           it("should be watching removeLink", function() {
             this.lColl.trigger('remove', models[0]);
             expect($a.LinkListView.prototype.removeLink).toHaveBeenCalled();
           });
           it("should be watching setStrokeWeight", function() {
             $a.map.setZoom(9)
             expect($a.LinkListView.prototype.setStrokeWeight).toHaveBeenCalled();
           });
           it("should call getLinkGeometry, create GoogleRouteHandler", function() {
             expect(this.view.routeHandler).not.toBeNull();
           });
     });
   
   describe("createAndDrawLink", function() {
     it("should create MapLinkViews for link", function() {
       mlv = this.view.createAndDrawLink(models[0]);
       expect(mlv).not.toBeNull();
       expect(mlv.link.getMap()).toEqual($a.map);
     });
   });
     
   describe("addAndRender", function() {
     it("should create a MapNodeView and render it", function() {
       newLink = simpleLink(1, begin, end);
       link = this.view.addAndRender(newLink, true);
       expect(link.get('linkgeometry')).not.toBeNull();
     });
   });
   
  describe("removeLink", function() {
    afterEach(function() {
      this.view.createAndDrawLink(models[0]);
    });
    it("should remove the MapLinkView from views array", function() {
      scen = scenarioAndFriends();
      this.view.createAndDrawLink(scen.link4);
      var lengthBefore = this.view.views.length;
      this.view.removeLink(scen.link4);
      expect(this.view.views.length).toEqual(lengthBefore - 1);
    });
  });
   describe("setStrokeWeight", function() {
    it("should set link stroke weight dependent on zoom level", function() {
      scen = scenarioAndFriends();
      this.view.createAndDrawLink(models[0]);
      googleMap();
      $a.map.setZoom(18);
      this.view.setStrokeWeight();
      var l =  this.view.views[0].link
      var weight  = l.get('strokeWeight');
      expect(weight).toEqual(7);
    });
  }); 
});