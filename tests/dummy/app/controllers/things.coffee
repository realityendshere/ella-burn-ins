`import Ember from 'ember'`
`import forEachAsync from 'ella-burn-ins/helpers/async-iterator'`
`import throttle from 'ella-burn-ins/helpers/throttle'`
`import debounce from 'ella-burn-ins/helpers/debounce'`
`import RemoteQueryBindingsMixin from 'ella-burn-ins/mixins/remote-query-bindings'`


ThingsController = Ember.Controller.extend RemoteQueryBindingsMixin,
  test: 'Hello, World'

  init: ->
    @set('loading', true)
    @set('listing', Ember.A())
    @testAsyncIterator()
    @_super()

  remoteQueryBindings: ['test', 'name', 'other']

  remoteQueryString: Ember.computed('remoteQuery', ->
    JSON.stringify(@get('remoteQuery'))
  )

  testAsyncIterator: ->
    objects = [0..400000]

    eachFn = (item, iter) ->
      @get('listing').pushObject('This is item: ' + (item + 1))

    completeFn = ->
      @set('loading', false)

    forEachAsync(@, objects, eachFn, completeFn)

`export default ThingsController`
