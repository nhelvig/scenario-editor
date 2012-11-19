describe("EditorSensorView", function() {
  $a = window.beats;
  
  beforeEach(function() {
    loadFixtures('editor.sensor.view.fixture.html');
    model = $a.models
.get('sensorlist').get('sensor')[0];
    spyOn($a.EditorSensorView.prototype, 'displayAtPos').andCallThrough();
    spyOn($a.EditorSensorView.prototype, 'save').andCallThrough();
    spyOn($a.EditorSensorView.prototype, 'saveLinks').andCallThrough();
    spyOn($a.EditorSensorView.prototype, 'saveGeo').andCallThrough();
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
      title = "Sensor Editor: " + this.view.models[0].get_road_names();
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
    it("produces the correct HTML", function() {
      sample = '<label for="sensor-link-type">Link Type</label>'
      expect(this.view.el.innerHTML).toContain(sample);
    });
    it("should should have correct type selected", function() {
      type = this.view.models[0].get('type');
      elem = $($(this.view.el).find('#sensor_type option:selected'));
      expect(elem).toHaveValue(type);
    });
    
    //checks that template was created correctly
    it("has the correct text content", function() {
      model = this.view.models[0];
      expect(this.view.$('#sensor_type')).toHaveValue(model.get('type'));
      link_type = model.get('link').get('type');
      expect(this.view.$('#sensor_link_type')).toHaveValue(link_type);
      links = model.get('link_reference').get('id')
      expect(this.view.$('#sensor_links')).toHaveValue(links);
      lat = model.get('position').get('point')[0].get('lat');
      expect(this.view.$('#sensor_lat')).toHaveValue(lat);
      lng = model.get('position').get('point')[0].get('lng');
      expect(this.view.$('#sensor_lng')).toHaveValue(lng);
      elev = model.get('position').get('point')[0].get('elevation').toString();
      expect(this.view.$('#sensor_elevation')).toHaveValue(elev);
    });
  });
 
  describe("Events", function() {
    beforeEach(function() {
      this.view.render();
      model = this.view.models[0];
      point = model.get('display_position').get('point')[0];
    });

    describe("When fields handler fired", function() {
      it("Sensor Tab: 'Sensor Type' field calls save", function() { 
        $('#sensor_type').blur();
        expect($a.EditorSensorView.prototype.save).toHaveBeenCalled();
      });
      it("Sensor Tab: 'Sensor Link Type' field calls save", function() { 
        $('#sensor_link_type').blur();
        expect($a.EditorSensorView.prototype.save).toHaveBeenCalled();
      });
      it("Sensor Tab: 'Links' field calls saveLinks", function() { 
        $('#sensor_links').blur();
        expect($a.EditorSensorView.prototype.saveLinks).toHaveBeenCalled();
      });
      it("Geo Tab: 'Latitude' field calls saveGeo", function() { 
        $('#sensor_lat').blur();
        expect($a.EditorSensorView.prototype.saveGeo).toHaveBeenCalled();
      });
      it("Geo Tab: 'Longitude' field calls saveGeo", function() { 
        $('#sensor_lng').blur();
        expect($a.EditorSensorView.prototype.saveGeo).toHaveBeenCalled();
      });
      it("Geo Tab: 'Elevation' field calls saveGeo", function() { 
        $('#sensor_elevation').blur();
        expect($a.EditorSensorView.prototype.saveGeo).toHaveBeenCalled();
      });
    });
    describe("When buttons clicked handler fired", function() {
      it("'Display at this position' button calls displayAtPos", function() { 
        $('#display-at-pos').click();
        expect($a.EditorSensorView.prototype.displayAtPos).toHaveBeenCalled();
      });
    });
    
    describe("When fields handlers fired their information is saved", function() {
        it("Sensor Tab: Type is saved", function() {
          expectSaveSelect({
            el: this.view.el,
            id: '#sensor_type',
            modelField: 'type',
            model: model
          });
        });
        it("Sensor Tab: Link Type is saved", function() {
          selected = $($(this.view.el)).find('#sensor_link_type option:selected');
          $(selected).attr('selected', false);
          options = $(this.view.el).find('#sensor_link_type option');
          $(options[8]).attr('selected', true);
          newSelectedValue = $(options[8]).val();
          $('#sensor_link_type').blur();
          expect(model.get('link').get('type')).toEqual(newSelectedValue);
        });
        it("Sensor Tab: Links are saved", function() {
          expectSave({
            id: '#sensor_links',
            modelField: 'id',
            model: model.get('link_reference')
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