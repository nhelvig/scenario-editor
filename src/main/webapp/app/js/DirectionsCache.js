// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.sirius.DirectionsCache = (function(_super) {
    var $a;

    __extends(DirectionsCache, _super);

    /* $a = alias for sirius namespace
    */


    function DirectionsCache() {
      return DirectionsCache.__super__.constructor.apply(this, arguments);
    }

    $a = window.sirius;

    DirectionsCache.from_xml1 = function(xml, object_with_id) {
      var deferred, fn, obj, _i, _len;
      deferred = [];
      obj = this.from_xml2(xml, deferred, object_with_id);
      for (_i = 0, _len = deferred.length; _i < _len; _i++) {
        fn = deferred[_i];
        fn();
      }
      return obj;
    };

    DirectionsCache.from_xml2 = function(xml, deferred, object_with_id) {
      var DirectionsCacheEntry, obj;
      if (!(xml != null) || xml.length === 0) {
        return null;
      }
      obj = new window.sirius.DirectionsCache();
      DirectionsCacheEntry = xml.children('DirectionsCacheEntry');
      obj.set('directionscacheentry', _.map($(DirectionsCacheEntry), function(DirectionsCacheEntry_i) {
        return $a.DirectionsCacheEntry.from_xml2($(DirectionsCacheEntry_i), deferred, object_with_id);
      }));
      if (obj.resolve_references) {
        obj.resolve_references(deferred, object_with_id);
      }
      return obj;
    };

    DirectionsCache.prototype.to_xml = function(doc) {
      var xml;
      xml = doc.createElement('DirectionsCache');
      if (this.encode_references) {
        this.encode_references();
      }
      _.each(this.get('directionscacheentry') || [], function(a_directionscacheentry) {
        return xml.appendChild(a_directionscacheentry.to_xml(doc));
      });
      return xml;
    };

    DirectionsCache.prototype.deep_copy = function() {
      return DirectionsCache.from_xml1(this.to_xml(), {});
    };

    DirectionsCache.prototype.inspect = function(depth, indent, orig_depth) {
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

    DirectionsCache.prototype.make_tree = function() {
      return null;
    };

    return DirectionsCache;

  })(Backbone.Model);

}).call(this);
