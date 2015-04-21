`import Ember from 'ember'`

ThingsRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set('errorMessage', null)

`export default ThingsRoute`



