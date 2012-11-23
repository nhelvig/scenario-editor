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
  
  simpleLink = function(node1, node2) {
    var begin = new window.beats.Begin({node: node1});
    var end = new window.beats.End({node: node2});
    var link = new window.beats.Link({begin: begin, end: end});
    var outputSingle = new window.beats.Output({link: link});
    var inputSingle = new window.beats.Input({link: link});
    var road = new window.beats.Road()
    road.set('name','name1');
    var road2 = new window.beats.Road();
    road2.set('name','name2');
    link.set('roads', new window.beats.Roads());
    link.get('roads').set('road', [road,road2]);
    
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
    var srps, cp, cps, dps, dp;
    node1 = new window.beats.Node({id: 1});
    node2 = new window.beats.Node({id: 2});
    node3 = new window.beats.Node({id: 3});
    link1 = simpleLink(node1, node2);
    link2 = simpleLink(node2, node3);
    link3 = simpleLink(node3, node1);
    density = new window.beats.Density({id: 1});
    idp = new window.beats.InitialDensitySet({density: [density]});
    cp = new window.beats.CapacityProfile({id: 1});
    cps = new window.beats.DownstreamBoundaryCapacityProfileSet({capacityprofile: [cp]});
    dp = new window.beats.DemandProfile({id: 1});
    dps = new window.beats.DemandProfileSet({demandprofile: [dp]});
    srp = new window.beats.SplitratioProfile({id: 1});
    srps = new window.beats.SplitRatioProfileSet({splitratioprofile: [srp]});
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
      initialdensityprofile: idp,
      downstreamboundarycapacityprofileset: cps,
      demandprofileset: dps,
      splitratioprofileset: srps
    });
    scenario.set('network', network);
    
    return {
      scenario: scenario,
      node1: node1,
      node2: node2,
      node3: node3,
      link1: link1,
      link2: link2,
      link3: link3,
      srp: srp,
      srps: srps,
      cps: cps,
      cp: cp,
      dps: dps,
      dp: dp,
      density: density
    };
  };
});