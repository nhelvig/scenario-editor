# This class adds the Parent Items to the Nav Bar
class window.beats.NavParentItemView extends Backbone.View
  $a = window.beats
  tagName: "li"
  className: "dropdown active"
  
  events : {
    'click' : 'renderMenu'
  }
  
  initialize: (@args) ->
    $(@el).attr 'id', args.textLower
    @parent = args.attach
    @template = _.template($("#parent-item-menu-template").html())
    @$el.html(@template(args))
    $a.broker.on('app:nav-menu', @render, @)
    @render()

  render: ->
    $(@parent).append(@el)
    @
  
  renderMenu: ->
    $("##{@parent} ul").children().remove()
    count = 0
    for item in @args.items
       if item.mode is null or @_checkMode(item.mode) is true
          count++
          attrs =
            text: item.label
            textLower: $a.Util.toLowerCaseAndDashed(item.label)
            event: item.event
            attach: @args.textLower
          new $a.NavChildItemView(attrs)
    @_handleEmptyMenu() if count is 0
  
  _handleEmptyMenu: ->
    attrs =
      text: $a.nav_bar_menu_item_disabled.label
      textLower: $a.Util.toLowerCaseAndDashed($a.nav_bar_menu_item_disabled.label)
      attach: @args.textLower
          
    new $a.NavChildItemView(attrs)
  
  _checkMode: (modes) ->
    for m in modes
      if eval(m) is true
         return true
    return false   