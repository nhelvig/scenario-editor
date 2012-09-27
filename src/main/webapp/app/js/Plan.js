// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.sirius.Plan = (function(_super) {
    var $a;

    __extends(Plan, _super);

    /* $a = alias for sirius namespace
    */


    function Plan() {
      return Plan.__super__.constructor.apply(this, arguments);
    }

    $a = window.sirius;

    Plan.from_xml1 = function(xml, object_with_id) {
      var deferred, fn, obj, _i, _len;
      deferred = [];
      obj = this.from_xml2(xml, deferred, object_with_id);
      for (_i = 0, _len = deferred.length; _i < _len; _i++) {
        fn = deferred[_i];
        fn();
      }
      return obj;
    };

    Plan.from_xml2 = function(xml, deferred, object_with_id) {
      var cyclelength, id, intersection, obj;
      if (!(xml != null) || xml.length === 0) {
        return null;
      }
      obj = new window.sirius.Plan();
      intersection = xml.children('intersection');
      obj.set('intersection', _.map($(intersection), function(intersection_i) {
        return $a.Intersection.from_xml2($(intersection_i), deferred, object_with_id);
      }));
      id = $(xml).attr('id');
      obj.set('id', id);
      cyclelength = $(xml).attr('cyclelength');
      obj.set('cyclelength', Number(cyclelength));
      if (object_with_id.plan) {
        object_with_id.plan[obj.id] = obj;
      }
      if (obj.resolve_references) {
        obj.resolve_references(deferred, object_with_id);
      }
      return obj;
    };

    Plan.prototype.to_xml = function(doc) {
      var xml;
      xml = doc.createElement('plan');
      if (this.encode_references) {
        this.encode_references();
      }
      _.each(this.get('intersection') || [], function(a_intersection) {
        return xml.appendChild(a_intersection.to_xml(doc));
      });
      if (this.has('id')) {
        xml.setAttribute('id', this.get('id'));
      }
      if (this.has('cyclelength')) {
        xml.setAttribute('cyclelength', this.get('cyclelength'));
      }
      return xml;
    };

    Plan.prototype.deep_copy = function() {
      return Plan.from_xml1(this.to_xml(), {});
    };

    Plan.prototype.inspect = function(depth, indent, orig_depth) {
      if (depth == null) {
        depth = 1;
      }
      if (indent == null) {
        indent = false;
      }
      if (orig_depth == null) {
        orig_depth = -1;
      }
      return null;
    };

    Plan.prototype.make_tree = function() {
      return null;
    };

    return Plan;

  })(Backbone.Model);

}).call(this);
