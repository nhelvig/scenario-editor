describe("Signal", function() {
    var testNodeId = 2;
    var testNode;
    var testSignal;

    beforeEach(function() {
	testNode = new window.sirius.Node({id: testNodeId});
	testSignal = new window.sirius.Signal({node: testNode});
    });

    it("should not blow up on to_xml", function() {
	var doc = document.implementation.createDocument("document:xml", "begin", null);
	var out = testSignal.to_xml(doc); 
	expect(out).not.toBeNull();
    });

    it("should contain test node", function() {
	expect(testSignal.get('node')).toEqual(testNode);
    });

    it("should resolve node_id as node", function() {
	var s = new window.sirius.Signal({node_id: testNodeId});
	var deferred = [];
	var object_with_id = { 'node': [] };
	object_with_id.node[testNodeId] = testNode;
	expect(s.get('node')).toBeUndefined();
	s.resolve_references(deferred, object_with_id);
	runDeferred(deferred);
	expect(s.get('node')).toEqual(testNode);
    });

    it("should encode node reference as node_id", function() {
	// should not contain node_id at first
	expect(testSignal.get('node_id')).toBeUndefined();
	testSignal.encode_references();
	expect(testSignal.get('node_id')).toEqual(testNodeId);
    })
});