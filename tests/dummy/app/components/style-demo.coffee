`import Ember from 'ember'`
`import StyleBindingsMixin from 'ella-burn-ins/mixins/style-bindings'`

StyleDemoComponent = Ember.Component.extend StyleBindingsMixin,
  styleBindings: [
    'color'
    'background-color'
    'border-width'
    'border-style'
    'border-color'
    'height'
    'width'
    'padding'
  ]

  'color': '#000000'
  'background-color': '#CCCCCC'
  'border-width': 4
  'border-style': 'solid'
  'border-color': '#121212'
  'height': 100
  'width': 400
  'padding': 8

`export default StyleDemoComponent`
