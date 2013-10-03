# The view class for each child item in the nav bar view. Each child item
# is an <li> tag with an anchor surrounding the name. 
class window.beats.NavChildItemView extends Backbone.View
  $a = window.beats
  tagName: "li"
  
  # The model attribute is the model for this class, the element attribute is 
  # the name of the parent tree element this model should be attached too 
  initialize: (args) ->
    $(@el).attr 'id', args.textLower
    @parent = args.attach
    @template = _.template($("#child-item-menu-template").html())
    @$el.html(@template({text: args.text}))
    @events = { 'click' : args.event } if args.event?
    $a.broker.on('app:nav-menu', @render, @)
    @render()

  render: ->
    $("##{@parent} ul").append(@el)
    @
