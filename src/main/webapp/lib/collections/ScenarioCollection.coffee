# This class is used to load our scenario models.
class window.beats.ScenarioCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Scenario
  # should be changed to eventually allow for project id to be passed in
  url: "/via-rest-api/project/1/scenario"

  # Override fetch function to trigger login view changes
  fetch: (options) ->
    # Trigger event on callbacks to try and log in user
    options =
      success: (collection, response) ->
        $a.broker.trigger("app:scenarioListCallback")
      error: (collection, response) ->
        $a.broker.trigger("app:scenarioListCallback")
    super options