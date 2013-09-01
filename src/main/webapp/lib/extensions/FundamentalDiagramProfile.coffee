window.beats.FundamentalDiagramProfile::defaults =
  fundamentaldiagram: null
  fundamentaldiagramtype: null
  calibrationalgorithmtype: null
  crudFlag: null
  id: null
  link_id: null
  sensor_id: null
  start_time: null
  dt: null
  agg_run_id: null

window.beats.FundamentalDiagramProfile::resolve_references =
  window.beats.ReferenceHelper.resolver('link_id', 'link', 'link', 'fundamentaldiagramprofile', 'FundamentalDiagramProfile', true)
  
window.beats.FundamentalDiagramProfile::encode_references = ->
  @set('link_id', @get('link').ident())

window.beats.FundamentalDiagramProfile::fundamental_diagram = ->
  @get('fundamentaldiagram')
window.beats.FundamentalDiagramProfile::set_fundamental_diagram = (dia) ->
  @set('fundamentaldiagram', dia)

window.beats.FundamentalDiagramProfile::fundamental_diagram_type = ->
  @get('fundamentaldiagramtype')
window.beats.FundamentalDiagramProfile::set_fundamental_diagram_type = (type) ->
  @set('fundamentaldiagramtype', type)

window.beats.FundamentalDiagramProfile::calibration_algorithm_type = ->
  @get('calibrationalgorithmtype')
window.beats.FundamentalDiagramProfile::set_calibration_algorithm_type= (type) ->
  @set('calibrationalgorithmtype', type)

window.beats.FundamentalDiagramProfile::crudflag = -> @get('crudFlag')
window.beats.FundamentalDiagramProfile::set_crudflag= (flag) -> 
  @set('crudFlag', flag)

window.beats.FundamentalDiagramProfile::fdp_id = -> @get('id')
window.beats.FundamentalDiagramProfile::set_fdp_id = (id) -> @set('id', id)

window.beats.FundamentalDiagramProfile::link_id = -> @get('link_id')
window.beats.FundamentalDiagramProfile::set_link_id = (id) -> @set('link_id', id)

window.beats.FundamentalDiagramProfile::sensor_id = -> @get('sensor_id')
window.beats.FundamentalDiagramProfile::set_sensor_id = (id) -> 
  @set('sensor_id', id)

window.beats.FundamentalDiagramProfile::start_time = -> @get('start_time')
window.beats.FundamentalDiagramProfile::set_start_time = (time) -> 
  @set('start_time', time)

window.beats.FundamentalDiagramProfile::dt = -> @get('dt')
window.beats.FundamentalDiagramProfile::set_dt = (dt) -> @set('dt', dt)

window.beats.FundamentalDiagramProfile::mod_time = -> @get('mod_time')

window.beats.FundamentalDiagramProfile::agg_run_id = -> @get('agg_run_id')
window.beats.FundamentalDiagramProfile::set_agg_run_id = (id) ->
  @set('agg_run_id', id)