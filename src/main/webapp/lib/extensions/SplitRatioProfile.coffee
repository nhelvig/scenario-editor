window.beats.SplitRatioProfile::resolve_references =
  window.beats.ReferenceHelper.resolver('node_id', 'node', 'node', 'splitratioprofile', 'SplitRatioProfile', true)

window.beats.SplitRatioProfile::encode_references = ->
  @set 'node_id', @get('node').ident()

window.beats.SplitRatioProfile::add = ->
  window.beats.models.split_ratio_profiles().push(@)

window.beats.SplitRatioProfile::node_id = ->
  @get('node_id')

window.beats.SplitRatioProfile::set_node_id (id) = ->
  @set('node_id', id)

window.beats.SplitRatioProfile::start_time = ->
  @get('start_time')

window.beats.SplitRatioProfile::set_start_time (s) = ->
  @set('start_time', s)

window.beats.SplitRatioProfile::dt = ->
  @get('dt')

window.beats.SplitRatioProfile::set_dt (s) = ->
  @set('dt', s)

window.beats.SplitRatioProfile::network_id = ->
  @get('network_id')

window.beats.SplitRatioProfile::set_network_id (id) = ->
  @set('network_id', id)

window.beats.SplitRatioProfile::destination_network_id = ->
  @get('destination_network_id')

window.beats.SplitRatioProfile::set_destintation_network_id (id) = ->
  @set('destination_network_id', id)

window.beats.SplitRatioProfile::split_ratios = ->
  @get('splitratio')