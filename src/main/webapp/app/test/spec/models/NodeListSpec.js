describe("NodeList", function() {
  describe("to_xml", function() {
    beforeEach(function() {
      doc = document.implementation.createDocument("document:xml", "begin", null);
      window.beats.models.nodes()[0].set_crud(window.beats.CrudFlag.DELETE);
      out =  window.beats.models.network().get('nodelist').to_xml(doc);
    });
    afterEach(function() {
      _.map(window.beats.models.nodes(), function(node) {
        node.set_crud(window.beats.CrudFlag.NONE);
      });
    });
    it("should not blow up on to_xml", function() {
      expect(out).not.toBeNull();
    });
    it("should not contain deleted nodes", function() {
      nodesNumber = out.childNodes.length  
      expect(nodesNumber).toEqual(window.beats.models.nodes().length  - 1)
    });
  });
});