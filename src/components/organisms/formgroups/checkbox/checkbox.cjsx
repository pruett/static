[
  _
  React

  Error
  Checkbox

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/formgroup/error/error'
  require 'components/atoms/forms/checkbox/checkbox'

  require 'components/mixins/mixins'

  require '../formgroup.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-formgroup'

  VARIATION_CLASS: 'c-formgroup--checkbox'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    txtLabel: React.PropTypes.node
    txtError: React.PropTypes.string
    cssModifier: React.PropTypes.string
    cssLabelModifier: React.PropTypes.string

  getDefaultProps: ->
    txtLabel: 'Subscribe?'
    txtError: ''
    cssModifier: ''
    cssLabelModifier: ''

  getInitialState: ->
    id: "formgroup-checkbox-#{_.kebabCase(@props.txtLabel)}"

  getStaticClasses: ->
    block: [
      @BLOCK_CLASS
      @VARIATION_CLASS
      @props.cssModifier
    ]
    checkbox: [
      "#{@BLOCK_CLASS}__checkbox"
      @props.cssLabelModifier
    ]
    dataItem:
      "#{@BLOCK_CLASS}__data-item"
    error:
      "#{@BLOCK_CLASS}__error"
    errorText:
      "#{@BLOCK_CLASS}__error-text"

  render: ->
    classes = @getClasses()

    children = @props.children
    props = _.omit @props, 'children'

    <div className=classes.block>
      <Checkbox {...props}
        id=@state.id
        cssModifier=classes.checkbox />
      {children}
      <Error {...props} />
    </div>
