// Generated by CoffeeScript 1.3.3
(function() {

  window.sirius.FundamentalDiagramProfile.prototype.resolve_references = window.sirius.ReferenceHelper.resolver('link_id', 'link', 'link', 'fundamentaldiagramprofile', 'FundamentalDiagramProfile', true);

  window.sirius.FundamentalDiagramProfile.prototype.encode_references = function() {
    return this.set('link_id', this.get('link').id);
  };

}).call(this);
