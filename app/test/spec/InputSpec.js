describe("Input", function() {
    var testLinkId = 2;
    var testLink;
    var testInput;

    beforeEach(function() {
	testLink = new window.sirius.Link({id: testLinkId});
	testInput = new window.sirius.Input({link: testLink});
    });

    it("should not blow up on to_xml", function() {
	var doc = document.implementation.createDocument("document:xml", "input", null);
	var out = testInput.to_xml(doc); 
	expect(out).not.toBeNull();
    });

    it("should contain test link", function() {
	expect(testInput.get('link')).toEqual(testLink);
    });

    it("should resolve link_id as link", function() {
	var i = new window.sirius.Input({link_id: testLinkId});
	var deferred = [];
	var object_with_id = { 'link': [] };
	object_with_id.link[testLinkId] = testLink;
	expect(i.get('link')).toBeUndefined();
	i.resolve_references(deferred, object_with_id);
	runDeferred(deferred);
	expect(i.get('link')).toEqual(testLink);
    });

    it("should encode link reference as link_id", function() {
	// should not contain link_id at first
	expect(testInput.get('link_id')).toBeUndefined();
	testInput.encode_references();
	expect(testInput.get('link_id')).toEqual(testLinkId);
    })

});