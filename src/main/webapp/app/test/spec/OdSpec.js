describe("Od", function() {
  var testBNodeId = 1, testENodeId = 2;
  var testBNode, testENode, testBegin, testEnd, testOd;
  
  beforeEach(function() {
    testBNode = new window.sirius.Node({id: testBNodeId});
    testENode = new window.sirius.Node({id: testENodeId});
    testOd = new window.sirius.Od({begin_node: testBNode, end_node: testENode});
  });
  
  it("should not blow up on to_xml", function() {
    var doc = document.implementation.createDocument("document:xml", "Od", null);
    var out = testOd.to_xml(doc); 
    expect(out).not.toBeNull();
  });
  
  it("should resolve begin and end as begin_node and end_node", function() {
    var o = new window.sirius.Od({begin: testBNodeId, end: testENodeId});
    var object_with_id = { 'node': [] };
    var deferred = [];
    object_with_id.node[testBNodeId] = testBNode;
    object_with_id.node[testENodeId] = testENode;
    expect(o.get('begin_node')).toBeUndefined();
    expect(o.get('end_node')).toBeUndefined();
    o.resolve_references(deferred, object_with_id);
    runDeferred(deferred);
    expect(o.get('begin_node')).toEqual(testBNode);
    expect(o.get('end_node')).toEqual(testENode);
  });

  it("should encode begin_node and end_node as begin and end", function() {
    expect(testOd.get('begin')).toBeUndefined();
    expect(testOd.get('end')).toBeUndefined();
    testOd.encode_references();
    expect(testOd.get('begin')).toEqual(testBNodeId);
    expect(testOd.get('end')).toEqual(testENodeId);
  });
});