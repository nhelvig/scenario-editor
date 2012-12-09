class window.beats.Controller extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Controller()
    display_position = xml.children('position')
    obj.set('display_position', $a.Display_position.from_xml2(display_position, deferred, object_with_id))
    targetElements = xml.children('targetElements')
    obj.set('targetelements', $a.TargetElements.from_xml2(targetElements, deferred, object_with_id))
    feedbackElements = xml.children('feedbackElements')
    obj.set('feedbackelements', $a.FeedbackElements.from_xml2(feedbackElements, deferred, object_with_id))
    queue_controller = xml.children('queue_controller')
    obj.set('queue_controller', $a.Queue_controller.from_xml2(queue_controller, deferred, object_with_id))
    parameters = xml.children('parameters')
    obj.set('parameters', _.reduce(parameters.find("parameter"),
          (acc,par_xml) ->
            wrapped_xml = $(par_xml);
            acc[wrapped_xml.attr('name')] = wrapped_xml.attr('value')
            acc
          {}
    ))
    table = xml.children('table')
    obj.set('table', $a.Table.from_xml2(table, deferred, object_with_id))
    ActivationIntervals = xml.children('ActivationIntervals')
    obj.set('activationintervals', $a.ActivationIntervals.from_xml2(ActivationIntervals, deferred, object_with_id))
    PlanSequence = xml.children('PlanSequence')
    obj.set('plansequence', $a.PlanSequence.from_xml2(PlanSequence, deferred, object_with_id))
    PlanList = xml.children('PlanList')
    obj.set('planlist', $a.PlanList.from_xml2(PlanList, deferred, object_with_id))
    name = $(xml).attr('name')
    obj.set('name', name)
    type = $(xml).attr('type')
    obj.set('type', type)
    id = $(xml).attr('id')
    obj.set('id', id)
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt))
    enabled = $(xml).attr('enabled')
    obj.set('enabled', (enabled.toString().toLowerCase() == 'true') if enabled?)
    java_class = $(xml).attr('java_class')
    obj.set('java_class', java_class)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('controller')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('display_position').to_xml(doc)) if @has('display_position')
    xml.appendChild(@get('targetelements').to_xml(doc)) if @has('targetelements')
    xml.appendChild(@get('feedbackelements').to_xml(doc)) if @has('feedbackelements')
    xml.appendChild(@get('queue_controller').to_xml(doc)) if @has('queue_controller')
    if @has('parameters')
      parameters_xml = doc.createElement('parameters')
      _.each(@get('parameters'), (par_val, par_name) ->
          parameter_xml = doc.createElement('parameter')
          parameter_xml.setAttribute(par_name, par_val)
          parameters_xml.appendChild(parameter_xml)
      )
      xml.appendChild(parameters_xml)
    
    xml.appendChild(@get('table').to_xml(doc)) if @has('table')
    xml.appendChild(@get('activationintervals').to_xml(doc)) if @has('activationintervals')
    xml.appendChild(@get('plansequence').to_xml(doc)) if @has('plansequence')
    xml.appendChild(@get('planlist').to_xml(doc)) if @has('planlist')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('type', @get('type')) if @has('type')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml.setAttribute('enabled', @get('enabled')) if @has('enabled')
    xml.setAttribute('java_class', @get('java_class')) if @has('java_class')
    xml
  
  deep_copy: -> Controller.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null