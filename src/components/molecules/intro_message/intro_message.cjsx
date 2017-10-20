React = require 'react/addons'

require './intro_message.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-intro-message'

  propTypes:
    heading: React.PropTypes.string
    body: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    heading: 'Account'
    body: 'Hi there! All of your information is below.'
    cssModifier: ''

  render: ->
    <div className="#{@BLOCK_CLASS} #{@props.cssModifier}">
      <h1 className={[
        'c-intro-message__heading'
        'u-reset'
        'u-ffs'
        'u-fs30'
        'u-fws'].join ' '}>{@props.heading}</h1>
      <p className='c-intro-message__body u-reset u-fs16 u-mb24'>{@props.body}</p>
    </div>
