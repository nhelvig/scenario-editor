# This class is used to load our network models.
class window.beats.NetworkCollection extends Backbone.Collection
  $a = window.beats
  model: $a.Network
  # should be changed to eventually allow for project and scenario ids to be passed in
  url: "/via-rest-api/project/1/scenario/1/network"

  # Override fetch function to trigger login view changes
  fetch: (options) ->
    # Trigger event on callbacks to try and log in user
    options = 
      success: (collection, response) ->
        $a.broker.trigger("app:networkListCallback") 
      error: (collection, response) ->
        $a.broker.trigger("app:networkListCallback")
    super options
