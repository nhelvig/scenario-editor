describe("LinkList", function() {
  describe("to_xml", function() {
    beforeEach(function() {
      doc = document.implementation.createDocument("document:xml", "begin", null);
      window.beats.models.links()[0].set_crud(window.beats.CrudFlag.DELETE);
      out =  window.beats.models.network().get('linklist').to_xml(doc);
    });
    afterEach(function() {
      _.map(window.beats.models.links(), function(link) {
        link.set_crud(window.beats.CrudFlag.NONE);
      });
    });
    it("should not blow up on to_xml", function() {
      expect(out).not.toBeNull();
    });
    it("should not contain deleted links", function() {
      linksNumber = out.childNodes.length  
      expect(linksNumber).toEqual(window.beats.models.links().length  - 1)
    });
  });
});