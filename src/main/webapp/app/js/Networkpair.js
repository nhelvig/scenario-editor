// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.sirius.Networkpair = (function(_super) {
    var $a;

    __extends(Networkpair, _super);

    /* $a = alias for sirius namespace
    */


    function Networkpair() {
      return Networkpair.__super__.constructor.apply(this, arguments);
    }

    $a = window.sirius;

    Networkpair.from_xml1 = function(xml, object_with_id) {
      var deferred, fn, obj, _i, _len;
      deferred = [];
      obj = this.from_xml2(xml, deferred, object_with_id);
      for (_i = 0, _len = deferred.length; _i < _len; _i++) {
        fn = deferred[_i];
        fn();
      }
      return obj;
    };

    Networkpair.from_xml2 = function(xml, deferred, object_with_id) {
      var linkpair, network_a, network_b, obj;
      if (!(xml != null) || xml.length === 0) {
        return null;
      }
      obj = new window.sirius.Networkpair();
      linkpair = xml.children('linkpair');
      obj.set('linkpair', _.map($(linkpair), function(linkpair_i) {
        return $a.Linkpair.from_xml2($(linkpair_i), deferred, object_with_id);
      }));
      network_a = $(xml).attr('network_a');
      obj.set('network_a', network_a);
      network_b = $(xml).attr('network_b');
      obj.set('network_b', network_b);
      if (obj.resolve_references) {
        obj.resolve_references(deferred, object_with_id);
      }
      return obj;
    };

    Networkpair.prototype.to_xml = function(doc) {
      var xml;
      xml = doc.createElement('networkpair');
      if (this.encode_references) {
        this.encode_references();
      }
      _.each(this.get('linkpair') || [], function(a_linkpair) {
        return xml.appendChild(a_linkpair.to_xml(doc));
      });
      if (this.has('network_a')) {
        xml.setAttribute('network_a', this.get('network_a'));
      }
      if (this.has('network_b')) {
        xml.setAttribute('network_b', this.get('network_b'));
      }
      return xml;
    };

    Networkpair.prototype.deep_copy = function() {
      return Networkpair.from_xml1(this.to_xml(), {});
    };

    Networkpair.prototype.inspect = function(depth, indent, orig_depth) {
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

    Networkpair.prototype.make_tree = function() {
      return null;
    };

    return Networkpair;

  })(Backbone.Model);

}).call(this);
