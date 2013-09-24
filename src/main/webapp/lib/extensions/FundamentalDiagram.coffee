window.beats.FundamentalDiagram::defaults =
  crudFlag: null
  id: null
  order: null
  capacity: null
  capacity_drop: null
  std_dev_capacity: null
  free_flow_speed: null
  congestion_speed: null
  critical_speed: null
  std_dev_free_flow_speed: null
  std_dev_congestion_speed: null
  jam_density: null

window.beats.FundamentalDiagram::initialize = () ->
  # add onchange event listener to following attributes to set CrudFlag to update
  @on('change:
          order,
          capacity,
          capacity_drop,
          std_dev_capacity,
          free_flow_speed,
          congestion_speed,
          critical_speed,
          std_dev_free_flow_speed,
          std_dev_congestion_speed,
          jam_density',
    @set_crud_flag(window.beats.CrudFlag.UPDATE))
  
window.beats.FundamentalDiagram::crud = -> @get('crudFlag')
window.beats.FundamentalDiagram::set_crud = (flag) ->
  @set('crudFlag', flag)
  # set FD Profile to update if flag is create, update, delete
  if flag == window.beats.CrudFlag.CREATE or
  flag == window.beats.CrudFlag.UPDATE or
  flag == window.beats.CrudFlag.DELETE
    window.beats.models.fundamentaldiagram_set().fundamentaldiagramprofile.set_crud_flag(window.beats.CrudFlag.UPDATE)

window.beats.FundamentalDiagram::ident = -> @get('id')
window.beats.FundamentalDiagram::set_ident = (id) -> @set('id', id)

window.beats.FundamentalDiagram::order = -> @get('order')
window.beats.FundamentalDiagram::set_order = (order) -> @set('order', order)

window.beats.FundamentalDiagram::capacity = -> @get('capacity')
window.beats.FundamentalDiagram::set_capacity = (cap) -> @set('capacity', cap)

window.beats.FundamentalDiagram::capacity_drop = -> @get('capacity_drop')
window.beats.FundamentalDiagram::set_capacity_drop = (cap) -> 
                                                    @set('capacity_drop', cap)

window.beats.FundamentalDiagram::std_dev_capacity = -> @get('std_dev_capacity')
window.beats.FundamentalDiagram::set_std_dev_capacity = (cap) ->
                                                   @set('std_dev_capacity', cap)

window.beats.FundamentalDiagram::free_flow_speed = -> @get('free_flow_speed')
window.beats.FundamentalDiagram::set_free_flow_speed = (free) ->
                                                   @set('free_flow_speed', free)

window.beats.FundamentalDiagram::congestion_speed = -> @get('congestion_speed')
window.beats.FundamentalDiagram::set_congestion_speed = (con) ->
                                                   @set('congestion_speed', con)

window.beats.FundamentalDiagram::critical_speed = -> @get('critical_speed')
window.beats.FundamentalDiagram::set_critical_speed = (crit) ->
                                                   @set('critical_speed', crit)

window.beats.FundamentalDiagram::std_dev_free_flow_speed = -> 
                                          @get('std_dev_free_flow_speed')
window.beats.FundamentalDiagram::set_std_dev_free_flow_speed = (free) ->
                                          @set('std_dev_free_flow_speed', free)

window.beats.FundamentalDiagram::std_dev_congestion_speed = -> 
                                          @get('std_dev_congestion_speed')
window.beats.FundamentalDiagram::set_std_dev_congestion_speed = (free) ->
                                          @set('std_dev_congestion_speed', free)

window.beats.FundamentalDiagram::jam_density = -> @get('jam_density')
window.beats.FundamentalDiagram::set_jam_density = (jam) -> @set('jam_density', jam)