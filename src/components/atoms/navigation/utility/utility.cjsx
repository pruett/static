_ = require 'lodash'
React = require 'react/addons'

AccountUtilities = require 'components/atoms/navigation/account_utilities/account_utilities'
Link = require 'components/atoms/link/link'
IconCart = require 'components/quanta/icons/cart/cart'
SearchIcon = require 'components/quanta/icons/search/search'

Mixins = require 'components/mixins/mixins'
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

require './utility.scss'

module.exports = React.createClass

  BLOCK_CLASS: 'c-navigation-utility'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
    Mixins.context
  ]

  propTypes:
    layout: React.PropTypes.shape({
      isNavVisible: React.PropTypes.bool
      isOverlayShowing: React.PropTypes.bool
      jsSupport: React.PropTypes.bool
      visibleNavSubList: React.PropTypes.string
    })

  getDefaultProps: ->
    bannerActive: false
    focusOnLastLink: false
    layout:
      isNavVisible: false
      isOverlayShowing: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-reset--list
      u-db
      u-fr
      u-mr4
    "
    item: "
      #{@BLOCK_CLASS}__item
      u-dn u-dib--900
    "
    link: "
      #{@BLOCK_CLASS}__link
      u-reset u-fs12
      u-link--nav
    "
    cart: "
      #{@BLOCK_CLASS}__link
      u-reset u-fs12
      u-link--unstyled
    "
    count: "
      #{@BLOCK_CLASS}__count
      u-ls2_5
    "
    search: "
      u-reset--button
      u-reset u-fs12
      u-link--nav
      u-pr18 u-mr12
      u-bw0 u-brw1 u-bc--black-20p u-bss
    "
    icon: "
      u-mr8
      u-mtn1
      u-icon
      u-fill--dark-gray
    "

  endBenchmark: ->
    # End benchmark if not already completed.
    return if _.result @props, 'benchmarks.cartVisible.isComplete'
    _.result @props, 'benchmarks.cartVisible.end'

  componentDidMount: ->
    @endBenchmark() if window?

  getUtilities: ->
    @props.utilities or {}

  renderHelp: (classes) ->
    utilities = @getUtilities()

    if _.isObject(utilities.help)
      <li className=classes.item key='help'>
        <Link href=utilities.help.route
          className=classes.link
          onClick={@clickInteraction.bind(@, utilities.help.title)}
          children=utilities.help.title />
      </li>

  renderAccountUtilities: (classes) ->
    isLoggedIn = _.get @props, 'session.customer.authenticated', false
    utilities = @getUtilities()
    status = utilities["log#{if isLoggedIn then 'out' else 'in'}"] or {}

    if isLoggedIn
      <li className=classes.item key='accountUtils-loggedIn'>
        <AccountUtilities {...@props} />
      </li>
    else if _.isObject(status)
      <li className=classes.item key='accountUtils-loggedOut'>
        <Link href=status.route
          className=classes.link
          onClick={@clickInteraction.bind(@, status.title)}
          children=status.title />
      </li>

  renderCart: (classes) ->
    utilities = @getUtilities()
    quantity = _.get @props, 'session.cart.quantity', 0
    linkOpts =
      href: _.get(utilities, 'cart.route')
      className: classes.cart
      onClick: @clickInteraction.bind(@, _.get(utilities, 'cart.title'))

    if _.isObject(utilities.cart)
      <li className="#{classes.item} -cart" key='cart'>
        <Link {...linkOpts}>
          {
            [
              <IconCart
                cssModifier={if quantity > 0 then '-has-items' else null}
                key='cartIcon'
              />
              if quantity > 0 and window?
                <span className=classes.count key='quantity' children=quantity />
              else
                null
            ]
          }
        </Link>
      </li>

  handleClickSearch: (evt) ->
    @commandDispatcher 'search', 'enable'

  renderSearch: (classes) ->
    <li className=classes.item key='search'>
      <button className=classes.search onClick=@handleClickSearch>
        <SearchIcon cssUtility=classes.icon />SEARCH
      </button>
    </li>

  render: ->
    classes = @getClasses()

    <ul className=classes.block key='utility'>
      {
        [
          @renderSearch(classes)
          @renderHelp(classes)
          @renderAccountUtilities(classes)
          @renderCart(classes)
        ]
      }
    </ul>
