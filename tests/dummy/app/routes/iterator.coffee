`import Ember from 'ember'`
`import forEachAsyncPromise from 'ella-burn-ins/helpers/promise-iterator'`

# Unmemoized to intentionally make it really slow
fib = (n) ->
  if n <= 2
    1
  else
    fib(n - 1) + fib(n - 2)

IteratorRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set('model', model)
    @_super(controller, model)

  model: ->
    forEachAsyncPromise(@, [1..10000], (num) ->
      # Complex computation that often forces loading indicator to appear
      (num * num * num * fib(20))
    )

`export default IteratorRoute`
