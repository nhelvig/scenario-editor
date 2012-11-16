describe("Output", function() {
  var testLinkId = 2;
  var testLink;
  var testOutput;

  beforeEach(function() {
    testLink = new window.beats.Link({id: testLinkId});
    testOutput = new window.beats.Output({link: testLink});
  });

  it("should not blow up on to_xml", function() {
    var doc = document.implementation.createDocument("document:xml", "output", null);
    var out = testOutput.to_xml(doc);
    expect(out).not.toBeNull();
  });

  it("should contain test link", function() {
    expect(testOutput.get('link')).toEqual(testLink);
  });

  it("should resolve link_id as link", function() {
    var o = new window.beats.Output({link_id: testLinkId});
    expectResolution(o, 'link', testLink);
  });

  it("should encode link reference as link_id", function() {
    // should not contain link_id at first
    expect(testOutput.get('link_id')).toBeUndefined();
    testOutput.encode_references();
    expect(testOutput.get('link_id')).toEqual(testLinkId);
  });
});