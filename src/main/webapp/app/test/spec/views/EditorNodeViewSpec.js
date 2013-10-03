describe("EditorNodeView", function() {
  $a = window.beats;
  
  beforeEach(function() {
    loadFixtures('editor.node.view.fixture.html');
    scen = scenarioAndFriends();
    model = scen.node1
    spyOn($a.EditorNodeView.prototype, 'signalEditor').andCallThrough();
    spyOn($a.EditorNodeView.prototype, 'chooseName').andCallThrough();
    spyOn($a.EditorNodeView.prototype, 'removeJoinLinks').andCallThrough();
    this.view = new $a.EditorNodeView({
      elem: 'node', 
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
      expect(this.view.el.id).toEqual("node-dialog-form-" + this.view.models[0].cid);
    });
  
    it("should should have title", function() {
      title = "Node Editor: " + this.view.models[0].road_names();
      expect(this.view.el.title).toEqual(title);
    });
  });
  
  describe("Rendering", function() {
    beforeEach(function() {
        this.v = this.view.render();
    });
    it("returns the view object", function() {
      expect(this.v).toEqual(this.view);
    });
    
    it("produces the correct HTML", function() {
      expect(this.view.el.innerHTML).toContain('<label for="name">Name</label>');
    });
    
    it("should should have correct type selected", function() {
      type = this.view.models[0].node_type().name();
      expected = $($(this.view.el).find('#type option:selected')).attr("name");
      expect(expected.toLowerCase()).toEqual(type);
    });
    
    //checks that template was created correctly
    //Note: the elevation check force NaN to a string
    it("has the correct text content", function() {
      expect(this.view.$('#name')).toHaveValue(model.name());
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
       $(this.view.el).find(":input").prop("disabled", false)
       this.point = this.view.models[0].get('position').get('point')[0]
     });
 
     describe("When name and type blur handler fired", function() {
       it("name is saved", function() {
         $('#name').val("Name Changed");
         $("#name").blur();
         expect(this.view.models[0].name()).toEqual("Name Changed");
       });
       it("type is saved", function() {
         selected = $($(this.view.el)).find('#type option:selected')
         $(selected).attr('selected', false);
         options = $(this.view.el).find("select option");
         $(options[1]).attr('selected', true);
         newSelectedValue = $(options[1]).attr("name");
         $("#type").blur();            
         expect(this.view.models[0].type_name()).toEqual(newSelectedValue); 
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
         expect(this.view.models[0].get('lock')).toBeTruthy();
       });
     });
 
     describe("When buttons clicked handler fired", function() {
       it("edit-signal button calls signalEditor unless disabled", function() {
         if(!($('#edit-signal').is(':disabled'))) {
           $('#edit-signal').click();
           expect($a.EditorNodeView.prototype.signalEditor).toHaveBeenCalled();
         }
       });
       it("choose-name button calls chooseName", function() {
         if(!($('#choose-name').is(':disabled'))) {
           $('#choose-name').click();
           expect($a.EditorNodeView.prototype.chooseName).toHaveBeenCalled();
         }
       });
       it("remove-join-links button calls removeJoinLinks", function() {
        if(!($('#remove-join-links').is(':disabled'))) {
          $('#remove-join-links').click();
          expect($a.EditorNodeView.prototype.removeJoinLinks).toHaveBeenCalled();
        }
       });
     });
   });
});