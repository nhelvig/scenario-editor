describe("Event", function() {
  var testNodeId = 2;
  var testLinkId = 3;
  var testControllerId = 4;
  var testSensorId = 5;
  var testEventId = 6;
  var testSignalId = 7;
  var testOtherEventId = 8;
  var testNode;
  var testController;
  var testSensor;
  var testOtherEvent;
  var testEvent;
  var testSignal;
  
  var loadTargetReferences = function() {
    var targetRefs = [];
    targetRefs.push(new window.beats.ScenarioElement({type: 'node', id: testNodeId}));
    targetRefs.push(new window.beats.ScenarioElement({type: 'link', id: testLinkId}));
    targetRefs.push(new window.beats.ScenarioElement({type: 'controller', id: testControllerId}));
    targetRefs.push(new window.beats.ScenarioElement({type: 'sensor', id: testSensorId}));
    targetRefs.push(new window.beats.ScenarioElement({type: 'event', id: testOtherEventId}));
    targetRefs.push(new window.beats.ScenarioElement({type: 'signal', id: testSignalId}));
    return targetRefs;
  };
  
  beforeEach(function() {
    testNode = new window.beats.Node({id: testNodeId});
    testLink = new window.beats.Link({id: testLinkId});
    testController = new window.beats.Controller({node: testNode});
    testOtherEvent = new window.beats.Controller({id: testOtherEvent, node: testNode});
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
      object_with_id.controller[testControllerId] = testController;
      object_with_id.event[testOtherEventId] = testOtherEvent;
      object_with_id.sensor[testSensorId] = testSensor;
      object_with_id.event[testEventId] = testEvent;
      object_with_id.signal[testSignalId] = testSignal;
      testEvent.set('targetelements', new window.beats.TargetElements());
      testEvent.get('targetelements').set('scenarioelement', loadTargetReferences());
      testEvent.resolve_references(deferred, object_with_id);
      runDeferred(deferred);
    })
    it("to nodes", function() {
      expect(testEvent.get('targetreferences')).toContain(testNode);
    });
    it("to links", function() {
      expect(testEvent.get('targetreferences')).toContain(testLink);
    });
    it("to controllers", function() {
      expect(testEvent.get('targetreferences')).toContain(testController);
    });
    it("to sensors", function() {
      expect(testEvent.get('targetreferences')).toContain(testSensor);
    });
    it("to events", function() {
      expect(testEvent.get('targetreferences')).toContain(testOtherEvent);
    });
    it("to signals", function() {
      expect(testEvent.get('targetreferences')).toContain(testSignal);
    });
  });
});