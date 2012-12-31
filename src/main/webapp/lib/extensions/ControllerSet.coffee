window.beats.ControllerSet::defaults =
  controller: []

window.beats.ControllerSet::initialize = ->
  @set 'controller', [] if controller?