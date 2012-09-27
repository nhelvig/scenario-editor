// Generated by CoffeeScript 1.3.3
(function() {
  var $a;

  $a = window.sirius;

  window.sirius.Controller.prototype.initialize = function() {
    this.set('parameters', {});
    this.set('planlist', new $a.PlanList());
    return this.set('plansequence', new $a.PlanSequence());
  };

  window.sirius.Controller.prototype.display_point = function() {
    var display_position, elt_pt, p, pos_elt;
    if (!this.has('display_position')) {
      display_position = new $a.Display_position();
      this.set('display_position', display_position);
      p = new $a.Point();
      display_position.get('point').push(p);
      pos_elt = null;
      if (this.has('link')) {
        pos_elt = this.get('link').get('begin').get('node');
      } else if (this.has('node')) {
        pos_elt = this.get('node');
      } else if (network) {
        pos_elt = this.get('network');
      }
      if (pos_elt && pos_elt.has('position') && pos_elt.get('position').has('point') && pos_elt.get('position').get('point')[0]) {
        elt_pt = pos_elt.get('position').get('point')[0];
        p.set('lat', elt_pt.get('lat'));
        p.set('lng', elt_pt.get('lng'));
      } else {
        p.set('lat', 0);
        p.set('lng', 0);
      }
      return display_position.get('point')[0];
    }
  };

  window.sirius.Controller.prototype.resolve_references = function(deferred, object_with_id) {
    var _this = this;
    return deferred.push(function() {
      _this.set('id', _this.get('id'));
      _this.set('targetreferences', []);
      return _.each(_this.get('targetelements').get('scenarioelement'), function(e) {
        switch (e.get('type')) {
          case 'link':
            return _this.get('targetreferences').push(object_with_id.link[e.id]);
          case 'node':
            return _this.get('targetreferences').push(object_with_id.node[e.id]);
          case 'controller':
            return _this.get('targetreferences').push(object_with_id.controller[e.id]);
          case 'sensor':
            return _this.get('targetreferences').push(object_with_id.sensor[e.id]);
          case 'event':
            return _this.get('targetreferences').push(object_with_id.event[e.id]);
          case 'signal':
            return _this.get('targetreferences').push(object_with_id.signal[e.id]);
        }
      });
    });
  };

  window.sirius.Controller.prototype.encode_references = function() {};

}).call(this);
