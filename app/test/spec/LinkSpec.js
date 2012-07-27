describe("Link", function() {
    var testNodeId = 2;
    var testNodeId2 = 3;
    var testNodeId3 = 4;
    var testNodeId4 = 5;

    var testNode, testNode2, testNode3, testNode4;
    var testLink1;
    var testLink2;

    // var simpleLink = function(node1, node2) {
    // 	var begin = new window.sirius.Begin({node: node1});
    // 	var end = new window.sirius.End({node: node2});
    // 	var link = new window.sirius.Link({begin: begin, end: end});
    // 	var output = [new window.sirius.Output({link: link})];
    // 	var outputs = new window.sirius.Outputs({output: output});
    // 	var input = [new window.sirius.Input({link: link})];
    // 	var inputs = new window.sirius.Inputs({input: input});
    // 	node1.set('outputs',outputs);
    // 	node2.set('inputs', inputs);
    // 	return link;
    // }

    beforeEach(function() {
	testNode = new window.sirius.Node({id: testNodeId});
	testNode2 = new window.sirius.Node({id: testNodeId2});
	testNode3 = new window.sirius.Node({id: testNodeId3});
	testLink1 = simpleLink(testNode, testNode2);
	testLink2 = simpleLink(testNode, testNode3);
	testLink3 = simpleLink(testNode, testNode3);
    });

    it("should not blow up on to_xml", function() {
	var doc = document.implementation.createDocument("document:xml", "begin", null);
	var out = testLink1.to_xml(doc);
	expect(out).not.toBeNull();
    });

    describe("parallel_links", function() {
	it("should return parallel links", function() {
	    expect(testLink2.parallel_links()).toContain(testLink3);
	});
	it("should not return non-parallel links", function() {
	    expect(testLink1.parallel_links()).not.toContain(testLink2);
	    expect(testLink1.parallel_links()).not.toContain(testLink3);
	});
    });
});