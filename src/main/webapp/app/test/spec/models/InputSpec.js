describe("Input", function() {
  var testLinkId = 2;
  var testLink;
  var testInput;
  
  beforeEach(function() {
    testLink = new window.beats.Link({id: testLinkId});
    testInput = new window.beats.Input({link: testLink});
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
    var i = new window.beats.Input({link_id: testLinkId});
    expectResolution(i, 'link', testLink);
  });
  
  it("should encode link reference as link_id", function() {
    // should not contain link_id at first
    expect(testInput.get('link_id')).toBeUndefined();
    testInput.encode_references();
    expect(testInput.get('link_id')).toEqual(testLinkId);
  });
});