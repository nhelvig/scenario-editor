describe("Intersection", function() {
    var testNodeId = 2;
    var testNode;
    var testIntersection;

    beforeEach(function() {
	testNode = new window.sirius.Node({id: testNodeId});
	testIntersection = new window.sirius.Intersection({node: testNode});
    });

    it("should not blow up on to_xml", function() {
	var doc = document.implementation.createDocument("document:xml", "begin", null);
	var out = testIntersection.to_xml(doc); 
	expect(out).not.toBeNull();
    });

    it("should contain test node", function() {
	expect(testIntersection.get('node')).toEqual(testNode);
    });

    it("should resolve node_id as node", function() {
	var b = new window.sirius.Intersection({node_id: testNodeId});
	var deferred = [];
	var object_with_id = { 'node': [] };
	object_with_id.node[testNodeId] = testNode;
	expect(b.get('node')).toBeUndefined();
	b.resolve_references(deferred, object_with_id);
	runDeferred(deferred);
	expect(b.get('node')).toEqual(testNode);
    });

    it("should encode node reference as node_id", function() {
	// should not contain node_id at first
	expect(testIntersection.get('node_id')).toBeUndefined();
	testIntersection.encode_references();
	expect(testIntersection.get('node_id')).toEqual(testNodeId);
    })

});