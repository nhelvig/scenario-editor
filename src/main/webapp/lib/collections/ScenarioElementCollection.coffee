# This class is used to manage Target (Scenario) Elements models.
class window.beats.ScenarioElementCollection extends Backbone.Collection
  $a = window.beats
  model: $a.ScenarioElement
  
  initialize:(@models) ->
    alert("Initializing Scenario Element Collection")
  
  # An editor (right now just event and controller) calls this to gets the scenario column data for 
  # the target or feedback tables
  getEditorColumnData: () ->
    @models.map((scenarioElement) -> 
            [
              scenarioElement.get('id'),
              get.scenarioElement('type')
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
