describe("MapLinkView", function() {
  var $a = window.beats;
  var network, model, legs;
  
  beforeEach(function() {
    loadFixtures('context.menu.view.fixture.html');
    network = $a.scenario.get('networklist').get('network')[0];
    model = network.get('linklist').get('link')[0];

    expectedEncodedPath = "}r}eF`bmiVuGn@c@DwIhAiBT";
    model.legs = [
      {
        steps: [
          {
            path: [
              new google.maps.LatLng(37.83999, -122.29681000000001),
              new google.maps.LatLng(37.84138, -122.29705000000001),
              new google.maps.LatLng(37.84156, -122.29708000000001),
              new google.maps.LatLng(37.84328, -122.29745000000001),
              new google.maps.LatLng(37.84381000000001, -122.29756)
            ]
          }
        ]
      }
    ]
    spyOn($a.MapLinkView.prototype, 'clearSelected').andCallThrough();
    spyOn($a.MapLinkView.prototype, '_triggerClearSelectEvents').andCallThrough();
    spyOn($a.MapLinkView.prototype, 'linkSelect').andCallThrough();
    this.view = new $a.MapLinkView(model, network);
  });
  
  afterEach(function() {
    this.view.remove();
  }); 
  
  describe("Instantiation", function() {
    it("should encode the path", function() {
      expect(this.view.encodedPath).toEqual(expectedEncodedPath);
    });
    
    it("should save encoded the path to linkgeometry", function() {
      lg = this.view.model.get('linkgeometry');
      encodedPath = lg.get('encodedpolyline').get('points').get('text');
      expect(encodedPath).toEqual(expectedEncodedPath);
    });

    it("should have made polyline object", function() {
      link = this.view.link
      expect(link).not.toBe(null);
    });

    it("should have made context menu for itself", function() {
      cm = model.get('contextMenu');
      expect(cm).not.toBe(null);
      menuItemLabels = _.pluck(cm.options.menuItems, 'label');
      dataItemLabels = $a.link_context_menu;
      if(this.view.model.get('demand') !== null)
        dataItemLabels.push($a.link_context_menu_demand_item[0]);
      
      expect(menuItemLabels).toEqual(_.pluck(dataItemLabels,'label'));
    });
  });
  
  describe("Rendering", function() {
    it("should return the view object", function() {
      expect(this.view.render()).toEqual(this.view);
    });
    
    it("should set its links map", function() {
      this.view.render();
      expect(this.view.link.getMap()).toEqual($a.map)
    });
  });
  
  describe("Events", function() {

      describe("When map:init fired -> render sets map of link", function() {
        beforeEach(function() {
          googleMap(); 
        });
        it("should set the links map", function() {
          $a.broker.trigger("map:init");
          expect(this.view.link.getMap()).toEqual($a.map);
        });
      });
      
      describe("When hideLink is called set links map to null", function() { 
        it("triggered by map:hide_link_layer", function() {
          $a.broker.trigger("map:hide_link_layer");
          expect(this.view.link.getMap()).toEqual(null);
        });
        it("triggered by map:links:hide_{this_type}", function() {
          selected = this.view.model.get('type');
          $a.broker.trigger("map:links:hide_" + selected);
          expect(this.view.link.getMap()).toEqual(null);
        });
      });
      
      describe("When showLink called set links map to the map:", function() {
        beforeEach(function() {
          googleMap(); 
        });
        it("triggered by map:show_link_layer", function() {
          $a.broker.trigger("map:show_link_layer");
          expect(this.view.link.getMap()).toEqual($a.map);
        });
        it("triggered by map:links:show_{this_type}", function() {
          selected = this.view.model.get('type');
          $a.broker.trigger("map:links:show_" + selected);
          expect(this.view.link.getMap()).toEqual($a.map);
        });
      });
      
      describe("When linkSelected called set link color red:", function() {
        beforeEach(function() {
          expectedColor = $a.MapLinkView.SELECTED_LINK_COLOR
        });
        it("triggered by map:select_item:#{model.cid}", function() {
          $a.broker.trigger("map:select_item:" + model.cid);
          expect(this.view.link.strokeColor).toEqual(expectedColor);
        });
        it("triggered by map:select_network", function() {
          $a.broker.trigger("map:select_network:" + network.cid);
          expect(this.view.link.strokeColor).toEqual(expectedColor);
        });
      });
      describe("When clearSelected called set link color blue:", function() {
        beforeEach(function() {
          expectedColor = $a.MapLinkView.LINK_COLOR
        });
        it("triggered by map:clear_item:#{model.cid}", function() {
          $a.broker.trigger("map:clear_item:" + model.cid);
          expect(this.view.link.strokeColor).toEqual(expectedColor);
        });
        it("triggered by map:clear_network", function() {
          $a.broker.trigger("map:clear_network:" + network.cid);
          expect(this.view.link.strokeColor).toEqual(expectedColor);
        });
        it("triggered by map:clear_selected", function() {
          $a.broker.trigger("map:clear_selected");
          expect(this.view.link.strokeColor).toEqual(expectedColor);
        });
      });
      describe("When removeLink called:", function() {
        it("triggered by map:clear_map", function() {
            $a.broker.trigger("map:clear_map")
            expect(this.view.link).toEqual(null);
        });
      });
      describe("When selectSelfandMyNodes called", function() {
        it("should have been triggered map:select_neighbors:#{@model.cid}", function() {
            $a.broker.trigger("map:select_neighbors:" + model.cid)
            expect($a.MapLinkView.prototype._triggerClearSelectEvents).toHaveBeenCalled();
            expect($a.MapLinkView.prototype.clearSelected).toHaveBeenCalled();
        });
      });
      describe("When clearSelfandMyNodes called", function() {
        it("triggered by map:clear_neighbors:#{@model.cid}", function() {
            $a.broker.trigger("map:clear_neighbors:" + model.cid);
            expect($a.MapLinkView.prototype.clearSelected).toHaveBeenCalled();
        });
      });
  });
});