beforeEach(function() {
  window.beats.broker = _.clone(Backbone.Events);
  
  runDeferred = function(fList) {
    _.each(fList, function(f) { f(); });
  };
  
  expectResolution = function(obj, resolveType, resolveOut) {
    var object_with_id = {};
    object_with_id[resolveType] = {};
    var deferred = [];
    object_with_id[resolveType][resolveOut.id] = resolveOut;
    expect(obj.get(resolveType)).toBeUndefined();
    obj.resolve_references(deferred, object_with_id);
    runDeferred(deferred);
    expect(obj.get(resolveType)).toEqual(resolveOut);
  }

  expectSave = function(args){
    $(args.id).val('changed');
    $(args.id).blur();
    expect(args.model.get(args.modelField)).toEqual('changed');
  }
  
  expectSaveSelect = function(args){
    selected = $($(args.el)).find(args.id + ' option:selected');
    $(selected).attr('selected', false);
    options = $(args.el).find(args.id + ' option');
    $(options[1]).attr('selected', true);
    newSelectedValue = $(options[1]).val();
    $(args.id).blur();
    expect(args.model.get(args.modelField)).toEqual(newSelectedValue);
  }
  
  googleMap = function() {
    loadFixtures('main.canvas.view.fixture.html');
    mapOpts = {
      center: new google.maps.LatLng(37.85794730789898, -122.29954719543457),
      zoom: 14,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeControl: false,
      zoomControl: true,
      zoomControlOptions: {
        style: google.maps.ZoomControlStyle.DEFAULT,
        position: google.maps.ControlPosition.TOP_LEFT
      }
    }
    window.beats.map = new google.maps.Map($("#map_canvas")[0], mapOpts);

  }
  
  modelSetUp = function() {
    $a.models = $a.Scenario.from_xml($(xml).children());
    network = $a.models.network();
    $a.nodeList = new $a.NodeListCollection($a.models.nodes())
    $a.nodeListView = new $a.NodeListView($a.nodeList, network)
    $a.linkList = new $a.LinkListCollection($a.models.links())
    $a.linkListView = new $a.LinkListView($a.linkList, network)
  }
  
  simpleLink = function(id, node1, node2, fps, dp) {
    var begin = new window.beats.Begin({node: node1});
    var end = new window.beats.End({node: node2});
    var link = new window.beats.Link({id: id,begin: begin, end: end});
    var outputSingle = new window.beats.Output({link: link});
    var inputSingle = new window.beats.Input({link: link});
    var road = new window.beats.Road()
    road.set('name','name1');
    var road2 = new window.beats.Road();
    road2.set('name','name2');
    link.set('roads', new window.beats.Roads());
    link.get('roads').set('road', [road,road2]);
    var shape = new window.beats.Shape();
    shape.set('text', 'khdfFrvliVvD{@??k@{E??lDw@pDy@xFoA`GoAPCpD}@bAWrBc@jDw@`JqB`E}@|Cq@~IqBhDu@tDy@dDw@l@Ml@MrA[tA[dAUbAUPEFABAB?B?DANA`GsAjBa@jDy@jBc@bDs@rA[pAYfAYvA[jAYHALEl@KHAFC~Bi@dCi@hAQpAYZGn@W|@Q??GWWwDWqD??rDc@fAO');  
    link.set('shape', shape);
    link.set('lanes', 3);
    link.set('subdivide', 0);
    link.set('type','electric_toll');
    link.set('fundamentaldiagramprofile', fps);
    link.set('demand', dp);
    
    if(!node1.has('outputs')) {
      var output = [outputSingle];
      var outputs = new window.beats.Outputs({output: output});
      node1.set('outputs', outputs);
    } else {
      node1.get('outputs').get('output').push(outputSingle);
    }
    
    if(!node2.has('inputs')) {
      var input = [inputSingle];
      var inputs = new window.beats.Inputs({input: input});
      node2.set('inputs', inputs);
    } else {
      node2.get('inputs').get('input').push(inputSingle);
    }
  
    return link;
  };
  
  // "Factory" for scenario objects
  scenarioAndFriends = function() {
    var nodeList, linkList, network, networkList;
    var scenario, srp, idp, density;
    var node1, node2, node3, link1, link2, link3;
    var sensor;
    var srps, cp, cps, dps, dp;
    p = new window.beats.Position();
    pt = new window.beats.Point();
    pt.set(
          { 
            'lat':0,
            'lng':0,
            'elevation':''
          }
        );
    p.set('point', []);
    p.get('point').push(pt);
    
    node1 = new window.beats.Node({id: 10, position: p, type: 'freeway'});
    node2 = new window.beats.Node({id: 11, position: p});
    node3 = new window.beats.Node({id: 12, position: p});
    node4 = new window.beats.Node({id: 13, position: p});
    node5 = new window.beats.Node({id: 14, position: p});
    sensor = new window.beats.Sensor({id:1, position: p});
    sensor1 = new window.beats.Sensor({id:1, position: p});
    sensor2 = new window.beats.Sensor({id:2, position: p});
    sensor3 = new window.beats.Sensor({id:3, position: p});
    sensor4 = new window.beats.Sensor({id:4, position: p});
    density = new window.beats.Density({id: 1});
    ids = new window.beats.InitialDensitySet({density: [density]});
    c = new window.beats.Controller({id:1, display_position:p});
    cs = new window.beats.ControllerSet({controller:[c]});
    cp = new window.beats.CapacityProfile({id: 1});
    cps = new window.beats.DownstreamBoundaryCapacityProfileSet({capacityprofile: [cp]});
    dp = new window.beats.DemandProfile({id: 1});
    dps = new window.beats.DemandProfileSet({demandprofile: [dp]});
    fp = new window.beats.FundamentalDiagramProfile({id: 1});
    fps = new window.beats.FundamentalDiagramProfileSet({fundamentaldiagram: [fp]});
    srp = new window.beats.SplitratioProfile({id: 1});
    srps = new window.beats.SplitRatioProfileSet({splitratioprofile: [srp]});
    link1 = simpleLink(99,node1, node2, fps, dp);
    link2 = simpleLink(100,node2, node3);
    link3 = simpleLink(101, node3, node1);
    link4 = simpleLink(102, node4, node5);

    sensorList = new window.beats.SensorList({sensor: [sensor1, sensor2, sensor3, sensor4]});
    linkList = new window.beats.LinkList({link: [link1, link2, link3]});
    nodeList = new window.beats.NodeList({node: [node1, node2, node3]});
    network = new window.beats.Network({id: 1});
    
    // These must be called after initialize, initialize clears lists
    network.set('nodelist', nodeList);
    network.set('linklist', linkList);
    networkList = new window.beats.NetworkList({network: [network]});
    scenario = new window.beats.Scenario({
      id: 1,
      networklist: networkList,
      controllerset: cs,
      initialdensityset: ids,
      downstreamboundarycapacityprofileset: cps,
      demandprofileset: dps,
      fundamentalprofileset: fps,
      splitratioprofileset: srps,
      sensorlist: sensorList 
    });
    scenario.set('networklist',networkList);
    scenario.set('controllerset',cs);
    
    return {
      scenario: scenario,
      node1: node1,
      node2: node2,
      node3: node3,
      link1: link1,
      link2: link2,
      link3: link3,
      link4: link4,
      sensor: sensor,
      sensor1: sensor1,
      sensor2: sensor2,
      sensor3: sensor3,
      sensor4: sensor4,
      srp: srp,
      srps: srps,
      cps: cps,
      cp: cp,
      controller: c,
      dps: dps,
      dp: dp,
      density: density
    };
  };
});