describe("EditorSensorView", function() {
  $a = window.sirius;
  
  beforeEach(function() {
    loadFixtures('editor.sensor.view.fixture.html');
    model = $a.scenario.get('sensorlist').get('sensor')[0];
    spyOn($a.EditorSensorView.prototype, 'displayAtPos').andCallThrough();
    spyOn($a.EditorSensorView.prototype, 'save').andCallThrough();
    spyOn($a.EditorSensorView.prototype, 'saveLinks').andCallThrough();
    spyOn($a.EditorSensorView.prototype, 'saveDesc').andCallThrough();
    spyOn($a.EditorSensorView.prototype, 'saveTime').andCallThrough();
    spyOn($a.EditorSensorView.prototype, 'saveDataSource').andCallThrough();
    spyOn($a.EditorSensorView.prototype, 'saveGeo').andCallThrough();
    this.view = new $a.EditorSensorView({
      elem: 'sensor', 
      model: model
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
      expect(this.view.model).toBeDefined();
    });
    
    it("should should have id", function() {
      expect(this.view.el.id).toEqual("sensor-dialog-form-" + this.view.model.cid);
    });

    it("should should have title", function() {
      title = "Sensor Editor: " + this.view.model.get('name');
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
      desc = '<label for="sensor-desc">Description</label>'
      expect(this.view.el.innerHTML).toContain(desc);
    });
    it("should should have correct type selected", function() {
      type = this.view.model.get('type');
      elem = $($(this.view.el).find('#sensor_type option:selected'));
      expect(elem).toHaveValue(type);
    });
    
    it("should should have correct format selected", function() {
      type = model.get('data_sources').get('data_source')[0].get('format');
      elem = $($(this.view.el).find('#sensor_format option:selected'));
      expect(elem).toHaveValue(type);
    })
   
    //checks that template was created correctly
    it("has the correct text content", function() {
      model = this.view.model;
      desc = model.get('description').get('text');
      expect(this.view.$('#sensor_desc')).toHaveValue(desc);
      expect(this.view.$('#sensor_type')).toHaveValue(model.get('type'));
      expect(this.view.$('#sensor_link_type')).toHaveValue(model.get('link_type'));
      links = model.get('link_reference').get('id')
      expect(this.view.$('#sensor_links')).toHaveValue(links);
      dt = model.get('data_sources').get('data_source')[0].get('dt');
      step = $a.Util.convertSecondsToHoursMinSec(dt || 0);
      expect(this.view.$('#sensor_hour')).toHaveValue(step['h']);
      expect(this.view.$('#sensor_minute')).toHaveValue(step['m']);
      expect(this.view.$('#sensor_second')).toHaveValue(step['s']);
      url = model.get('data_sources').get('data_source')[0].get('url');
      expect(this.view.$('#sensor_url')).toHaveValue(url);
      lat = model.get('position').get('point')[0].get('lat');
      expect(this.view.$('#sensor_lat')).toHaveValue(lat);
      lng = model.get('position').get('point')[0].get('lng');
      expect(this.view.$('#sensor_lng')).toHaveValue(lng);
      elev = model.get('position').get('point')[0].get('elevation').toString();
      expect(this.view.$('#sensor_elev')).toHaveValue(elev);
    });
  });
 
  describe("Events", function() {
    beforeEach(function() {
      this.view.render();
      model = this.view.model;
      point = model.get('display_position').get('point')[0];
    });

    describe("When fields handler fired", function() {
      it("Sensor Tab: 'Description' field calls saveDesc", function() { 
        $('#sensor_desc').blur();
        expect($a.EditorSensorView.prototype.saveDesc).toHaveBeenCalled();
      });
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
      it("Data Tab: 'Time Step: hour' field calls saveTime", function() { 
        $('#sensor_hour').blur();
        expect($a.EditorSensorView.prototype.saveTime).toHaveBeenCalled();
      });
      it("Data Tab: 'Time Step: minute' field calls saveTime", function() { 
        $('#sensor_minute').blur();
        expect($a.EditorSensorView.prototype.saveTime).toHaveBeenCalled();
      });
      it("Data Tab: 'Time Step: second' field calls saveTime", function() { 
        $('#sensor_second').blur();
        expect($a.EditorSensorView.prototype.saveTime).toHaveBeenCalled();
      });
      it("Data Tab: 'Format' field calls saveDataSource", function() { 
        $('#sensor_format').blur();
        expect($a.EditorSensorView.prototype.saveDataSource).toHaveBeenCalled();
      });
      it("Data Tab: 'URL' field calls saveDataSource", function() { 
        $('#sensor_url').blur();
        expect($a.EditorSensorView.prototype.saveDataSource).toHaveBeenCalled();
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
        $('#sensor_elev').blur();
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
        it("Sensor Tab: Description is saved", function() {
          expectSave({
            id: '#sensor_desc',
            modelField: 'text',
            model: model.get('description')
          });
        });
        it("Sensor Tab: Type is saved", function() {
          expectSaveSelect({
            el: this.view.el,
            id: '#sensor_type',
            modelField: 'type',
            model: model
          });
        });
        it("Sensor Tab: Link Type is saved", function() {
          expectSaveSelect({
            el: this.view.el,
            id: '#sensor_link_type',
            modelField: 'link_type',
            model: model
          });
        });
        it("Sensor Tab: Links are saved", function() {
          expectSave({
            id: '#sensor_links',
            modelField: 'id',
            model: model.get('link_reference')
          });
        });
        it("Data Tab: Time Step is saved", function() {
          $("#sensor_hour").val(1);
          $("#sensor_minute").val(1);
          $("#sensor_second").val(1);
          $("#sensor_hour").blur();
          dt = model.get('data_sources').get('data_source')[0].get('dt');
          expect(dt).toEqual(3661);
        });
        it("Data Tab: URL are saved", function() {
          expectSave({
            id: '#sensor_url',
            modelField: 'url',
            model: model.get('data_sources').get('data_source')[0]
          });
        });
        it("Data Tab: Format is saved", function() {
          expectSaveSelect({
            el: this.view.el,
            id: '#sensor_format',
            modelField: 'format',
            model: model.get('data_sources').get('data_source')[0]
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