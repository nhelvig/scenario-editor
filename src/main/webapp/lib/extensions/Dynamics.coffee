window.beats.Dynamics::defaults =
  type: "CTM"
  
window.beats.Dynamics::type = -> @get('type')
window.beats.Dynamics::set_type = (type) -> @set('type',type)