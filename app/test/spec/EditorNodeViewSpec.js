describe("EditorNodeView", function() {
  $a = window.sirius;
  
  beforeEach(function() {
    loadFixtures('editor.node.view.fixture.html');
    network = $a.scenario.get('networklist').get('network')[0];
    model = network.get('nodelist').get('node')[0];
    spyOn($a.EditorNodeView.prototype, 'signalEditor').andCallThrough();
    spyOn($a.EditorNodeView.prototype, 'chooseName').andCallThrough();
    spyOn($a.EditorNodeView.prototype, 'removeJoinLinks').andCallThrough();
    this.view = new $a.EditorNodeView({
      elem: 'node', 
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
      expect(this.view.el.id).toEqual("node-dialog-form-" + this.view.model.cid);
    });

    it("should should have title", function() {
      title = "Node Editor: " + this.view.model.get('name');
      expect(this.view.el.title).toEqual(title);
    });

    it("should should have correct type selected", function() {
      type = this.view.model.get('type');
      expect($($(this.view.el).find('#type option:selected'))).toHaveValue(type);
    });
  });
  
  describe("Rendering", function() {
    it("returns the view object", function() {
      expect(this.view.render()).toEqual(this.view);
    });
    
    it("produces the correct HTML", function() {
      this.view.render();
      expect(this.view.el.innerHTML).toContain('<label for="name">Name</label>');
    });
    
    //checks that template was created correctly
    //Note: the elevation check adds '+ ""' to force NaN to a string
    it("has the correct text content", function() {
      model = this.view.model;
      expect(this.view.$('#name')).toHaveValue(model.get('name'));
      expect(this.view.$('#descripton')).toHaveValue(model.get('description'));
      lat = model.get('position').get('point')[0].get('lat');
      expect(this.view.$('#lat')).toHaveValue(lat);
      lng = model.get('position').get('point')[0].get('lng');
      expect(this.view.$('#lng')).toHaveValue(lng);
      elev = model.get('position').get('point')[0].get('elevation').toString();
      expect(this.view.$('#elevation')).toHaveValue(elev);
    });
  });

  describe("Events", function() {
    beforeEach(function() {
      this.view.render();
      this.point = this.view.model.get('position').get('point')[0]
    });

    describe("When name, description, and type blur handler fired", function() {
      it("name is saved", function() {     
        $('#name').val("Name Changed");
        $("#name").blur();
        expect(this.view.model.get('name')).toEqual("Name Changed");
      });
      it("description is saved", function() {
        $('#description').val("Changed");
        $("#description").blur();
        expect(this.view.model.get('description')).toEqual("Changed");
      });
      it("type is saved", function() {
        selected = $($(this.view.el)).find('#type option:selected')
        $(selected).attr('selected', false);
        options = $(this.view.el).find("select option");
        $(options[1]).attr('selected', true);
        newSelectedValue = $(options[1]).val();
        $("#type").blur();            
        expect(this.view.model.get('type')).toEqual(newSelectedValue); 
      });
    });

    describe("When lat, lng, elevation blur handler fired", function() {
      it("lat is saved", function() {     
        $('#lat').val("999");
        $("#lat").blur();
        expect(this.point.get('lat') == 999);
      });
      it("lng is saved", function() {     
        $('#lng').val("999");
        $("#lng").blur();
        expect(this.point.get('lng') ==  999);
      });
      it("elevation is saved", function() {     
        $('#elevation').val("999");
        $("#elevation").blur();
        expect(this.point.get('elevation')  == 999);
      });
    });

    describe("When the lock click handler fired", function() {
      it("lock is saved", function() { 
        $('#lock').attr('checked', 'checked'); 
        $('#lock').click();
        expect(this.view.model.get('lock')).toBeTruthy();
      });
    });

    describe("When buttons clicked handler fired", function() {
      it("edit-signal button calls editSignal", function() { 
        $('#edit-signal').click();
        expect($a.EditorNodeView.prototype.signalEditor).toHaveBeenCalled();
      });
      it("choose-name button calls chooseName", function() { 
        $('#choose-name').click();
        expect($a.EditorNodeView.prototype.chooseName).toHaveBeenCalled();
      });
      it("remove-join-links button calls removeJoinLinks", function() { 
        $('#remove-join-links').click();
        expect($a.EditorNodeView.prototype.removeJoinLinks).toHaveBeenCalled();
      });
    });
  });
});