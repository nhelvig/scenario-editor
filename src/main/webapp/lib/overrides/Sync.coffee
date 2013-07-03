# Overrides Backbone sync method, so all trips to the server send 
# Authentication Header
$a = window.beats
oldSync = Backbone.sync
Backbone.sync = (method, model, options) ->
  # Add Authentication String from Stored Session Object
  headers = $a.usersession.getHeaders() if $a.usersession? 
  options.headers = headers

  # Call and return Backbone Sync Method
  oldSync(method, model, options)
