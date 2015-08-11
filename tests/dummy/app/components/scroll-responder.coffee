`import Ember from 'ember'`
`import ScrollHandlerMixin from 'ella-burn-ins/mixins/scroll-handler'`

ScrollResponderComponent = Ember.Component.extend ScrollHandlerMixin,
  tagName: 'scroll-responder'

  scrollTop: 0

  onScroll: (evt) ->
    @sendAction('action', @$().scrollTop())

  _setup: Ember.on 'didInsertElement', ->
    @$().scrollTop @get('scrollTop')

`export default ScrollResponderComponent`
