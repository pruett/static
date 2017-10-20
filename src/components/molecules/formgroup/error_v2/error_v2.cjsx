[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require '../error/error.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-formgroup-error'

  propTypes:
    txtError: React.PropTypes.string

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    txtError: ''
    cssModifier: ''
    isRed: true

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      -v2
    "
    text: '
      u-pt12
      u-fs14
    '

  classesWillUpdate: ->
    text:
      'u-color--red-alt-2': @props.isRed

  render: ->
    classes = @getClasses()

    <ReactCSSTransitionGroup transitionName='error'>
      {if not _.isEmpty(@props.txtError)
        <div className=classes.block key='error'>
          <div className=classes.text children=@props.txtError />
        </div>
      }
    </ReactCSSTransitionGroup>
