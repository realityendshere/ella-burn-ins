debounce = (func, wait, immediate) ->
  timeout = null
  result = null
  return ->
    context = this
    args = arguments
    later = ->
      timeout = null
      result = func.apply(context, args) unless immediate

    callNow = immediate && !timeout
    clearTimeout(timeout)
    timeout = setTimeout(later, wait)
    result = func.apply(context, args) if callNow
    result

`export default debounce`
