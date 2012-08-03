window.sirius.ReferenceHelper =
  resolver: (fieldGet, fieldSet, fieldType, name, errName, applyToChild) ->
    (deferred, object_with_id) ->
      deferred.push =>
        #console.log(@, fieldGet, fieldSet, fieldType, name, errName)
        idVal = @get(fieldGet)
        result = object_with_id[fieldType][idVal]
        throw "#{errName} instance can't find #{fieldType} for obj id == #{idVal}" unless result
        @set(fieldType, result)
        if applyToChild
          result.set(name, @)