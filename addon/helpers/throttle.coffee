throttle = (func, wait) ->
  context = null
  args = null
  timeout = null
  result = null
  previous = 0
  later = ->
    previous = new Date()
    timeout = null
    result = func.apply(context, args)

  return ->
    now = new Date()
    remaining = wait - (now - previous)
    context = this
    args = arguments
    if remaining <= 0
      clearTimeout(timeout)
      timeout = null
      previous = now
      result = func.apply(context, args)
    else
      timeout = setTimeout(later, remaining)
    result

`export default throttle`
