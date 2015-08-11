`import Ember from 'ember'`
`import forEachAsync from 'ella-burn-ins/helpers/async-iterator'`

run = Ember.run
Promise = Ember.RSVP.Promise

forEachAsyncPromise = (context, objects, eachFn, runTime = 200, wait = 200) ->
  if (!(Ember.Enumerable.detect(objects) || Ember.isArray(objects)))
    throw new TypeError("Must pass Ember.Enumerable to forEachAsyncPromise");

  getTime = ->
    if Date.now then +Date.now() else +new Date()

  values = Ember.A()

  new Promise((resolve, reject) ->
    processItems = (items, process, callback) ->
      itemsToProcess = Array.prototype.slice.call(items)
      i = null

      loopFn = ->
        start = getTime()
        process.call(context, itemsToProcess.shift(), (if i? then ++i else 0))
        while itemsToProcess.length > 0 and getTime() - start < runTime
          values.push process.call(context, itemsToProcess.shift(), ++i)

        if itemsToProcess.length > 0
          run.later(context, loopFn, wait)

        else
          resolve(values)

      run(context, loopFn)

    processItems objects, eachFn
  )

`export default forEachAsyncPromise`
