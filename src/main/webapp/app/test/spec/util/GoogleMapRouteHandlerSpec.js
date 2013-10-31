// I am not testing the _directionsRequest at this point except to 
// verify that the directionsService is set up.
describe("GoogleMapRouteHandler", function() {
  $a = window.beats;
  
  beforeEach(function() {
    links = $a.models.links();
    gmr = new $a.GoogleMapRouteHandler(links);
    l = gmr.links[0];
  });
  
  describe("Instantiation", function() {
    it("should create directions service", function() {
      expect(gmr.directionsService ).not.toBeNull();
    });
    it("stop should be false", function() {
      expect(gmr.stop).toBeFalsy();
    });
    it("map:clear_map should be listening to stopDrawing", function() {
      afterEach(function(){
        gmr.stop = false;
      })
      runs(function() {
         flag = false;
         $a.broker.trigger('map:clear_map');
         setTimeout(function() {flag = true;}, 500);
       });
       waitsFor(function() {
         return flag;
       }, "should have called stopDrawing by now", 750);
       runs(function() { 
         expect(gmr.stop).toBeTruthy();
       });
    });
    
  });

  describe("stopDrawing", function() {
     afterEach(function(){
       gmr.stop = false;
     })
     it("should set stop to true", function() {     
        gmr.stopDrawing();
        expect(gmr.stop).toBeTruthy();
     });
   });
  
  describe("setUpLink", function() {
     it('should set up link for directions request', function() {     
       gmr.setUpLink(l);
       expect(l.request).not.toBeNull(l);
       expect(l.request.origin).toEqual($a.Util.getLatLng(l.begin_node()));
       expect(l.request.destination).toEqual($a.Util.getLatLng(l.end_node()));
       expect(l.request.travelMode).toEqual(google.maps.TravelMode.DRIVING);
     });
   });
   
   describe("_isOverQuery", function() {
     beforeEach(function() {
       gStatus = google.maps.DirectionsStatus;
     });
     it("should be true if status over query limit", function() {
       flag = gmr._isOverQuery(gStatus.OVER_QUERY_LIMIT);
       expect(flag).toBeTruthy();
     });
     it("should be false if status not over query limit", function() {
       flag = gmr._isOverQuery(gStatus.OK);
       expect(flag).not.toBeTruthy();
     });
   });
   
   describe("geomDoesNotExist", function() {
      beforeEach(function(){
        geometry = l.geometry();
        position = l.position();
      });
      afterEach(function(){
        l.set_geometry(geometry);
        l.set_position(position);
      })
     it('should test to see if geometry exists', function() {     
       flag = gmr._geomDoesNotExist(l)
       expect(flag).toBeFalsy();
       
       l.set_geometry(null);
       l.set_position(null);
       flag = gmr._geomDoesNotExist(l);
       expect(flag).toBeTruthy();
     });
   });
   
   describe("directionsRequest and directionsRequestOneLink", function() {
      beforeEach(function(){
        geometry = l.geometry();
        position = l.position();
        l.set_geometry(null);
        l.set_position(null);
        l.request = {
          origin: new google.maps.LatLng(37.8667059136, -122.29724049568),
          destination: new google.maps.LatLng(37.8636076312, -122.2843974655),
          travelMode: google.maps.TravelMode.DRIVING
        };
      });
      afterEach(function(){
        //
      })
     // it('directionsRequest: should have link position set', function() {
     //        runs(function() {
     //          flag = false;
     //          gmr._directionsRequest(l);
     //          setTimeout(function() {flag = true;}, 1000);
     //        });
     //        waitsFor(function() {
     //          return flag;
     //        }, "The request should be done", 1500);
     //        runs(function() { 
     //          expect(l).not.toBeNull();
     //          expect(l.position()).not.toBeNull();
     // 
     //          // Set back geom and position
     //          l.set_geometry(geometry);
     //          l.set_position(position);
     //        });
     //      });
     //      
     //      var msg = 'directionsRequestOneLink: should have link position set ';
     //      msg += 'and no duplicate points';
     //      it(msg , function() {
     //        runs(function() {
     //          flag = false;
     //          gmr._directionsRequestOneLink(l);
     //          setTimeout(function() {flag = true;}, 1000);
     //        });
     //        waitsFor(function() {
     //          return flag;
     //        }, "The request should be done", 1500);
     //        runs(function() {
     //          expect(l).not.toBeNull();
     //          expect(l.position()).not.toBeNull();
     // 
     //          // Checked the route request defined in beforeEach and it returns 3 duplicate lat,longs
     //          // but 50 unique lat and longs - so ensure only 50 are kept
     //          expect(l.position().length).toBe(50);
     //          
     //          // Set back geom and position
     //          l.set_geometry(geometry);
     //          l.set_position(position);
     //        });
     //      });
   });
   
});
