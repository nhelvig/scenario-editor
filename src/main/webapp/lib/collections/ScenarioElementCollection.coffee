# This class is used to manage Target (Scenario) Elements models.
class window.beats.ScenarioElementCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Collection
  
  initialize:(@models) ->
    alert("Initializing Scenario Element Collection")
  
  # Adds scenario element to collection
  # Called by editor event after selecting new Scenario Element on map
  addScenarioElement: (id, type) ->
    element = new $a.scenarioElement()

  # Remove scenario element from collection
  # Called by editor event after de-selecting new Scenario Element on map
  removeScenarioElement: (id, type) ->
    element = _.filter(@models, (scenarioElement) -> scenarioElement.id is id)
    @remove(element)
