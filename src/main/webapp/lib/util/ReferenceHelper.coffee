# Method to resolve references (ie. can add split-ratio profiles to nodes and demand profiles to
# links)
# @param fieldGet Field to resolve to (usually id of node or link)
# @param fieldSet model name to set reference to
# @param fieldType model type
# @param name Name of reference to be set (ie. a profile on a link or node)
# @param errName Name of reference class
# @param applyToChild boolean whether to set then name reference to the model
window.beats.ReferenceHelper =
  resolver: (fieldGet, fieldSet, fieldType, name, errName, applyToChild) ->
    (deferred, object_with_id) ->
      deferred.push =>
        idVal = @get(fieldGet)
        result = object_with_id[fieldType][idVal]
        # Comment out exception in case set has extra elements not defined in scenario
        #throw "#{errName} instance can't find #{fieldType} for obj id == #{idVal}" unless result
        if result?
          @set(fieldType, result)
          if applyToChild
            result.set(name, @)