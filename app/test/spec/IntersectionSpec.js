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
	var i = new window.sirius.Intersection({node_id: testNodeId});
	expectResolution(i, 'node', testNode);
    });

    it("should encode node reference as node_id", function() {
	// should not contain node_id at first
	expect(testIntersection.get('node_id')).toBeUndefined();
	testIntersection.encode_references();
	expect(testIntersection.get('node_id')).toEqual(testNodeId);
    })

});