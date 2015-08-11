`import Ember from 'ember'`

###
@module emberella
@submodule emberella-mixins
###

get = Ember.get
keys = Object.keys
typeOf = Ember.typeOf
computed = Ember.computed
observer = Ember.observer
mixin = Ember.mixin
run = Ember.run
debounce = run.debounce

###
  `HashBindingsMixin` combines attributes in the host object into
  computed hashes.

  To use this mixin, define an array of properties to compute in a
  `hashBindings` array.

  For each hash binding, define another array of properties to observe and
  assemble into computed properties. For example, if
  `hashBindings: ['filter']`, then `filterBindings: ['q', 'name']` will define
  the `filter` property on the parent object that produces a hash that looks
  like `{'q': 'value of q', 'name': 'value of name'}.

  You can optionally define change handlers that do something after the
  computed hash updates. For example, a `filterDidChange` method would be
  called each time the `q` or `name` property changes.

  If the change handler is computationally complex, you can delay calling
  the change handling method for some number of ms after the last in a series
  of changes. For example, setting `filterDelay: 500` on the parent object
  would cause `filterDidChange` to be called once, 500ms after a series of
  rapid changes to the `q` or `name` properties. This uses debounce.

  @example
    HashboundController = Ember.Controller.extend(HashBindingsMixin, {
      hashBindings: ['filter', 'page', 'remoteQuery'],

      filterBindings: ['q', 'name'],

      pageBindings: ['offset', 'limit'],

      remoteQueryBindings: ['thing', 'page', 'filter'],

      offset: 60,

      limit: 30,

      thing: 'foo',

      q: 'bar',

      name: 'Katzdale',

      remoteQueryChangeCount: 0,

      filterJSON: Ember.computed('filter', function () {
        return JSON.stringify(this.get('filter'));
      }),

      pageJSON: Ember.computed('page', function () {
        return JSON.stringify(this.get('page'));
      }),

      remoteQueryJSON: Ember.computed('remoteQuery', function () {
        return JSON.stringify(this.get('remoteQuery'));
      }),

      // Callback to handle changes to the computed `remoteQuery`
      remoteQueryDidChange: function remoteQueryDidChange() {
        return this.incrementProperty('remoteQueryChangeCount');
      },

      // Wait 500ms after the last change to call `remoteQueryDidChange`
      remoteQueryDelay: 500
    });

    // HashboundController.get('filter') -> {"q":"bar","name":"Katzdale"}
    // HashboundController.get('page') -> {"offset":60,"limit":30}
    // HashboundController.get('remoteQuery') -> {"thing":"foo","page":{"offset":60,"limit":30},"filter":{"q":"bar","name":"Katzdale"}}

  @class HashBindingsMixin
###

HashBindingsMixin = Ember.Mixin.create
  ###
    Make `hashBindings` property concatenated instead of replaced by
    inheritance chain.

    @property concatenatedProperties
    @type Array
    @default ['hashBindings']
    @final
  ###
  concatenatedProperties: ['hashBindings']

  ###
    Setup bindings to watch the properties named in the `hashBindings`
    attribute of this object.

    @method applyHashBindings
    @chainable
  ###
  applyHashBindings: ->
    hashBindings = @hashBindings

    return unless hashBindings and typeOf(hashBindings) is 'array'

    for hashBind in hashBindings when typeOf(bindings = get(@, hashBind + 'Bindings')) is 'array'
      lookup = {}
      bindComputed = null

      bindings.forEach (binding) ->
        [property, param] = binding.split(':')
        lookup[(param or property)] = property

      @_attachComputedProperty hashBind, lookup
      @_attachHashChangeHandler hashBind

    @

  _attachComputedProperty: (name, lookup) ->
    params = keys(lookup)
    properties = params.map (param) -> lookup[param]

    # create computed property
    bindComputed = computed
      get: =>
        result = {}
        params.forEach (param) =>
          val = get(@, lookup[param])
          result[param] = val if val
        result

    bindComputed.property.apply(bindComputed, properties)

    # define query computed properties
    remix = {}
    remix[name] = bindComputed
    mixin(@, remix)

    @

  _attachHashChangeHandler: (name) ->
    handlerName = name + 'DidChange'
    handler = get(@, handlerName)

    return @ if typeOf(handler) isnt 'function'

    handlerFn = =>
      delay = parseInt(get(@, name + 'Delay'), 10)
      if typeOf(delay) is 'number' and delay > 0
        debounce(@, get(@, handlerName), get(@, name), delay)
      else
        run(@, get(@, handlerName), get(@, name))

    remix = {}
    remix['__' + handlerName] = observer(name, handlerFn)
    mixin(@, remix)
    @

  initRemoteQueryBindings: Ember.on('init', ->
    @applyHashBindings()
  )

`export default HashBindingsMixin`
