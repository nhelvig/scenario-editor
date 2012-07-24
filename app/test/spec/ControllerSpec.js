describe("Controller", function() {
    var testNodeId = 2;
    var testLinkId = 3;
    var testOtherControllerId = 4;
    var testSensorId = 5;
    var testEventId = 6;
    var testSignalId = 7;
    var testNode;
    var testController;
    
    var loadTargetReferences = function() {
	var targetRefs = [];
	targetRefs.push({type: 'node', id: testNodeId})
	targetRefs.push({type: 'link', id: testLinkId});
	targetRefs.push({type: 'controller', id: testOtherControllerId});
	targetRefs.push({type: 'sensor', id: testSensorId});
	targetRefs.push({type: 'event', id: testEventId});
	targetRefs.push({type: 'signal', id: testSignalId});
	return targetRefs;
    };

    beforeEach(function() {
	testNode = new window.sirius.Node({id: testNodeId});
	testController = new window.sirius.Controller({node: testNode});
    });

    it("should not blow up on to_xml", function() {
	var doc = document.implementation.createDocument("document:xml", "begin");
	var out = testController.to_xml(doc); 
	expect(out).not.toBeNull();
    });

    describe("reference resolution", function() {
	beforeEach(function() {
	    testController.set('targetelements', new Backbone.Model());
	    testController.get('targetelements').set('scenarioElement', loadTargetReferences());
	})
	it("for nodes", function() {});
	it("for links", function() {});
	it("for controllers", function() {});
	it("for sensors", function() {});
	it("for events", function() {});
	it("for signals", function() {});
    });
});