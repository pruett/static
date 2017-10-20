React = require 'react/addons'

require './default.scss'

module.exports = React.createClass

  BLOCK_CLASS: 'c-card-contents'

  propTypes:
    icon: React.PropTypes.func
    heading: React.PropTypes.string
    description: React.PropTypes.string

  getDefaultProps: ->
    icon: null
    heading: 'Heading'
    description: 'See All'

  render: ->
    <div className=@BLOCK_CLASS>
      {if @props.icon
        <div className="#{@BLOCK_CLASS}__icon">
          <@props.icon cssUtility='u-icon u-fill--dark-gray u-w100p'/>
        </div>}
      <div className="#{@BLOCK_CLASS}__details">
        <h2 className="#{@BLOCK_CLASS}__heading u-reset u-fs24 u-ffs u-fwn"
          children=@props.heading />
        <div className="#{@BLOCK_CLASS}__description"
          children=@props.description />
      </div>
    </div>
