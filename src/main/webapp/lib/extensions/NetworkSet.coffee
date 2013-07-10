# on intialization create one empty network in the set
window.beats.NetworkSet::initialize = ->
  @set 'network', [ new window.beats.Network ]