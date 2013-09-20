class window.beats.UserSession extends Backbone.Model
    
  $a = window.beats

  # Set session information to empty
  defaults: 
    username: ""
    password: ""
    headers: ""
    database: ""
    authenticated: false

  # Url to post to try and validate user 
  url: "/via-rest-api/login"

  # Override fetch function to trigger login view changes
  fetch: (options) ->
    # Trigger event on callbacks to try and log in user
    options = 
      success: (model, response) ->
        $a.broker.trigger("app:logInCallback") 
      error: (model, response) ->
        $a.broker.trigger("app:logInCallback")
    super options

  # Retrieve Header associated with model
  getHeaders: ->
    @.get("headers")

  # Set Header associated with model
  setHeaders: () ->
    # Encode Username and password into Base64 to be passed into authorization header
    userPass = window.btoa(@.get("username") + ':' + @.get("password"))
    header = {'Authorization' :'Basic ' + userPass, 'DB' : @.get("database")}
    @.set("headers", header)

  # Returns true if user is authenticated, false if not
  isAuthenticated: ->
    @.get("authenticated")