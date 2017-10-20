[
  _
  React

  Link
  XIcon
] = [
  require 'lodash'
  require 'react/addons'
  require 'components/atoms/link/link'
  require 'components/quanta/icons/x/x'

  require './wrapper.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-modal-wrapper'

  propTypes:
    children: React.PropTypes.node

    routeClose: React.PropTypes.string

    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    children: ''

    routeClose: ''

    cssModifier: ''


  render: ->
    <div className="#{@BLOCK_CLASS} #{@props.cssModifier}">

      <div className="#{@BLOCK_CLASS}__content #{@props.cssModifier}">
        {if @props.routeClose
          <Link className="#{@BLOCK_CLASS}__close" href=@props.routeClose>
            <XIcon />
          </Link>}
        {@props.children}
      </div>
    </div>
