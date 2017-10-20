[
  _
  React

  Navigation
  LogoImage
  Link
  Utility
  IconMenu

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/navigation/navigation'
  require 'components/atoms/images/logo/logo'
  require 'components/atoms/link/link'
  require 'components/atoms/navigation/utility/utility'
  require 'components/quanta/icons/menu/menu'

  require 'components/mixins/mixins'

  require './header.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-header'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    cssModifier: React.PropTypes.string
    isOverlap: React.PropTypes.bool
    layout: React.PropTypes.object
    showHolidayGiftGuide: React.PropTypes.bool

  getDefaultProps: ->
    cssModifier: ''
    isOverlap: false
    layout: {}
    showHolidayGiftGuide: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-w100p
      u-tac u-tal--900
      u-wsnw
      u-color-bg--white
      u-pr
      u-pr6 u-pl6
    "
    container: "
      #{@BLOCK_CLASS}__container
      u-mw1440
      u-mra u-mla
    "
    menuTrigger:
      "#{@BLOCK_CLASS}__menu-trigger
      u-fs12 u-ffss
      u-link--nav
      u-cp
      u-fl
      u-dn--900"
    logo:
      "#{@BLOCK_CLASS}__logo
      u-vam--900
      u-pa u-pr--900
      u-dib--900
      u-fl--900"

  classesWillUpdate: ->
    block:
      '-overlap': @props.isOverlap
      '-expanded': @props.isOverlap and @props.layout.isNavVisible

  componentWillUnmount: ->
    document?.removeEventListener 'click', @handleClickDocument

  componentDidUpdate: (prevProps) ->
    wasNavVisible = prevProps.layout.isNavVisible
    isNavVisible = @props.layout.isNavVisible

    if wasNavVisible and not isNavVisible
      @unbindDocumentClickHandler()

      React.findDOMNode(@refs['menu-trigger']).focus()

    else if not wasNavVisible and isNavVisible
      @bindDocumentClickHandler()

  componentDidMount: ->
    if @props.layout.isNavVisible
      # Add auto-close if non-mobile and starts open.
      @bindDocumentClickHandler()

  isMobile: ->
    not window.matchMedia('(min-width: 900px)').matches

  bindDocumentClickHandler: ->
    document?.addEventListener 'click', @handleClickDocument

  unbindDocumentClickHandler: ->
    document?.removeEventListener 'click', @handleClickDocument

  getNavigationId: -> 'navigation'

  getMenuTriggerProps: (classes) ->
    navigationId = @getNavigationId()

    props =
      children: <IconMenu title="Menu icon" />
      href: "##{navigationId}"
      rel: 'nofollow'

    if @props.layout.jsSupport
      _.assign props,
        'aria-controls': navigationId
        'aria-expanded': @props.layout.isNavVisible
        onClick: @handleMenuTriggerClick
        onKeyDown: @handleMenuTriggerKeyDown
        role: 'button'
        skipRouting: true

    props

  handleClickDocument: (evt) ->
    return if @isMobile() # Don't auto-close on mobile.
    target = evt.target or {}

    if not @getDOMNode().contains(target) or
      (target.nodeName is 'A' and
        target.getAttribute('role') not in ['button', 'presentation'])
          @commandDispatcher 'layout', 'hideNavigation'

  handleMenuTriggerClick: (evt) ->
    evt.preventDefault()

    action = "#{if @props.layout.isNavVisible then 'hide' else 'show'}\
      Navigation"
    @commandDispatcher 'layout', action

    @trackInteraction "#{@getInteractionCategory()}-click-menu-on"

  render: ->
    classes = @getClasses()

    <header className=classes.block>
      <div className=classes.container>
        <Link {...(@getMenuTriggerProps())}
          className=classes.menuTrigger
          ref='menu-trigger' />
        <Link href='/'
          className=classes.logo
          onClick={@trackInteraction.bind(@, 'navigation-click-logo')}>
          <LogoImage {...@props} />
        </Link>

        <Navigation {...@props}
          navigationId=@getNavigationId() />

        <Utility {...@props} />
      </div>
    </header>
