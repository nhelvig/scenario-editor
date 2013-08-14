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
    parameters = xml.children('parameters')
    obj.set('parameters', _.reduce(parameters.find("parameter"),
          (acc,par_xml) ->
            wrapped_xml = $(par_xml);
            acc[wrapped_xml.attr('name')] = wrapped_xml.attr('value')
            acc
          {}
    )) if parameters? and parameters != ""
    display_position = xml.children('display_position')
    obj.set('display_position', $a.DisplayPosition.from_xml2(display_position, deferred, object_with_id)) if display_position? and display_position != ""
    targetElements = xml.children('targetElements')
    obj.set('targetelements', $a.TargetElements.from_xml2(targetElements, deferred, object_with_id)) if targetElements? and targetElements != ""
    feedbackElements = xml.children('feedbackElements')
    obj.set('feedbackelements', $a.FeedbackElements.from_xml2(feedbackElements, deferred, object_with_id)) if feedbackElements? and feedbackElements != ""
    queue_controller = xml.children('queue_controller')
    obj.set('queue_controller', $a.QueueController.from_xml2(queue_controller, deferred, object_with_id)) if queue_controller? and queue_controller != ""
    ActivationIntervals = xml.children('ActivationIntervals')
    obj.set('activationintervals', $a.ActivationIntervals.from_xml2(ActivationIntervals, deferred, object_with_id)) if ActivationIntervals? and ActivationIntervals != ""
    table = xml.children('table')
    obj.set('table', _.map($(table), (table_i) -> $a.Table.from_xml2($(table_i), deferred, object_with_id))) if table? and table != ""
    name = $(xml).attr('name')
    obj.set('name', name) if name? and name != ""
    type = $(xml).attr('type')
    obj.set('type', type) if type? and type != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt)) if dt? and dt != ""
    enabled = $(xml).attr('enabled')
    obj.set('enabled', (enabled.toString().toLowerCase() == 'true') if enabled?) if enabled? and enabled != ""
    java_class = $(xml).attr('java_class')
    obj.set('java_class', java_class) if java_class? and java_class != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('controller')
    if @encode_references
      @encode_references()
    if @has('parameters')
      parameters_xml = doc.createElement('parameters')
      _.each(@get('parameters'), (par_val, par_name) ->
          parameter_xml = doc.createElement('parameter')
          parameter_xml.setAttribute('name',par_name)
          parameter_xml.setAttribute('value', par_val)
          parameters_xml.appendChild(parameter_xml)
      )
      xml.appendChild(parameters_xml)
    
    xml.appendChild(@get('display_position').to_xml(doc)) if @has('display_position')
    xml.appendChild(@get('targetelements').to_xml(doc)) if @has('targetelements')
    xml.appendChild(@get('feedbackelements').to_xml(doc)) if @has('feedbackelements')
    xml.appendChild(@get('queue_controller').to_xml(doc)) if @has('queue_controller')
    xml.appendChild(@get('activationintervals').to_xml(doc)) if @has('activationintervals')
    _.each(@get('table') || [], (a_table) -> xml.appendChild(a_table.to_xml(doc)))
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