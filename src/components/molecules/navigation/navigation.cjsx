[
  _
  React

  Link
  Drawer
  Secondary
  LogoImage
  X

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/link/link'
  require 'components/atoms/navigation/drawer/drawer'
  require 'components/atoms/navigation/secondary/secondary'
  require 'components/atoms/images/logo/logo'
  require 'components/quanta/icons/thin_x/thin_x'

  require 'components/mixins/mixins'

  require './navigation.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-navigation'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
  ]

  propTypes:
    bannerActive: React.PropTypes.bool
    layout: React.PropTypes.shape({
      isNavVisible: React.PropTypes.bool
      isOverlayShowing: React.PropTypes.bool
      jsSupport: React.PropTypes.bool
      visibleNavSubList: React.PropTypes.string
    })
    navigationId: React.PropTypes.string

  getDefaultProps: ->
    bannerActive: false
    layout:
      isNavVisible: false
      isOverlayShowing: false
      jsSupport: false

  getInitialState: ->
    focusOnLastLink: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-fl
      u-dib--900
      u-color-bg--white
      u-t0 u-b0
      u-w100p u-h100p
      u-pf
      u-vam--900
      u-tal
    "
    logo: "
      #{@BLOCK_CLASS}__logo
      u-db u-dn--900
      u-pr
    "
    close: "
      #{@BLOCK_CLASS}__close
    "
    list: "
      #{@BLOCK_CLASS}__list
      u-list-reset
      u-ps u-df u-db--900 u-flexd--c u-jc--c
    "
    link: '
      u-fs12 u-ffss
      u-link--nav
      u-color--dark-gray
      u-db
      u-pr8--1200 u-pl8--1200
      u-pb12 u-pb0--900
      u-mt0--900 u-mr24--900 u-mb12--900 u-ml24--900
      u-m0--1200
    '
    item: "
      #{@BLOCK_CLASS}__item
      u-vam--900
      u-pr
    "

  classesWillUpdate: ->
    visible = @isNavVisible()

    block:
      '-visible': visible
    list:
      # This is used with descendant selectors in Drawer.
      '-visible u-oh': visible

  isNavVisible: ->
    @props.layout.isNavVisible

  componentDidUpdate: (prevProps) ->
    if not prevProps.layout.isNavVisible and
      @props.layout.isNavVisible and
      not window.matchMedia('(min-width: 900px)').matches
        @focusElement 'nav'

  handleCloseClick: (evt) ->
    evt.preventDefault()
    @commandDispatcher 'layout', 'hideNavigation'
    @trackInteraction 'header-click-menu-off'

  handleLogoKeyDown: (evt) ->
    if evt.key is 'Tab' and evt.shiftKey
      evt.preventDefault()
      @setState focusOnLastLink: true, =>
        @setState focusOnLastLink: false

  focusElement: (ref) ->
    React.findDOMNode(@refs[ref]).focus()

  getNavProps: ->
    props =
      id: @props.navigationId
      ref: 'nav'
      role: 'navigation'

    if @props.layout.jsSupport
      _.assign props,
        'aria-hidden': not window.matchMedia('(min-width: 900px)').matches and
          not @isNavVisible()
        tabIndex: -1

    props

  getCloseLinkProps: ->
    props =
      href: '#'
      rel: 'nofollow'

    if @props.layout.jsSupport
      _.assign props,
        'aria-controls': @props.navigationId
        'aria-expanded': @isNavVisible()
        onClick: @handleCloseClick
        role: 'button'

    props

  render: ->
    classes = @getClasses()

    <nav {...@getNavProps()} className=classes.block>
      <Link href='/'
        className=classes.logo
        title='Back to homepage'
        onClick={@clickInteraction.bind(@, 'logo-nav-mobile')}
        onKeyDown=@handleLogoKeyDown
        ref='logo'>
        <LogoImage {...@props} />
      </Link>

      <Link {...@getCloseLinkProps()} className=classes.close>
        <X />
      </Link>

      <ul className=classes.list>
        {_.map @props.drawers, (drawer, index) =>
          <li className=classes.item key=index>
            <Drawer {...drawer}
              {...@props.layout}
              bannerActive=@props.bannerActive
              key="drawer--#{index}"
              name=@props.radioNameNav />
          </li>
        }

        <li className=classes.item>
          <Secondary {...@props}
            handleTabKeyDownOnLastLink={@focusElement.bind(@, 'logo')}
            focusOnLastLink=@state.focusOnLastLink
            name=@props.radioNameNav />
        </li>
      </ul>
    </nav>
