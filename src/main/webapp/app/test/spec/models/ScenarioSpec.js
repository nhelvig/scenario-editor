describe("Scenario", function() {
  var scenarioXmlString = $a.fileText;
  describe("from scenario-xml.js", function() {
    var sc = $a.Scenario.from_xml($($.parseXML(scenarioXmlString)).children());
    expect(sc).not.toBeNull();

    it("should load US units", function() { 
      expect(sc.get('settings').get('units').get('text')).toEqual('US');
    });

    it("should be schema version 1.0.20", function() { 
      expect(sc.get('schemaVersion')).toEqual('1.0.20');
    });

    describe("sensorset", function() {
      var sl = sc.get('sensorset').get('sensor');

      it("should have 1 sensor", function() {
        expect(sl.length).toEqual(1);
      });
    
      describe("sensor", function() {
        it("should be populated correctly", function() {
          var sensor = sl[0];
          expect(sensor.get('link').get('type')).toEqual('street');
          expect(sensor.get('type')).toEqual('static_point');
          var parameters = sensor.get('parameters');
          expect(parameters['lanes']).toEqual('5');
          expect(parameters['postmile']).toEqual('10.4');
          expect(parameters['length']).toEqual('0.38');
          expect(parameters['hwy_dir']).toEqual('E');
          expect(parameters['vds']).toEqual('400679');
          expect(parameters['start_time']).toEqual('0');
          expect(parameters['hwy_name']).toEqual('80');
          expect(parameters['offset_in_link']).toEqual('0');
          expect(parameters['data_id']).toEqual('400679');  
        });
      });
    });

    describe("networkset", function() {
      var networks = sc.get('networkset');
      var network = networks.get('network')[0];
      expect(networks).toBeDefined();
      expect(networks).not.toBeNull();

      it("should have 1 network", function() {
        expect(networks.get('network').length).toEqual(1);
      });

      describe("network", function() {
        it("should have ID -1",function() {
          expect(network.get('id')).toEqual(-1);
        });

      describe("nodelist", function() {
        var nl = network.get('nodelist').get('node');

        it("should have 151 nodes", function() {
          expect(nl.length).toEqual(151);
        });

        describe("arbitrary known node", function() {
          var targetNode = nl[0]
          expect(targetNode).not.toBeNull();

          it("should have type signalized_intersection", function() {
            expect(targetNode.get('type')).toEqual('signalized_intersection');
          });

          it("should have split ratio profile correctly applied", function() {
            var splitratios = targetNode.get('splitratios');
            expect(splitratios).not.toBeNull();
            expect(splitratios.get('dt')).toEqual(900);
          });
        });
      });

      describe("linklist", function() {
        var ll = network.get('linklist').get('link');
        it("should have 7 links", function() { 
          expect(ll.length).toEqual(230); 
        });

        describe("arbitrary known link", function() {
            var targetLink = ll[0];
            expect(targetLink).not.toBeNull();

            it("should have 2 lanes", function() {
              expect(targetLink.get('lanes')).toEqual(2);
            });

            it("should have road_name San Pablo Ave", function() {
              var name = targetLink.get('roads').get('road')[0].get('name')
              expect(name).toEqual("San Pablo Ave");
            });
        });
      });
    });
  });
});

  describe("reference encoding", function() {
    var sAndFriends;
    beforeEach(function() {
      sAndFriends = scenarioAndFriends();
    });

    it("handles demand profile", function() {
      var scenario = sAndFriends.scenario;
      var link1 = sAndFriends.link1;

      scenario.get('demandprofileset').set('demandprofile', []);
      link1.set('demand', sAndFriends.dp);
      scenario.encode_references();
      expect(scenario.get('demandprofileset').get('demandprofile')).toContain(sAndFriends.dp);  
    });

    it("handles split ratio profile", function() {
      var scenario = sAndFriends.scenario;
      var node1 = sAndFriends.node1;

      scenario.get('splitratioprofileset').set('splitratios', []);
      node1.set('splitratios', sAndFriends.srp);
      scenario.encode_references();
      expect(scenario.get('splitratioprofileset').get('splitratios')).toContain(sAndFriends.srp);
    });

    it("handles density", function() {
      var scenario = sAndFriends.scenario;
      var link1 = sAndFriends.link1;

      scenario.get('initialdensityset').set('density',[]);
      link1.set('density', sAndFriends.density);
      scenario.encode_references();
      expect(scenario.get('initialdensityset').get('density')).toContain(sAndFriends.density);
    });

    it("handles capacity profile", function() {
      var scenario = sAndFriends.scenario;
      var link1 = sAndFriends.link1;
      
      scenario.get('downstreamboundarycapacityprofileset').set('capacityprofile',[]);
      link1.set('capacity', sAndFriends.cp);
      scenario.encode_references();
      expect(scenario.get('downstreamboundarycapacityprofileset').get('capacityprofile')).toContain(sAndFriends.cp);
    });
  });
  
  describe("sensor_set", function() {
    it("should create a new one if does not exist", function() {
       var scenario = sAndFriends.scenario;
       scenario.set_sensor_set(null);
       var set = scenario.sensor_set();
       expect(set).not.toBeNull();
    });
  });
});