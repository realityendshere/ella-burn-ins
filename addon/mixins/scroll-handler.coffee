`import Ember from 'ember'`

ScrollHandlerMixin = Ember.Mixin.create
  onScroll: -> @

  _setupScrollEventHandler: Ember.on 'didInsertElement', ->
    @$().bind 'scroll', (event) =>
      Ember.run @, @onScroll, event

  _teardownScrollEventHandler: Ember.on 'willDestroy', ->
    $element = @$()
    $element.unbind 'scroll' if $element and $element.unbind

`export default ScrollHandlerMixin`
