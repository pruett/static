_ = require 'lodash'
React = require 'react/addons'
Mixins = require 'components/mixins/mixins'

require './message_badge.scss'

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-message-badge'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    active: false
    text: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-pa u-center
      u-p12
      u-br4
      u-fs14 u-fws u-wsnw
      u-color-bg--white
      u-bw1 u-bss u-bc--light-gray-alt-1
    "
    transition: "
      #{@BLOCK_CLASS}__transition
    "

  render: ->
    classes = @getClasses()

    <ReactCSSTransitionGroup
      transitionName=classes.transition
      transitionAppear>
      {if @props.active
        <div className=classes.block children=@props.text />}
    </ReactCSSTransitionGroup>
