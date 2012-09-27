// Generated by CoffeeScript 1.3.3
(function() {

  window.sirius.DemandProfile.prototype.resolve_references = window.sirius.ReferenceHelper.resolver('link_id_origin', 'link', 'link', 'demand', 'DemandProfile', true);

  window.sirius.DemandProfile.prototype.encode_references = function() {
    return this.set('link_id', this.get('link').id);
  };

  window.sirius.DemandProfile.prototype.demands_by_vehicle_type = function() {
    var timeSepDemands, vals, vehTypeTimeSepDemands;
    timeSepDemands = this.get('text').split(",");
    vehTypeTimeSepDemands = _.map(timeSepDemands, function(d) {
      return _.map(d.split(":"), Number);
    });
    return vals = _.zip.apply(null, vehTypeTimeSepDemands);
  };

  window.sirius.DemandProfile.prototype.is_constant = function() {
    return this.demands_by_vehicle_type()[0].length === 1;
  };

}).call(this);
