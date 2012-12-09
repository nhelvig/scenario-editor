# This class is used to manage our event models.
class window.beats.EventSetCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Event
  
  # when initialized go through the models and set selected to false
  initialize:(@models) ->
    @models.forEach((event) => @_setUpEvents(event))
    $a.broker.on("map:clear_map", @clear, @)
    $a.broker.on('events:add', @addEvent, @)
    @on('events:remove', @removeEvent, @)
  
  # the event browser calls this to gets the column data for the table
  getBrowserColumnData: () ->
    @models.map((event) -> 
            [
              event.get('id'),
              event.get('name'), 
              event.get('type')
            ]
    )

  # The event target editor calls this to get the table column
  # data for every target element of a particular controller
  getEditorTargetColumnData: (events) ->
    _.each(events, (event) ->
      event.get_target_elements()
      # Need to find way to add all target elements for selected events
      # to scenario elements
      #@models.map((event.get_target_elements()) -> 
      #        [
      #          scenarioElement.get_target_elements.get('id'),
      #          scenarioElement.get_target_elements.get('type')
      #        ]
      #)
    )

  # this sets all the passed in events' selected field to true. It syncs
  # the map events selected with selected events in the table
  setSelected: (events) ->
    _.each(events, (event) ->
      event.set('selected', true) if !event.get('selected')
    )
  
  # removeEvent removes this event from the collection and takes 
  # it off the map.
  removeEvent: (sID) ->
    event = @getByCid(sID)
    @remove(event)
  
  # addEvent creates an event at the position passed in and adds
  # it to the collection as well as to the models schema. 
  # It is called from the context menu's "add event" event as well as triggered
  # when an event is added to a link. If link is null it will add event
  # at position with no link attached; otherwise it attaches the link to the 
  # event
  addEvent: (position, link) ->
    e = new $a.Event().from_position(position, link)
    @_setUpEvents(e)
    @add(e)
    e
  
  # This method sets up the events each event should listen too
  _setUpEvents: (event) ->
    event.bind('remove', =>
                            event.off('add')
                            event.remove()
                            @destroy
                      )
    event.bind('add', => event.add())
    event.set('selected', false)
  
  #this method clears the collection upon a clear map
  clear: ->
    $a.eventSet = {}
    @remove(@models)
    $a.broker.off('events:add')
    @off(null, null, @)
