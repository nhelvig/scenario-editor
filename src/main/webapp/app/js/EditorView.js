// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.sirius.EditorView = (function(_super) {
    var $a;

    __extends(EditorView, _super);

    function EditorView() {
      return EditorView.__super__.constructor.apply(this, arguments);
    }

    $a = window.sirius;

    EditorView.prototype.initialize = function(options) {
      var title;
      this.options = options;
      this.elem = this.options.elem;
      this.models = this.options.models;
      title = $a.Util.toStandardCasing(this.elem);
      this.$el.attr('title', "" + title + " Editor: " + (this.models[0].get('name')));
      this.$el.attr('id', "" + this.elem + "-dialog-form-" + this.models[0].cid);
      this.template = _.template($("#" + this.elem + "-editor-dialog-template").html());
      return this.$el.html(this.template(options.templateData));
    };

    EditorView.prototype.render = function() {
      var _this = this;
      this.$el.dialog({
        autoOpen: false,
        width: this.options.width,
        modal: false,
        close: function() {
          return _this.$el.remove();
        }
      });
      return this;
    };

    return EditorView;

  })(Backbone.View);

}).call(this);
