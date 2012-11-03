# This class adds the Parent Items to the Nav Bar
class window.beats.NavBarView extends Backbone.View
  $a = window.beats
  tagName: "ul"
  className: "nav"

  initialize: (args) ->
    @parent = args.attach
    @render()
    for key, values of args.menuItems
      keyLower = $a.Util.toLowerCaseAndDashed(key)
      attrs =
        text: key
        textLower: keyLower
        attach: ".#{@className}"

      new $a.NavParentItemView(attrs)
      for subkey, event of values
        attrs =
          text: subkey
          textLower: $a.Util.toLowerCaseAndDashed(subkey)
          event: event
          attach: keyLower

        new $a.NavChildItemView(attrs)

  render: ->
    $(@parent).append(@el)
    @