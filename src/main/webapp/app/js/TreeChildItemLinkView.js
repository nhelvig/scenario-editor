// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.sirius.TreeChildItemLinkView = (function(_super) {
    var $a;

    __extends(TreeChildItemLinkView, _super);

    function TreeChildItemLinkView() {
      return TreeChildItemLinkView.__super__.constructor.apply(this, arguments);
    }

    $a = window.sirius;

    TreeChildItemLinkView.prototype.setUpEvents = function() {
      var _this = this;
      $a.broker.on('map:show_link_layer', this.showItem, this);
      $a.broker.on('map:hide_link_layer', this.hideItem, this);
      if (this.targets != null) {
        _.each(this.targets, function(elem) {
          $a.broker.on("app:tree_highlight:" + elem.cid, _this.highlight, _this);
          $a.broker.on("app:tree_remove_highlight:" + elem.cid, _this.removeHighlight, _this);
          $a.broker.on("map:links:show_" + (elem.get('type')), _this.showItem, _this);
          return $a.broker.on("map:links:hide_" + (elem.get('type')), _this.hideItem, _this);
        });
      }
      return TreeChildItemLinkView.__super__.setUpEvents.apply(this, arguments);
    };

    return TreeChildItemLinkView;

  })(window.sirius.TreeChildItemView);

}).call(this);
