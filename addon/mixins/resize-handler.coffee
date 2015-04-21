`import Ember from 'ember'`
`import debounce from 'ella-burn-ins/helpers/debounce'`

jQuery = Ember.$

# Copied from https://github.com/Addepar/ember-table/blob/master/src/utils/resize_handler.coffee
# Modified to use shared debounce helper
# Reduced default resize end delay property

# The resize handler will fire onWindowResize when the window resize ends
ResizeHandlerMixin = Ember.Mixin.create

  # Time in ms to debounce before triggering resizeEnd
  resizeEndDelay: 100
  resizing: no

  # This hook allows you to do any preparation to the view prior to any DOM
  # resize
  onResizeStart:  Ember.K
  # This hook allows you to clean up any sizing preparation
  onResizeEnd:    Ember.K
  # This hook allows you to listen to the window resizing
  onResize:       Ember.K

  # A debounced function to trigger the resizeEnd event. This is necessary
  # because we only want to fire resizeEnd if we have not received recent
  # resize event
  debounceResizeEnd: Ember.computed ->
    debounce (event) =>
      return if @isDestroyed
      @set 'resizing', no
      @onResizeEnd?(event)
    , @get('resizeEndDelay')
  .property('resizeEndDelay')

  # A resize handler that binds handleWindowResize to this view
  resizeHandler: Ember.computed ->
    jQuery.proxy(@handleWindowResize, @)
  .property()

  # Browser only allows us to listen to windows resize. This function let us
  # resizeStart and resizeEnd event
  handleWindowResize: (event) ->
    if not @get 'resizing'
      @set 'resizing', yes
      @onResizeStart?(event)
    @onResize?(event)
    @get('debounceResizeEnd')(event)

  didInsertElement: ->
    @_super()
    $(window).on 'resize.' + Ember.guidFor(@), @get("resizeHandler")

  willDestroy: ->
    $(window).off 'resize.' + Ember.guidFor(@), @get("resizeHandler")
    @_super()

`export default ResizeHandlerMixin`
