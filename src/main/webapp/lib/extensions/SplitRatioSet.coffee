window.beats.SplitRatioSet::defaults =
  sensor: []

window.beats.SplitRatioSet::initialize = ->
  @set 'splitratioset', []

window.beats.SplitRatioSet::description_text = ->
  @get('description')?.get('text')

window.beats.SplitRatioSet::set_description_text = (s) ->
  @get('description').set('text',s)

window.beats.SplitRatioSet::name = ->
  @get('name')

window.beats.SplitRatioSet::set_name = (s) ->
  @set('name',s)

window.beats.SplitRatioSet::split_ratio_profiles = ->
  @get('splitratioprofiles')