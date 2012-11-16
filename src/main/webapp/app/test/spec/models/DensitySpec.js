describe("Density", function() {
  var testLinkId = 2;
  var testLink;
  var testDensity;

  beforeEach(function() {
    testLink = new window.beats.Link({id: testLinkId});
    testDensity = new window.beats.Density({link: testLink});
  });

  it("should not blow up on to_xml", function() {
    var doc = document.implementation.createDocument("document:xml", "begin", null);
    var out = testDensity.to_xml(doc); 
    expect(out).not.toBeNull();
  });

  it("should contain test link", function() {
    expect(testDensity.get('link')).toEqual(testLink);
  });

  it("should resolve link_id as link", function() {
    var d = new window.beats.Density({link_id: testLinkId});
    expectResolution(d, 'link', testLink);
  });

  it("should encode link reference as link_id", function() {
    // should not contain link_id at first
    expect(testDensity.get('link_id')).toBeUndefined();
    testDensity.encode_references();
    expect(testDensity.get('link_id')).toEqual(testLinkId);
  });
});
