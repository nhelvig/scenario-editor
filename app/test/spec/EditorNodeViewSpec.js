describe("EditorNodeView", function() {
  $a = window.sirius;
  
  beforeEach(function() {
    loadFixtures('editor.node.view.fixture.html');
    network = $a.scenario.get('networklist').get('network')[0];
    model = network.get('nodelist').get('node')[0];
    this.view = new $a.EditorNodeView({
      elem: 'node', 
      model: model});
  });
  
  describe("Instantiation", function() {
    it("should create a div element", function() {
      expect(this.view.el.nodeName).toEqual("DIV");
    });
    
    it("should should have id", function() {
      expect(this.view.el.id).toEqual("node-dialog-form-" + this.view.model.cid);
    });
    
    it("should should have title", function() {
      expect(this.view.el.title).toEqual("Node Editor: " + this.view.model.get('name'));
    });
    
    it("should should have correct type selected", function() {
      expect($($(this.view.el).find('#type option:selected')).val()).toEqual(this.view.model.get('type'));
    });
  });
  
  describe("Rendering", function() {
      it("returns the view object", function() {
        expect(this.view.render()).toEqual(this.view);
      });
    });
  
});