_           = require 'lodash'
React       = require 'react/addons'
BurgerIcon  = require 'components/quanta/icons/burger/burger'
XIcon       = require 'components/quanta/icons/x/x'

require './burger.scss'

module.exports = React.createClass
  propTypes:
    targetId: React.PropTypes.string.isRequired
    title: React.PropTypes.string
    isMenuOpen: React.PropTypes.bool

  getDefaultProps: ->
    targetId: '#' # Nav menu's id, without the hash
    title: 'Header navigation'
    isMenuOpen: false

  handleClick: (event) ->
    event.preventDefault()
    ###
    # TODO: dispatch action
    ###

  render: ->
    props =
      className: 'c-burger-button'
      href: @props.targetId
      onClick: @handleClick
      title: @props.title
      role: 'button'
      'aria-label': @props.title
      'aria-controls': @props.targetId
      'aria-expanded': @props.isMenuOpen

    svgProps = _.extend {}, @props,
      svgClass: "c-burger-button__svg #{if @props.isMenuOpen then '-is-open' else ''}"

    svgContent = if @props.isMenuOpen
        <XIcon {...svgProps} />
      else
        <BurgerIcon {...svgProps} />

    <a {...props}>
      {svgContent}
    </a>
