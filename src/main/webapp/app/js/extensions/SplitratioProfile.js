// Generated by CoffeeScript 1.3.3
(function() {

  window.sirius.SplitratioProfile.prototype.resolve_references = window.sirius.ReferenceHelper.resolver('node_id', 'node', 'node', 'splitratioprofile', 'SplitratioProfile', false);

  window.sirius.SplitratioProfile.prototype.encode_references = function() {
    return this.set('node_id', this.get('node').id);
  };

}).call(this);
