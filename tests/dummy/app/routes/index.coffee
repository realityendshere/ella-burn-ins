`import Ember from 'ember'`

IndexRoute = Ember.Route.extend
  redirect: -> @transitionTo 'things'

`export default IndexRoute`
