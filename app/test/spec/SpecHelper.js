beforeEach(function() {
    runDeferred = function(fList) {
      _.each(fList, function(f) { f(); });
    };
    
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
    }
});