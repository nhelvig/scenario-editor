// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.sirius.LinkList = (function(_super) {
    var $a;

    __extends(LinkList, _super);

    /* $a = alias for sirius namespace
    */


    function LinkList() {
      return LinkList.__super__.constructor.apply(this, arguments);
    }

    $a = window.sirius;

    LinkList.from_xml1 = function(xml, object_with_id) {
      var deferred, fn, obj, _i, _len;
      deferred = [];
      obj = this.from_xml2(xml, deferred, object_with_id);
      for (_i = 0, _len = deferred.length; _i < _len; _i++) {
        fn = deferred[_i];
        fn();
      }
      return obj;
    };

    LinkList.from_xml2 = function(xml, deferred, object_with_id) {
      var link, obj;
      if (!(xml != null) || xml.length === 0) {
        return null;
      }
      obj = new window.sirius.LinkList();
      link = xml.children('link');
      obj.set('link', _.map($(link), function(link_i) {
        return $a.Link.from_xml2($(link_i), deferred, object_with_id);
      }));
      if (obj.resolve_references) {
        obj.resolve_references(deferred, object_with_id);
      }
      return obj;
    };

    LinkList.prototype.to_xml = function(doc) {
      var xml;
      xml = doc.createElement('LinkList');
      if (this.encode_references) {
        this.encode_references();
      }
      _.each(this.get('link') || [], function(a_link) {
        return xml.appendChild(a_link.to_xml(doc));
      });
      return xml;
    };

    LinkList.prototype.deep_copy = function() {
      return LinkList.from_xml1(this.to_xml(), {});
    };

    LinkList.prototype.inspect = function(depth, indent, orig_depth) {
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

    LinkList.prototype.make_tree = function() {
      return null;
    };

    return LinkList;

  })(Backbone.Model);

}).call(this);
