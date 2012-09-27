// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.sirius.Outputs = (function(_super) {
    var $a;

    __extends(Outputs, _super);

    /* $a = alias for sirius namespace
    */


    function Outputs() {
      return Outputs.__super__.constructor.apply(this, arguments);
    }

    $a = window.sirius;

    Outputs.from_xml1 = function(xml, object_with_id) {
      var deferred, fn, obj, _i, _len;
      deferred = [];
      obj = this.from_xml2(xml, deferred, object_with_id);
      for (_i = 0, _len = deferred.length; _i < _len; _i++) {
        fn = deferred[_i];
        fn();
      }
      return obj;
    };

    Outputs.from_xml2 = function(xml, deferred, object_with_id) {
      var obj, output;
      if (!(xml != null) || xml.length === 0) {
        return null;
      }
      obj = new window.sirius.Outputs();
      output = xml.children('output');
      obj.set('output', _.map($(output), function(output_i) {
        return $a.Output.from_xml2($(output_i), deferred, object_with_id);
      }));
      if (obj.resolve_references) {
        obj.resolve_references(deferred, object_with_id);
      }
      return obj;
    };

    Outputs.prototype.to_xml = function(doc) {
      var xml;
      xml = doc.createElement('outputs');
      if (this.encode_references) {
        this.encode_references();
      }
      _.each(this.get('output') || [], function(a_output) {
        return xml.appendChild(a_output.to_xml(doc));
      });
      return xml;
    };

    Outputs.prototype.deep_copy = function() {
      return Outputs.from_xml1(this.to_xml(), {});
    };

    Outputs.prototype.inspect = function(depth, indent, orig_depth) {
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

    Outputs.prototype.make_tree = function() {
      return null;
    };

    return Outputs;

  })(Backbone.Model);

}).call(this);
