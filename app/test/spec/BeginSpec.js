describe("Begin", function() {
    var testNodeId = 2;
    var testNode;
    var testBegin;

    beforeEach(function() {
	testNode = new window.sirius.Node({id: testNodeId});
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

    it("should encode node reference as node_id", function() {
	// should not contain node_id at first
	expect(testBegin.get('node_id')).toBeUndefined();
	testBegin.encode_references();
	expect(testBegin.get('node_id')).toEqual(testNodeId);
    })
});