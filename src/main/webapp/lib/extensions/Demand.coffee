window.beats.Demand::ident = ->
  @get('id')

window.beats.Demand::demand_order = ->
  @get('demand_order')

window.beats.Demand::vehicle_type_id = ->
  @get('vehicleType_id')

window.beats.Demand::demand = ->
  @get('content')