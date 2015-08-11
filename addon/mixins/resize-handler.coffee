`import Ember from 'ember'`

jQuery = Ember.$
get = Ember.get
set = Ember.set
typeOf = Ember.typeOf
computed = Ember.computed
debounce = Ember.run.debounce

###
  `ResizeHandlerMixin` pipes window resize events to a parent view/component.

  This mixin provides three (3) hooks for resize events: `onResizeStart`,
  `onResize`, and `onResizeEnd`.

  @class ResizeHandlerMixin
###

ResizeHandlerMixin = Ember.Mixin.create
  ###
    Current state: being resized or not being resized

    @property resizing
    @type Boolean
    @default false
  ###
  resizing: no

  ###
    The number of milliseconds to wait after the most recent resize event to
    consider the resizing action complete and call the onResizeEnd handler.

    @property resizeEndDelay
    @type Integer
    @default 100
  ###
  resizeEndDelay: 100

  ###
    A resize handler that binds _handleWindowResize to this component.

    @property resizeHandler
    @type Function
    @final
  ###
  resizeHandler: computed({
    get: ->
      jQuery.proxy(@_handleWindowResize, @)
  })

  ###
    Hook for responding to the beginning of a window resize action.

    Override with your own method if desired.

    @method onResizeStart
  ###
  onResizeStart:  (evt) -> @

  ###
    Hook for responding to the end of a window resize action.

    Override with your own method if desired.

    @method onResizeEnd
  ###
  onResizeEnd:    (evt) -> @

  ###
    Hook for responding to individual window resize events. These can fire
    very rapidly. Don't do anything too complex here.

    Override with your own method if desired.

    @method onResize
  ###
  onResize:       (evt) -> @

  ###
    @private

    Respond to window resize. Call onResizeStart, onResize, and onResizeEnd
    hooks as needed and if defined.

    @method _handleWindowResize
  ###
  _handleWindowResize: (evt) ->
    @_onResizeStart(evt)._onResize(evt)._onResizeEnd(evt)

  ###
    @private

    Wrapper for custom onResizeStart.

    @method _onResizeStart
  ###
  _onResizeStart: (evt) ->
    return @ if get(@, 'resizing')
    set(@, 'resizing', yes)
    onResizeStart = get(@, 'onResizeStart')
    if typeOf(onResizeStart) is 'function'
      onResizeStart.call(@, evt)
    @

  ###
    @private

    Wrapper for custom onResize.

    @method _onResize
  ###
  _onResize: (evt) ->
    onResize = get(@, 'onResize')
    if typeOf(onResize) is 'function'
      onResize.call(@, evt)
    @

  ###
    @private

    Wrapper for custom onResizeEnd.

    @method _onResizeEnd
  ###
  _onResizeEnd: (evt) ->
    debounce(@, @_debouncedOnResizeEnd, evt, get(@, 'resizeEndDelay'))
    @

  ###
    @private

    Debounced wrapper for custom onResizeEnd.

    @method _debouncedOnResizeEnd
  ###
  _debouncedOnResizeEnd: (evt) ->
    onResizeEnd = get(@, 'onResizeEnd')
    @set 'resizing', no
    if typeOf(onResizeEnd) is 'function'
      onResizeEnd.call(@, evt)
    @

  ###
    @private

    Observe for window resize events.

    @method _setupResizeEventHandler
  ###
  _setupResizeEventHandler: Ember.on 'didInsertElement', ->
    $(window).on 'resize.' + Ember.guidFor(@), get(@, "resizeHandler")

  ###
    @private

    Stop observing for window resize events.

    @method _teardownResizeEventHandler
  ###
  _teardownResizeEventHandler: Ember.on 'willDestroyElement', ->
    $(window).off 'resize.' + Ember.guidFor(@), get(@, "resizeHandler")

`export default ResizeHandlerMixin`
