`import Ember from 'ember'`

# Copied from https://github.com/Addepar/ember-table/blob/master/src/utils/utils.coffee

ScrollHandlerMixin = Ember.Mixin.create
  onScroll: Ember.K

  didInsertElement: ->
    @_super()
    @$().bind 'scroll', (event) =>
      Ember.run @, @onScroll, event

  willDestroy: ->
    $element = @$()
    $element.unbind 'scroll' if $element and $element.unbind
    @_super()

`export default ScrollHandlerMixin`
