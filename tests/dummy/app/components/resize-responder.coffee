`import Ember from 'ember'`
`import ResizeHandlerMixin from 'ella-burn-ins/mixins/resize-handler'`

ResizeResponderComponent = Ember.Component.extend ResizeHandlerMixin,
  tagName: 'resize-responder'

  width: 0

  height: 0

  message: 'Resize the window'

  resizeCount: 0

  onResizeStart: (evt) ->
    @set('message', 'Have fun storming the castle')

  onResize: (evt) ->
    @set('resizeCount', @get('resizeCount') + 1)

  onResizeEnd: (evt) ->
    @set('resizeCount', 0)
    @set('message', 'Resize the window')
    @set('width', document.documentElement.clientWidth)
    @set('height', document.documentElement.clientHeight)

    console.log "WIDTH ::", document.documentElement.clientWidth
    console.log "HEIGHT ::", document.documentElement.clientHeight

  _setup: Ember.on 'init', ->
    @set('width', document.documentElement.clientWidth)
    @set('height', document.documentElement.clientHeight)

`export default ResizeResponderComponent`
