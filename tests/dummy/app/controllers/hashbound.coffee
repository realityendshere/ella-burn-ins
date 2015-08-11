`import Ember from 'ember'`
`import HashBindingsMixin from 'ella-burn-ins/mixins/hash-bindings'`


HashboundController = Ember.Controller.extend(HashBindingsMixin,

  hashBindings: ['filter', 'page', 'remoteQuery']

  filterBindings: ['q', 'name']
  pageBindings: ['offset', 'limit']
  remoteQueryBindings: ['thing', 'page', 'filter']

  offset: 60

  limit: 30

  thing: 'foo'

  q: 'bar'

  name: 'Katzdale'

  remoteQueryChangeCount: 0

  filterJSON: Ember.computed 'filter', ->
    JSON.stringify(@get('filter'))

  pageJSON: Ember.computed 'page', ->
    JSON.stringify(@get('page'))

  remoteQueryJSON: Ember.computed 'remoteQuery', ->
    JSON.stringify(@get('remoteQuery'))

  remoteQueryDidChange: ->
    @incrementProperty 'remoteQueryChangeCount'

  remoteQueryDelay: 500

)

`export default HashboundController`
