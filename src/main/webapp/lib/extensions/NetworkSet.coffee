# on intialization create one empty network in the set
window.beats.NetworkSet::initialize = ->
  @set 'network', [ new window.beats.Network ]

window.beats.NetworkSet::project_id = -> @get 'project_id'
window.beats.NetworkSet::set_project_id = (pid) ->
  @set 'project_id', pid