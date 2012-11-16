describe("Controller", function() {
  var testNodeId = 2;
  var testLinkId = 3;
  var testOtherControllerId = 4;
  var testSensorId = 5;
  var testEventId = 6;
  var testSignalId = 7;
  var testNode;
  var testController;
  var testSensor;
  var testOtherController;
  var testEvent;
  var testSignal;
  
  var loadTargetReferences = function() {
    var targetRefs = [];
    targetRefs.push(new window.beats.ScenarioElement({type: 'node', id: testNodeId}));
    targetRefs.push(new window.beats.ScenarioElement({type: 'link', id: testLinkId}));
    targetRefs.push(new window.beats.ScenarioElement({type: 'controller', id: testOtherControllerId}));
    targetRefs.push(new window.beats.ScenarioElement({type: 'sensor', id: testSensorId}));
    targetRefs.push(new window.beats.ScenarioElement({type: 'event', id: testEventId}));
    targetRefs.push(new window.beats.ScenarioElement({type: 'signal', id: testSignalId}));
    return targetRefs;
  };

  beforeEach(function() {
    testNode = new window.beats.Node({id: testNodeId});
    testLink = new window.beats.Link({id: testLinkId});
    testController = new window.beats.Controller({node: testNode});
    testOtherController = new window.beats.Controller({id: testOtherControllerId, node: testNode});
    testSensor = new window.beats.Sensor({id: testSensorId});
    testEvent = new window.beats.Event({id: testEventId});
    testSignal = new window.beats.Signal({id: testSignalId});
  });
  
  it("should not blow up on to_xml", function() {
    var doc = document.implementation.createDocument("document:xml", "begin", null);
    var out = testController.to_xml(doc); 
    expect(out).not.toBeNull();
  });
  
  describe("should resolve references", function() {
    beforeEach(function() {
      var deferred = [], 
      object_with_id = {node: [], link: [], controller: [], 
      sensor: [], event: [], signal: []};
      object_with_id.node[testNodeId] = testNode;
      object_with_id.link[testLinkId] = testLink;
      object_with_id.controller[testOtherControllerId] = testOtherController;
      object_with_id.sensor[testSensorId] = testSensor;
      object_with_id.event[testEventId] = testEvent;
      object_with_id.signal[testSignalId] = testSignal;
      testController.set('targetelements', new window.beats.TargetElements());
      testController.get('targetelements').set('scenarioelement', loadTargetReferences());
      testController.resolve_references(deferred, object_with_id);
      runDeferred(deferred);
    })
    it("to nodes", function() {
      expect(testController.get('targetreferences')).toContain(testNode);
    });
    it("to links", function() {
      expect(testController.get('targetreferences')).toContain(testLink);
    });
    it("to controllers", function() {
      expect(testController.get('targetreferences')).toContain(testOtherController);
    });
    it("to sensors", function() {
      expect(testController.get('targetreferences')).toContain(testSensor);
    });
    it("to events", function() {
      expect(testController.get('targetreferences')).toContain(testEvent);
    });
    it("to signals", function() {
      expect(testController.get('targetreferences')).toContain(testSignal);
    });
  });
});