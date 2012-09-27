// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.sirius.Decision_points = (function(_super) {
    var $a;

    __extends(Decision_points, _super);

    /* $a = alias for sirius namespace
    */


    function Decision_points() {
      return Decision_points.__super__.constructor.apply(this, arguments);
    }

    $a = window.sirius;

    Decision_points.from_xml1 = function(xml, object_with_id) {
      var deferred, fn, obj, _i, _len;
      deferred = [];
      obj = this.from_xml2(xml, deferred, object_with_id);
      for (_i = 0, _len = deferred.length; _i < _len; _i++) {
        fn = deferred[_i];
        fn();
      }
      return obj;
    };

    Decision_points.from_xml2 = function(xml, deferred, object_with_id) {
      var obj;
      if (!(xml != null) || xml.length === 0) {
        return null;
      }
      obj = new window.sirius.Decision_points();
      obj.set('text', xml.text());
      if (obj.resolve_references) {
        obj.resolve_references(deferred, object_with_id);
      }
      return obj;
    };

    Decision_points.prototype.to_xml = function(doc) {
      var xml;
      xml = doc.createElement('decision_points');
      if (this.encode_references) {
        this.encode_references();
      }
      xml.appendChild(doc.createTextNode($a.ArrayText.emit(this.get('text') || [])));
      return xml;
    };

    Decision_points.prototype.deep_copy = function() {
      return Decision_points.from_xml1(this.to_xml(), {});
    };

    Decision_points.prototype.inspect = function(depth, indent, orig_depth) {
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

    Decision_points.prototype.make_tree = function() {
      return null;
    };

    return Decision_points;

  })(Backbone.Model);

}).call(this);
