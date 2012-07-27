beforeEach(function() {
    runDeferred = function(fList) {
      _.each(fList, function(f) { f(); });
    };
    
    simpleLink = function(node1, node2) {
	var begin = new window.sirius.Begin({node: node1});
	var end = new window.sirius.End({node: node2});
	var link = new window.sirius.Link({begin: begin, end: end});
	var output = [new window.sirius.Output({link: link})];
	var outputs = new window.sirius.Outputs({output: output});
	var input = [new window.sirius.Input({link: link})];
	var inputs = new window.sirius.Inputs({input: input});
	node1.set('outputs',outputs);
	node2.set('inputs', inputs);
	return link;
    }
});
