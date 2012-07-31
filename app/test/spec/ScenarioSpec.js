describe("Scenario", function() {
    var scenarioXmlString = $a.fileText;
    describe("from scenario-xml.js", function() {
	var sc = $a.Scenario.from_xml($($.parseXML(scenarioXmlString)).children());
	expect(sc).not.toBeNull();
	console.log(sc);

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
		it("should have a link list with 7 links", function() {
		    expect(network.get('linklist').get('link').length).toEqual(7);
		});
	    });
	});
    });
});