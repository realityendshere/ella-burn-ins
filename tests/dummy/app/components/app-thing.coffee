`import Ember from 'ember'`
`import StyleBindingsMixin from 'ella-burn-ins/mixins/style-bindings'`
`import ScrollHandlerMixin from 'ella-burn-ins/mixins/scroll-handler'`
`import ResizeHandlerMixin from 'ella-burn-ins/mixins/resize-handler'`

AppThingComponent = Ember.Component.extend StyleBindingsMixin, ScrollHandlerMixin, ResizeHandlerMixin,
  styleBindings: ['color', 'font-size']

  'font-size': Ember.computed('viewportHeight', ->
    h = @get 'viewportHeight'

    h/10
  ),

  color: Ember.computed('viewportWidth', ->
    w = @get 'viewportWidth'

    switch
      when w < 600 then 'red'
      when w < 700 then 'orange'
      when w < 800 then 'yellow'
      when w < 900 then 'green'
      when w < 1000 then 'blue'
      when w < 1100 then 'purple'
      else 'black'
  ),

  viewportWidth: 0

  viewportHeight: 0

  onResizeEnd: ->
    @set('viewportWidth', Math.max(document.documentElement.clientWidth, window.innerWidth || 0))
    @set('viewportHeight', Math.max(document.documentElement.clientHeight, window.innerHeight || 0))

  setup: Ember.on('init', ->
    @onResizeEnd()
  )

`export default AppThingComponent`
