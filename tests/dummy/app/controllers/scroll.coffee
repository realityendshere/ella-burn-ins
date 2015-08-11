`import Ember from 'ember'`

ScrollController = Ember.Controller.extend(
  queryParams: ['scroll'],
  scroll: 0,

  actions: {
    didScroll: (value) ->
      @set('scroll', value)
  }
)

`export default ScrollController`
