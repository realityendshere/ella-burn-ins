`import Ember from 'ember'`

IndexRoute = Ember.Route.extend
  redirect: -> @transitionTo 'resize'

`export default IndexRoute`
