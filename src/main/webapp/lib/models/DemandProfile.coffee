class window.beats.DemandProfile extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.DemandProfile()
    knob = $(xml).attr('knob')
    obj.set('knob', Number(knob))
    start_time = $(xml).attr('start_time')
    obj.set('start_time', Number(start_time))
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt))
    link_id_origin = $(xml).attr('link_id_origin')
    obj.set('link_id_origin', link_id_origin)
    destination_network_id = $(xml).attr('destination_network_id')
    obj.set('destination_network_id', destination_network_id)
    std_dev_add = $(xml).attr('std_dev_add')
    obj.set('std_dev_add', Number(std_dev_add))
    std_dev_mult = $(xml).attr('std_dev_mult')
    obj.set('std_dev_mult', Number(std_dev_mult))
    obj.set('text', xml.text())
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('demandProfile')
    if @encode_references
      @encode_references()
    if @has('knob') && @knob != 1 then xml.setAttribute('knob', @get('knob'))
    if @has('start_time') && @start_time != 0 then xml.setAttribute('start_time', @get('start_time'))
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml.setAttribute('link_id_origin', @get('link_id_origin')) if @has('link_id_origin')
    xml.setAttribute('destination_network_id', @get('destination_network_id')) if @has('destination_network_id')
    xml.setAttribute('std_dev_add', @get('std_dev_add')) if @has('std_dev_add')
    xml.setAttribute('std_dev_mult', @get('std_dev_mult')) if @has('std_dev_mult')
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> DemandProfile.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null