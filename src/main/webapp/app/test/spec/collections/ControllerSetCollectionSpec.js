  describe("ControllerSetCollection", function() {
  $a = window.beats;
  var models, cColl;
  
  beforeEach(function() {
    spyOn($a.ControllerSetCollection.prototype, 'addController').andCallThrough();
    spyOn($a.ControllerSetCollection.prototype, 'removeController').andCallThrough();
    models = scenarioAndFriends().scenario.controllers();
    cColl= new $a.ControllerSetCollection(models);
  });
  
  describe("Instantiation", function() {
    it("sets models to a collection of controllers", function() {
      expect(cColl.models).not.toBeNull();
    });
    it("sets all its models selected attribute to false", function() {
      mod = cColl.models;
      arrSel = mod.filter(function(sens){ return sens.selected() == false});
      expect(arrSel.length).toEqual(cColl.length);
    });
    it("should be watching addController", function() {
      $a.broker.trigger("controllers:add", new google.maps.LatLng(37,-122));
      expect($a.ControllerSetCollection.prototype.addController).toHaveBeenCalled();
    });
    it("should be watching removeController", function() {
      cColl.trigger("controllers:remove", cColl.models[0].cid);
      expect($a.ControllerSetCollection.prototype.removeController).toHaveBeenCalled();
    });
  });
  
   describe("getBrowserColumnData", function() {

   });

  describe("setSelected ", function() {
    it("should sets the select field to true", function() {
      mod = cColl.models;
      cColl.setSelected(mod);
      arrSel = mod.filter(function(sens){ return sens.selected() == true});
      expect(arrSel.length).toEqual(cColl.length);
    });
  });
  
  describe("addController ", function() {
    it("should create a new controller and add it to the collection", function() {
     var lengthBefore = cColl.length;
     var modelLengthBefore = $a.models.controllers().length;
     cColl.addController(new google.maps.LatLng(37,-122));
     expect(lengthBefore + 1).toEqual(cColl.length);
     expect(modelLengthBefore + 1).toEqual($a.models.controllers().length);
    });
  });
  describe("removeController ", function() {
    it("should remove it from collection and schema", function() {
     controller = cColl.addController(new google.maps.LatLng(37,-122));
     var lengthBefore = cColl.length;
     cColl.removeController(controller.cid);
     expect(lengthBefore - 1).toEqual(cColl.length);
    });
  });
});