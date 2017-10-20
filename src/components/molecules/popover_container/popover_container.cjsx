[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './popover_container.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-popover-container'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    cssModifier: React.PropTypes.string
    handleClose: React.PropTypes.func
    isHto: React.PropTypes.bool

  getDefaultProps: ->
    cssModifier: ''
    isHto: false
    showClose: true
    handleClose: ->
    title: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-pa
      u-color-bg--white
      u-center-x
      u-bss u-bw1 u-bc--light-gray
    "
    content: "
      #{@BLOCK_CLASS}__content
    "

  componentDidMount: ->
    document.addEventListener 'click', @handleClickDocument
    document.addEventListener 'touchstart', @handleClickDocument

  componentWillUnmount: ->
    document.removeEventListener 'click', @handleClickDocument
    document.removeEventListener 'touchstart', @handleClickDocument

  handleClickDocument: (evt) ->
    return unless _.isFunction @props.handleClose

    container = React.findDOMNode @refs.container
    if container and not container.contains evt.target
      @props.handleClose()

  render: ->
    classes = @getClasses()

    <div
      id="pdp__popover--#{if @props.isHto then 'hto' else 'purchase'}"
      className=classes.block
      role='dialog'
      ref='container'>

      <div className=classes.content children=@props.children />

    </div>
