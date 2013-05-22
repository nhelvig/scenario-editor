// I am not testing the _directionsRequest at this point except to 
// verify that the directionsService is set up.
describe("GoogleMapRouteHandler", function() {
  $a = window.beats;
  
  beforeEach(function() {
    links = $a.models.links();
    this.gmr = new $a.GoogleMapRouteHandler(links);
  });
  
  describe("Instantiation", function() {
    it("should create directions service", function() {
      expect(this.gmr.directionsService ).not.toBeNull();
    });
    it("should set stop to false", function() {
      expect(this.gmr.stop).toBeFalsy();
    });
    it("should be listening to stopDrawing", function() {
      spyOn($a.GoogleMapRouteHandler.prototype, 'stopDrawing');
      $a.broker.trigger('map:clear_map');
      expect($a.GoogleMapRouteHandler.prototype.stopDrawing).toHaveBeenCalled();
    });
    
  });

  describe("stopDrawing", function() {
     it("should set stop to true", function() {     
        this.gmr.stopDrawing();
        expect(this.gmr.stop).toBeTruthy();
     });
   });
  
  describe("setUpLink", function() {
     it('should set up link for directions request', function() {     
       link = this.gmrh.links[0]
       this.gmrh.setUpLink(link);
       expect(link.request).not.toBeNull();
       expect(link.request).not.toBeNull();

     });
   });
  //  
  //  describe("_isOverQuery", function() {
  //    beforeEach(function() {
  //      gStatus = google.maps.DirectionsStatus;
  //    });
  //    it("should be true if status over query limit", function() {
  //      flag = this.gmrh._isOverQuery(gStatus.OVER_QUERY_LIMIT);
  //      expect(flag).toBeTruthy();
  //    });
  //    it("should be false if status not over query limit", function() {
  //      flag = this.gmrh._isOverQuery(gStatus.OK);
  //      expect(flag).not.toBeTruthy();
  //    });
  //  });
});
