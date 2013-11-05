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
  
window.beats.FundamentalDiagram::crud = -> @get('crudFlag')
window.beats.FundamentalDiagram::set_crud = (flag) ->
  @set('crudFlag', flag)

window.beats.FundamentalDiagram::mod_stamp = -> @get('mod_stamp')
window.beats.FundamentalDiagram::set_mod_stamp = (stamp) -> 
  @set('mod_stamp', stamp)

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

window.beats.FundamentalDiagram::old_to_xml = window.beats.FundamentalDiagram::to_xml 
window.beats.FundamentalDiagram::to_xml = (doc) ->
  xml = @remove_crud_modstamp_for_xml(doc)
  xml