`import Ember from 'ember'`

get = Ember.get
set = Ember.set
keys = Object.keys
typeOf = Ember.typeOf
computed = Ember.computed
mixin = Ember.mixin

# TODO: Improve CSS value escaping
escapeCSS = (value) ->
  # Eliminate semi-colons and any content following a semi-colon
  # This prevents anything other than a single style from being
  # set. However, this may disrupt some legitimate styles and
  # and doesn't cover all XSS attack vectors.
  return '' unless typeOf(value) is 'string'
  value.replace /;.*$/, ''

###
  `StyleBindingsMixin` combines specified attributes into a computed `style`
  attribute to add to the parent view/component.

  @class StyleBindingsMixin
###

StyleBindingsMixin = Ember.Mixin.create
  ###
    @property isStyleBindings
    @type Boolean
    @default true
    @final
  ###
  isStyleBindings: true #quack like a duck

  ###
    Make `styleBindings` property concatenated instead of replaced by
    inheritance chain.

    @property concatenatedProperties
    @type Array
    @default ['styleBindings']
    @final
  ###
  concatenatedProperties: ['styleBindings']

  ###
    Bind `style` attribute to element's `style` attribute.

    @property attributeBindings
    @type Array
    @default ['style']
    @final
  ###
  attributeBindings: ['style']

  ###
    Measurment to use when style values are numeric.

    @property unitType
    @type String
    @default ['style']
  ###
  unitType: 'px'

  ###
    Compute a style string.

    @method createStyleString
    @return String
  ###
  createStyleString: (styleName, property) ->
    value = get @, property
    return unless value?
    @makeStyleProperty styleName, value

  ###
    Compute an escaped style.

    @method makeStyleProperty
    @return String
  ###
  makeStyleProperty: (styleName, value) ->
    if typeOf(value) is 'number'
      value = value + @get('unitType')
    else
      value = escapeCSS value
    "#{styleName}:#{value};"

  ###
    Inject observers and computed properties responsible for assembling a
    style attribute.

    @method applyStyleBindings
    @chainable
  ###
  applyStyleBindings: ->
    styleBindings = @styleBindings
    return unless styleBindings

    # get properties from bindings e.g. ['width', 'top']
    lookup = {}
    styleBindings.forEach (binding) ->
      [property, style] = binding.split(':')
      lookup[(style or property)] = property

    styles = keys(lookup)
    properties = styles.map (style) -> lookup[style]

    # create computed property
    styleComputed = computed
      get: =>
        styleTokens = styles.map (style) =>
          @createStyleString style, lookup[style]
        styleString = styleTokens.join('')
        new Ember.Handlebars.SafeString(if (styleString.length is 0) then '' else styleString)

    # add dependents to computed property
    styleComputed.property.apply(styleComputed, properties)

    # define style computed properties
    mixin(@, {'style': styleComputed})
    return @

  initStyleBindings: Ember.on('init', ->
    @applyStyleBindings()
  )

`export default StyleBindingsMixin`
