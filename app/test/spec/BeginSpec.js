describe("Begin", function() {
    var testNode;
    var testBegin;

    beforeEach(function() {
	testNode = new window.sirius.Node({id: 2});
	testBegin = new window.sirius.Begin({node: testNode});
    });

    it("should not blow up on to_xml", function() {
	var doc = document.implementation.createDocument("document:xml", "begin");
	var out = testBegin.to_xml(doc) 
	expect(out).not.toBeNull();
    });

    it("should contain test node", function() {
	expect(testBegin.get('node')).toEqual(testNode);
    });
});