[
  _
  React

  CameraIcon
  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/camera/camera'
  require 'components/mixins/mixins'

  require './camera.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-camera-button'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    children: React.PropTypes.node
    cssModifier: React.PropTypes.string
    cssUtility: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''
    cssUtility: ''

  handleClick: (event) ->
    @props.onClick(event) if _.isFunction(@props.onClick)
    @trackInteraction event

  getStaticClasses: ->
    block: "#{@BLOCK_CLASS} #{@props.cssModifier} #{@props.cssUtility}"
    iconWrapper: "#{@BLOCK_CLASS}__icon-wrapper"
    inset: "#{@BLOCK_CLASS}__inset"

  render: ->
    classes = @getClasses()

    <a {...@props}
      onClick=@handleClick
      className=classes.block >
      <div className=classes.inset >
        <div className=classes.iconWrapper >
          <CameraIcon />
        </div>
      </div>
    </a>
