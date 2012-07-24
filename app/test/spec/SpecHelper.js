beforeEach(function() {
    runDeferred = function(fList) {
	_.each(fList, function(f) { f(); });
    };
});
