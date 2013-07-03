# Override Javascript Number function so that it does not return NaN string if value is undefined
$a = window.beats
oldNumber = Number
window.Number = (value) ->
  newValue = oldNumber(value)
  if isNaN(newValue)
    return 0
  else
    return newValue