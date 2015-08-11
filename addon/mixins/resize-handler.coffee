`import Ember from 'ember'`

jQuery = Ember.$
get = Ember.get
set = Ember.set
typeOf = Ember.typeOf
computed = Ember.computed
debounce = Ember.run.debounce

# The resize handler will fire onWindowResize when the window resize ends
ResizeHandlerMixin = Ember.Mixin.create
  ###
    Current state

    @property resizing
    @type Boolean
    @default false
  ###
  resizing: no

  # Time in ms to debounce before triggering resizeEnd
  resizeEndDelay: 100

  # This hook allows you to do any preparation to the view prior to any DOM
  # resize
  onResizeStart:  -> @

  # This hook allows you to clean up any sizing preparation
  onResizeEnd:    -> @

  # This hook allows you to listen to the window resizing
  onResize:       -> @

  # A resize handler that binds handleWindowResize to this view
  resizeHandler: computed({
    get: ->
      jQuery.proxy(@handleWindowResize, @)
  })

  # Browser only allows us to listen to windows resize. This function let us
  # resizeStart and resizeEnd event
  handleWindowResize: (evt) ->
    @_onResizeStart(evt)._onResize(evt)._onResizeEnd(evt)

  _onResizeStart: (evt) ->
    return @ if get(@, 'resizing')
    set(@, 'resizing', yes)
    onResizeStart = get(@, 'onResizeStart')
    if typeOf(onResizeStart) is 'function'
      onResizeStart.call(@, evt)
    @

  _onResize: (evt) ->
    onResize = get(@, 'onResize')
    if typeOf(onResize) is 'function'
      onResize.call(@, evt)
    @

  _onResizeEnd: (evt) ->
    debounce(@, @_debouncedOnResizeEnd, evt, get(@, 'resizeEndDelay'))
    @

  _debouncedOnResizeEnd: (evt) ->
    onResizeEnd = get(@, 'onResizeEnd')
    @set 'resizing', no
    if typeOf(onResizeEnd) is 'function'
      onResizeEnd.call(@, evt)
    @

  _setupResizeEventHandler: Ember.on 'didInsertElement', ->
    $(window).on 'resize.' + Ember.guidFor(@), get(@, "resizeHandler")

  _teardownResizeEventHandler: Ember.on 'willDestroy', ->
    $(window).off 'resize.' + Ember.guidFor(@), get(@, "resizeHandler")

`export default ResizeHandlerMixin`
