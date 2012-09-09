beforeEach(function() {
  window.sirius.broker = _.clone(Backbone.Events);
  
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
    window.sirius.map = new google.maps.Map($("#map_canvas")[0], mapOpts);
  }
  
  simpleLink = function(node1, node2) {
    var begin = new window.sirius.Begin({node: node1});
    var end = new window.sirius.End({node: node2});
    var link = new window.sirius.Link({begin: begin, end: end});
    var outputSingle = new window.sirius.Output({link: link});
    var inputSingle = new window.sirius.Input({link: link});
    
    if(!node1.has('outputs')) {
      var output = [outputSingle];
      var outputs = new window.sirius.Outputs({output: output});
      node1.set('outputs', outputs);
    } else {
      node1.get('outputs').get('output').push(outputSingle);
    }
    
    if(!node2.has('inputs')) {
      var input = [inputSingle];
      var inputs = new window.sirius.Inputs({input: input});
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
    node1 = new window.sirius.Node({id: 1});
    node2 = new window.sirius.Node({id: 2});
    node3 = new window.sirius.Node({id: 3});
    link1 = simpleLink(node1, node2);
    link2 = simpleLink(node2, node3);
    link3 = simpleLink(node3, node1);
    density = new window.sirius.Density({id: 1});
    idp = new window.sirius.InitialDensitySet({density: [density]});
    cp = new window.sirius.CapacityProfile({id: 1});
    cps = new window.sirius.DownstreamBoundaryCapacityProfileSet({capacityprofile: [cp]});
    dp = new window.sirius.DemandProfile({id: 1});
    dps = new window.sirius.DemandProfileSet({demandprofile: [dp]});
    srp = new window.sirius.SplitratioProfile({id: 1});
    srps = new window.sirius.SplitRatioProfileSet({splitratioprofile: [srp]});
    linkList = new window.sirius.LinkList({link: [link1, link2, link3]});
    nodeList = new window.sirius.NodeList({node: [node1, node2, node3]});
    network = new window.sirius.Network({id: 1});
    // These must be called after initialize, initialize clears lists
    network.set('nodelist', nodeList);
    network.set('linklist', linkList);
    networkList = new window.sirius.NetworkList({network: [network]});
    scenario = new window.sirius.Scenario({
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