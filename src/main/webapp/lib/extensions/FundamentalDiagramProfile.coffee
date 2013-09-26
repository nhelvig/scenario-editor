window.beats.FundamentalDiagramProfile::defaults =
  fundamentaldiagram: []
  fundamentaldiagramtype: null
  calibrationalgorithmtype: null
  crudFlag: null
  id: null
  link_id: null
  sensor_id: null
  start_time: 0
  dt: 0
  agg_run_id: null


window.beats.FundamentalDiagramProfile::initialize = () ->
  @set 'fundamentaldiagram', []

window.beats.FundamentalDiagramProfile::resolve_references =
  window.beats.ReferenceHelper.resolver('link_id', 'link', 'link', 'fundamentaldiagramprofile', 'FundamentalDiagramProfile', true)
  
window.beats.FundamentalDiagramProfile::encode_references = ->
  @set('link_id', @get('link').ident())

window.beats.FundamentalDiagramProfile::fundamental_diagrams = ->
  @get('fundamentaldiagram')
window.beats.FundamentalDiagramProfile::set_fundamental_diagram = (dia) ->
  @set('fundamentaldiagram', dia)

window.beats.FundamentalDiagramProfile::fundamental_diagram_type_id = ->
  @get('fundamentaldiagramtype').get('id') if @get('fundamentaldiagramtype')?
window.beats.FundamentalDiagramProfile::fundamental_diagram_type_name = ->
  @get('fundamentaldiagramtype').name() if @get('fundamentaldiagramtype')?
window.beats.FundamentalDiagramProfile::fundamental_diagram_type = ->
  @get('fundamentaldiagramtype')
window.beats.FundamentalDiagramProfile::set_fundamental_diagram_type = (id, name) ->
  @set('fundamentaldiagramtype', new window.beats.FundamentalDiagramType)  if not @fundamental_diagram_type()?
  @get('fundamentaldiagramtype').set('name', name)
  @get('fundamentaldiagramtype').set('id', id)
  @defaults['fundamentaldiagramtype'] = id

window.beats.FundamentalDiagramProfile::calibration_algorithm_type = ->
  @get('calibrationalgorithmtype')
window.beats.FundamentalDiagramProfile::set_calibration_algorithm_type= (type) ->
  @set('calibrationalgorithmtype', type)

window.beats.FundamentalDiagramProfile::crud = -> @get('crudFlag')
window.beats.FundamentalDiagramProfile::set_crud = (flag) ->
  @set('crudFlag', flag)

window.beats.FundamentalDiagramProfile::fdp_id = -> @get('id')
window.beats.FundamentalDiagramProfile::set_fdp_id = (id) -> @set('id', id)

window.beats.FundamentalDiagramProfile::link_id = -> @get('link_id')
window.beats.FundamentalDiagramProfile::set_link_id = (id) -> @set('link_id', id)

window.beats.FundamentalDiagramProfile::link = -> @get('link')
window.beats.FundamentalDiagramProfile::set_link = (id) -> @set('link', id)

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

# return the maximun fd order under the profile
# returns -1 if no fd's exist
window.beats.FundamentalDiagramProfile::max_order = ->
  fds = @.fundamental_diagrams()
  max_order = -1
  $.each(fds, (index, fd) ->
    if fd.order() > max_order
      max_order = fd.order()
  )
  max_order

# return fd at particular order
window.beats.FundamentalDiagramProfile::fd_at_order = (order) ->
  returnFd = null
  $.each(@.fundamental_diagrams(), (index, fd) ->
    if fd.order() == Number(order)
      returnFd = fd
  )
  returnFd
