// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.sirius.To = (function(_super) {
    var $a;

    __extends(To, _super);

    /* $a = alias for sirius namespace
    */


    function To() {
      return To.__super__.constructor.apply(this, arguments);
    }

    $a = window.sirius;

    To.from_xml1 = function(xml, object_with_id) {
      var deferred, fn, obj, _i, _len;
      deferred = [];
      obj = this.from_xml2(xml, deferred, object_with_id);
      for (_i = 0, _len = deferred.length; _i < _len; _i++) {
        fn = deferred[_i];
        fn();
      }
      return obj;
    };

    To.from_xml2 = function(xml, deferred, object_with_id) {
      var ALatLng, obj;
      if (!(xml != null) || xml.length === 0) {
        return null;
      }
      obj = new window.sirius.To();
      ALatLng = xml.children('ALatLng');
      obj.set('alatlng', $a.ALatLng.from_xml2(ALatLng, deferred, object_with_id));
      if (obj.resolve_references) {
        obj.resolve_references(deferred, object_with_id);
      }
      return obj;
    };

    To.prototype.to_xml = function(doc) {
      var xml;
      xml = doc.createElement('To');
      if (this.encode_references) {
        this.encode_references();
      }
      if (this.has('alatlng')) {
        xml.appendChild(this.get('alatlng').to_xml(doc));
      }
      return xml;
    };

    To.prototype.deep_copy = function() {
      return To.from_xml1(this.to_xml(), {});
    };

    To.prototype.inspect = function(depth, indent, orig_depth) {
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

    To.prototype.make_tree = function() {
      return null;
    };

    return To;

  })(Backbone.Model);

}).call(this);
