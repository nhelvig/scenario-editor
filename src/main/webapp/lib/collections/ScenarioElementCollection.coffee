# This class is used to manage Target (Scenario) Elements models.
class window.beats.ScenarioElementCollection extends Backbone.Collection
  $a = window.beats
  model: $a.ScenarioElement
  
  initialize:(@models) ->
  
  # An editor (right now just event and controller) calls this to gets the scenario column data for 
  # the target or feedback tables
  getEditorColumnData: () ->
    @models.map((scenarioElement) -> 
            [
              scenarioElement.get('id'),
              scenarioElement.get('type')
            ]
    )

  # Adds scenario element to collection
  # Called by editor event after selecting new Scenario Element on map
  addScenarioElement: (id, type) ->
    element = new $a.scenarioElement()

  # Remove scenario element from collection
  # Called by editor event after de-selecting new Scenario Element on map
  removeScenarioElement: (id, type) ->
    element = _.filter(@models, (scenarioElement) -> scenarioElement.id is id)
    @remove(element)

  # Selects (highlights) all scenario elements in collection on map
  selectScenarioElements: () ->
    # for each scenario element in the collection, get corresponding element's cid
    # and trigger select_item event which will highlight it
    @models.forEach((scenarioElement) ->
      elementModel = null
      switch scenarioElement.get('type')
        when "link" then elementModel = $a.linkList.get(scenarioElement.get('id'))
      $a.broker.trigger("map:select_item:#{elementModel.cid}")
    )
