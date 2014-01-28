describe("EditorSensorView", function() {
  $a = window.beats;
  
  beforeEach(function() {
    loadFixtures('editor.sensor.view.fixture.html');
    model = scenarioAndFriends().scenario.sensors()[0];
    this.view = new $a.EditorSensorView({
      elem: 'sensor', 
      models: [model]
    });
  });
  
  afterEach(function() {
    this.view.remove();
  });
  
  describe("Instantiation", function() {
    it("should create a div element", function() {
      expect(this.view.el.nodeName.toLowerCase()).toEqual("div");
    });
    
    it('Is backed by a model instance', function() {
      expect(this.view.models).toBeDefined();
    });
    
    it("should should have id", function() {
      expect(this.view.el.id).toEqual("sensor-dialog-form-" + this.view.models[0].cid);
    });
  
    it("should should have title", function() {
      title = "Sensor Editor: " + this.view.models[0].road_names();
      expect(this.view.el.title).toEqual(title);
    });
  
  });
  
  describe("Rendering", function() {
    beforeEach(function() {
      this.view.render();
    });
    it("returns the view object", function() {
       expect(this.view.render()).toEqual(this.view);
    });
  
    it("should should have correct type selected", function() {
      type = this.view.models[0].type_id();
      elem = $($(this.view.el).find('#sensor_type option:selected'));
      expect(elem).toHaveValue(type);
    });
    
    //checks that template was created correctly
    it("has the correct text content", function() {
      model = this.view.models[0];
      elem = $($(this.view.el).find('#sensor_type option:selected'));
      expect(elem).toHaveText(model.type_name());
      links = model.get('link_reference').get('id')
      expect(this.view.$('#sensor_links')).toHaveValue(links);
      lat = model.display_lat();
      expect(this.view.$('#sensor_lat')).toHaveValue(lat);
      lng = model.display_lng();
      expect(this.view.$('#sensor_lng')).toHaveValue(lng);
      elev = model.display_elev().toString();
      expect(this.view.$('#sensor_elevation')).toHaveValue(elev);
    });
  });
   
  describe("Events", function() {
    beforeEach(function() {
      this.view.render();
      model = this.view.models[0];
      point = model.display_point();
    });
    
    describe("When fields handlers fired their information is saved", function() {
        it("Sensor Tab: Type is saved", function() {
          expectSaveSelect({
            el: this.view.el,
            id: '#sensor_type',
            modelField: 'id',
            model: model.get('sensor_type')
          });
        });
  
        it("Geo Tab: lat is saved", function() { 
          $('#sensor_lat').val("999");
          $("#sensor_lat").blur();
          expect(point.get('lat') == 999);
        });
        it("Geo Tab: lng is saved", function() {     
          $('#sensor_lng').val("999");
          $("#sensor_lng").blur();
          expect(point.get('lng') ==  999);
        });
        it("Geo Tab: elevation is saved", function() {     
          $('#sensor_elev').val("999");
          $("#sensor_elev").blur();
          expect(point.get('elevation')  == 999);
        });
    });
  });
});