`import Ember from 'ember'`

BaseViewMixin = Ember.Mixin.create
  baseViewBinding: 'parentView.baseView'

  initBaseView: Ember.on('init', ->
    @set '_self', @
  )

`export default BaseViewMixin`
