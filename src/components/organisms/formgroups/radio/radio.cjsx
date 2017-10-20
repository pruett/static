[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require '../formgroup.scss'
  require './radio.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-formgroup'

  VARIATION_CLASS: 'c-formgroup--radio'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    name: React.PropTypes.string
    id: React.PropTypes.string
    children: React.PropTypes.node
    cssInput: React.PropTypes.string

  getDefaultProps: ->
    id: ''
    name: 'Radio'
    children: 'Polycarbonate lenses'
    cssInput: ''

  getStaticClasses: ->
    block: [
      @BLOCK_CLASS
      @VARIATION_CLASS
    ]
    input: [
      "#{@VARIATION_CLASS}__input"
      @props.cssInput
      'u-hide--visual'
    ]
    toggle:
      "#{@VARIATION_CLASS}__toggle"

  receiveStoreChanges: -> [
    'analytics'
  ]

  handleChange: (evt) ->
    @commandDispatcher 'analytics', 'pushFormEvent', evt
    @props.onChange(evt) if _.isFunction(@props.onChange)

  render: ->
    classes = @getClasses()

    <label htmlFor=@props.id className=classes.block>

      <input {...@props}
        id=@props.id
        name=@props.name
        type='radio'
        className=classes.input
        children=''
        onChange=@handleChange />

      <span className=classes.toggle />

      {@props.children}

    </label>
