// I am not testing the _directionsRequest at this point except to 
// verify that the directionsService is set up.
describe("GoogleMapRouteHandler", function() {
  $a = window.sirius;
  
  beforeEach(function() {
    linklist = $a.scenario.get('networklist').get('network')[0].get('linklist');
    links = linklist.get('link');
    gmr = $a.GoogleMapRouteHandler
    spyOn(gmr.prototype, '_directionsRequest').andCallThrough();
    this.gmrh = new $a.GoogleMapRouteHandler(links);
  });
  
  describe("Instantiation", function() {
    it("should create directions service", function() {
      expect(this.gmrh).not.toBeNull();
    });
  });
  
  describe("setUpLink", function() {
    it("should call directionRequest if no geometry", function() {     
      grh = $a.GoogleMapRouteHandler
      link = this.gmrh.links[0]
      link.set('linkgeometry', null);
      this.gmrh.setUpLink(link);
      expect(grh.prototype._directionsRequest).toHaveBeenCalled();
    });
  });
  
  describe("_isOverQuery", function() {
    beforeEach(function() {
      gStatus = google.maps.DirectionsStatus;
    });
    it("should be true if status over query limit", function() {
      flag = this.gmrh._isOverQuery(gStatus.OVER_QUERY_LIMIT);
      expect(flag).toBeTruthy();
    });
    it("should be false if status not over query limit", function() {
      flag = this.gmrh._isOverQuery(gStatus.OK);
      expect(flag).not.toBeTruthy();
    });
  });
});
