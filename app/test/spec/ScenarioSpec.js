describe("Scenario", function() {
    var scenarioXmlString = $a.fileText;
    describe("from scenario-xml.js", function() {
	var sc = $a.Scenario.from_xml($($.parseXML(scenarioXmlString)).children());
	expect(sc).not.toBeNull();

	it("should load US units", function() { 
	    expect(sc.get('settings').get('units').get('text')).toEqual('US');
	});

	it("should be schema version 1.0.19", function() { 
	    expect(sc.get('schemaVersion')).toEqual('1.0.19');
	});

	describe("network list", function() {
	    var networks = sc.get('networklist'), network = networks.get('network')[0];
	    expect(networks).toBeDefined();
	    expect(networks).not.toBeNull();

	    it("should have 1 network", function() {
		expect(networks.get('network').length).toEqual(1);
	    });

	    describe("network", function() {
		it("should have ID -1",function() {
		    expect(network.get('id')).toEqual('-1');
		});

		describe("linklist", function() {
		    var ll = network.get('linklist').get('link')
		    it("should have 7 links", function() { 
			expect(ll.length).toEqual(7); 
		    });

		    describe("arbitrary known link", function() {
			var targetLink = _.find(ll, function(link) { 
			    return (link.id ==  "-1");
			});
			expect(targetLink).not.toBeNull();

			it("should have 1 lane", function() {
			    expect(targetLink.get('lanes')).toEqual(1);
			});

			it("should have road_name I-80 E", function() {
			    expect(targetLink.get('road_name')).toEqual("I-80 E");
			});

			it("should have demand profile correctly applied", function() {
			    var demand = targetLink.get('demand');
			    expect(demand).not.toBeNull();
			    expect(demand.get('dt')).toEqual(300);
			    expect(demand.get('knob')).toEqual(1);
			});
		    });
		});
	    });
	});
    });
});