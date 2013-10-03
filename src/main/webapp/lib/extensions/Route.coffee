window.beats.Route::name = -> @get('name')
window.beats.Route::set_name = (name) -> @set('name', name)

window.beats.Route::locked_for_edit = -> @get('lockedForEdit')
window.beats.Route::set_locked_for_edit = (s) ->
  @set('lockedForEdit',(s.toString().toLowerCase() == 'true') if s?)

window.beats.Route::locked_for_history = ->  @get('lockedForHistory')
window.beats.Route::set_locked_for_history = (s) ->
  @set('lockedForHistory',(s.toString().toLowerCase() == 'true') if s?)