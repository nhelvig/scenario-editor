class window.beats.Event extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Event()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id)) if description? and description != ""
    display_position = xml.children('display_position')
    obj.set('display_position', $a.DisplayPosition.from_xml2(display_position, deferred, object_with_id)) if display_position? and display_position != ""
    targetElements = xml.children('targetElements')
    obj.set('targetelements', $a.TargetElements.from_xml2(targetElements, deferred, object_with_id)) if targetElements? and targetElements != ""
    parameters = xml.children('parameters')
    obj.set('parameters', _.reduce(parameters.find("parameter"),
          (acc,par_xml) ->
            wrapped_xml = $(par_xml);
            acc[wrapped_xml.attr('name')] = wrapped_xml.attr('value')
            acc
          {}
    )) if parameters? and parameters != ""
    splitratioEvent = xml.children('splitratioEvent')
    obj.set('splitratioevent', $a.SplitratioEvent.from_xml2(splitratioEvent, deferred, object_with_id)) if splitratioEvent? and splitratioEvent != ""
    id = $(xml).attr('id')
    obj.set('id', Number(id)) if id? and id != ""
    tstamp = $(xml).attr('tstamp')
    obj.set('tstamp', Number(tstamp)) if tstamp? and tstamp != ""
    enabled = $(xml).attr('enabled')
    obj.set('enabled', (enabled.toString().toLowerCase() == 'true') if enabled?) if enabled? and enabled != ""
    type = $(xml).attr('type')
    obj.set('type', type) if type? and type != ""
    java_class = $(xml).attr('java_class')
    obj.set('java_class', java_class) if java_class? and java_class != ""
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('event')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    xml.appendChild(@get('display_position').to_xml(doc)) if @has('display_position')
    xml.appendChild(@get('targetelements').to_xml(doc)) if @has('targetelements')
    if @has('parameters')
      parameters_xml = doc.createElement('parameters')
      _.each(@get('parameters'), (par_val, par_name) ->
          parameter_xml = doc.createElement('parameter')
          parameter_xml.setAttribute('name',par_name)
          parameter_xml.setAttribute('value', par_val)
          parameters_xml.appendChild(parameter_xml)
      )
      xml.appendChild(parameters_xml)
    
    xml.appendChild(@get('splitratioevent').to_xml(doc)) if @has('splitratioevent')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('tstamp', @get('tstamp')) if @has('tstamp')
    xml.setAttribute('enabled', @get('enabled')) if @has('enabled')
    xml.setAttribute('type', @get('type')) if @has('type')
    xml.setAttribute('java_class', @get('java_class')) if @has('java_class')
    xml
  
  deep_copy: -> Event.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null