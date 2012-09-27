// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.sirius.Knob = (function(_super) {
    var $a;

    __extends(Knob, _super);

    /* $a = alias for sirius namespace
    */


    function Knob() {
      return Knob.__super__.constructor.apply(this, arguments);
    }

    $a = window.sirius;

    Knob.from_xml1 = function(xml, object_with_id) {
      var deferred, fn, obj, _i, _len;
      deferred = [];
      obj = this.from_xml2(xml, deferred, object_with_id);
      for (_i = 0, _len = deferred.length; _i < _len; _i++) {
        fn = deferred[_i];
        fn();
      }
      return obj;
    };

    Knob.from_xml2 = function(xml, deferred, object_with_id) {
      var obj, value;
      if (!(xml != null) || xml.length === 0) {
        return null;
      }
      obj = new window.sirius.Knob();
      value = $(xml).attr('value');
      obj.set('value', Number(value));
      if (obj.resolve_references) {
        obj.resolve_references(deferred, object_with_id);
      }
      return obj;
    };

    Knob.prototype.to_xml = function(doc) {
      var xml;
      xml = doc.createElement('knob');
      if (this.encode_references) {
        this.encode_references();
      }
      if (this.has('value')) {
        xml.setAttribute('value', this.get('value'));
      }
      return xml;
    };

    Knob.prototype.deep_copy = function() {
      return Knob.from_xml1(this.to_xml(), {});
    };

    Knob.prototype.inspect = function(depth, indent, orig_depth) {
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

    Knob.prototype.make_tree = function() {
      return null;
    };

    return Knob;

  })(Backbone.Model);

}).call(this);
