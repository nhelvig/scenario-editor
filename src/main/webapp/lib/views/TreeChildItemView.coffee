# The view class for each child item in the tree view. Each child item
# is <li> tag with an anchor surrounding the name. It is the super of
# Link and Node Tree Items but can also render non-link/node tree items
class window.beats.TreeChildItemView extends Backbone.View
  $a = window.beats
  tagName: "li"
  className: "file"
  events:
    click: 'manageHighlight'
    contextmenu: 'showContext'

  model_events: 
    'change:selected': 'toggleSelected'
  
  broker_events: {
    'app:child_trees' : 'render'
    'app:tree_remove_highlight' : 'removeHighlight'
    'app:tree_clear' :  'removeItem'
  }
  
  # The model attribute is the model for this class, the element
  # attribute is the name of the parent tree element this model should
  # be attached too
  initialize: (params) ->
    @model= params.e
    @targets = params.targets
    name = params.name
    @element = params.attach

    # used to toggle highlight for this element
    @highlighted = false

    # We add an empty node that says None Defined if no children are
    # defined
    if @model?
      @id = "tree-item-#{@targets[0].cid}"
      $(@el).attr 'id', @id
    displayName =  name
    @template = _.template($('#child-item-menu-template').html())
    @$el.html(@template(text: displayName))
    @setUpEvents()

  render: ->
    $("#tree-parent-#{@element}").append(@el)
    @

  # This method overridden in the subclasses to register events for
  # specific types of tree items -- node or link.  All tree items
  # register for the links here
  setUpEvents: ->
    $a.Util.publishEvents($a.broker, @broker_events, @)

  manageHighlight:  ->
    $a.broker.trigger('map:clear_selected') unless $a.ALT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.ALT_DOWN

    if !@highlighted
      @highlighted = true
      _.each(@targets, (elem) =>
            $a.broker.trigger("app:tree_highlight:#{elem.cid}")
            $a.broker.trigger("map:select_item:#{elem.cid}")
      ) if @targets?
      $a.broker.trigger("map:select_item:#{@model.cid}")
      @highlight()
    else
      @highlighted = false
      @removeHighlight()
    
  # This method toggles the selection of the node
  toggleSelected: () ->
    if(@model.selected() is true)
      @highligh()
    else
      @removeHighlight()

  highlight: ->
    $(@el).addClass "highlight"

  removeHighlight: ->
    $(@el).removeClass "highlight"

  # in order to remove an element you need to unpublish the events,
  # and remove it from the DOM
  removeItem: ->
    $(@el).remove()
    $a.Util.unpublishEvents($a.broker, @broker_events, @)
    _.each(@targets, (target) =>
      $a.broker.off("app:tree_highlight:#{target.cid}")
      $a.broker.off("app:tree_remove_highlight:#{target.cid}")
    ) if @targets?

  hideItem: ->
    @$el.addClass('hide').removeClass('show')

  showItem: ->
    @$el.addClass('show').removeClass('hide')

  # This method adds either the node or links context menu to the tree
  # item.  We offset the x and y by 5 in order to make sure the window
  # stays open once the button is released in FF and we return false
  # to turn off the browsers default context menu
  showContext: (e) ->
    position = {}
    position.x = e.clientX - 5
    position.y = e.clientY - 5
    # some types have targetElements and other store the element in
    # the model itself.  We check to see if there targets -- if empty
    # then we know to use the model
    item = null
    if @targets?
      item = @targets[0]
    else
      item = @model

    # Events and controller do not have context menus yet and may
    # never
    item.get('contextMenu').show position if item.get('contextMenu')?
    false