# This class is used to manage our controller models.
class window.beats.ControllerSetCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Controller
  
  # when initialized go through the models and set selected to false
  initialize:(@models) ->
    @models.forEach((controller) => @_setUpEvents(controller))
    $a.broker.on("map:clear_map", @clear, @)
    $a.broker.on('controllers:add', @addController, @)
    @on('controllers:remove', @removeController, @)
  
  # the controller browser calls this to gets the column data for the table
  getBrowserColumnData: () ->
    @models.map((controller) -> 
            [
              controller.get('id'),
              controller.get('name'), 
              controller.get('type')
            ]
    )

  # The controller target editor calls this to get the table column
  # data for every target element of a particular controller
  getEditorTargetColumnData: (controllers) ->
    _.each(controllers, (controller) ->
      controller.get_target_elements()
      # Need to find way to add all target elements for selected controllers
      # to scenario elements
      #@models.map((controller.get_target_elements()) -> 
      #        [
      #          scenarioElement.get_target_elements.get('id'),
      #          scenarioElement.get_target_elements.get('type')
      #        ]
      #)
    )

  # this sets all the passed in controllers' selected field to true. It syncs
  # the map controllers selected with selected controllers in the table
  setSelected: (controllers) ->
    _.each(controllers, (controller) ->
      controller.set('selected', true) if !controller.get('selected')
    )
  
  # removeController removes this controller from the collection and takes 
  # it off the map.
  removeController: (sID) ->
    controller = @getByCid(sID)
    @remove(controller)
  
  # addController creates a controller at the position passed in and adds
  # it to the collection as well as to the models schema. 
  # It is called from the context menu's add controller event as well as triggered
  # when a controller is added to a link. If link is null it will add controller
  # at position with no link attached; otherwise it attaches the link to the 
  # controller
  addController: (position, link) ->
    c = new $a.Controller().from_position(position, link)
    @_setUpEvents(c)
    @add(c)
    c
  
  # This method sets up the events each controller should listen too
  _setUpEvents: (controller) ->
    controller.bind('remove', =>
                            controller.off('add')
                            controller.remove()
                            @destroy
                      )
    controller.bind('add', => controller.add())
    controller.set('selected', false)
  
  #this method clears the collection upon a clear map
  clear: ->
    $a.controllerSet = {}
    @remove(@models)
    $a.broker.off('controllers:add')
    @off(null, null, @)
