[
  _
  React

  IconX

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/x/x'

  require 'components/mixins/mixins'

  require './notification.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-notification'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    handleClickClose: React.PropTypes.func
    children: React.PropTypes.node

  getDefaultProps: ->
    handleClick: ->

  getStaticClasses: ->
    block: [
      @BLOCK_CLASS
      'u-bgcolor--light-gray-3'
      'u-reset u-fs16'
    ]
    close: [
      "#{@BLOCK_CLASS}__close"
      'u-button-reset'
    ]
    content:
      "#{@BLOCK_CLASS}__content"
    icon:
      '-size-75'

  classesWillUpdate: ->
    content:
      '-has-close': not _.isEmpty @props.handleClickClose

  render: ->
    classes = @getClasses()

    <div className=classes.block role='alert'>
      {unless _.isEmpty @props.handleClickClose
        <button type='button'
          aria-label="Close"
          className=classes.close
          onClick=@props.handleClickClose>
          <IconX cssModifier=classes.icon />
        </button>}
      <div className=classes.content children=@props.children />
    </div>
