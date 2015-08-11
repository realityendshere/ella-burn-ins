`import Ember from 'ember'`

###
  `ScrollHandlerMixin` adds scroll event handling to a parent view/component.

  This mixin provides one (1) hook for scroll events: `onScroll`.

  @class ScrollHandlerMixin
###

ScrollHandlerMixin = Ember.Mixin.create
  onScroll: (evt) -> @

  _setupScrollEventHandler: Ember.on 'didInsertElement', ->
    @$().bind 'scroll', (evt) =>
      @onScroll.call(@, evt)

  _teardownScrollEventHandler: Ember.on 'willDestroyElement', ->
    $element = @$()
    $element.unbind 'scroll' if $element and $element.unbind

`export default ScrollHandlerMixin`
