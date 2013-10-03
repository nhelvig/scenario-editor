# The parent items of the tree view. Each parent item
# is a li tag with label for its name, a hidden checkbox that enables
# us to swap the open/close image easily, and the ol tag for its
# child elements to be attached to.
class window.beats.TreeParentItemView extends Backbone.View
  $a = window.beats
  tagName: 'li'
  className: 'tree-parent-node'
  
  broker_events: {
    'app:parent_tree' : 'render'
    'app:tree_clear' : 'removeItem'
  }
  
  initialize: (element) ->
    @template = _.template($("#parent-item-tree-template").html())
    params =
      textLower: $a.Util.toLowerCaseAndDashed(element)
      text: element
    @$el.html(@template(params))
    $a.Util.publishEvents($a.broker, @broker_events, @)

  render: ->
    $("#tree").append(@el)
    @

  # in order to remove an element you need to unpublish the events,
  # and remove it from the DOM
  removeItem: ->
    $(@el).remove()
    $a.Util.unpublishEvents($a.broker, @broker_events, @)
