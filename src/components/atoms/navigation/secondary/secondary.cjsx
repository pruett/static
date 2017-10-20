[
  _
  React

  SearchIcon
  Link

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/search/search'
  require 'components/atoms/link/link'

  require 'components/mixins/mixins'

  require './secondary.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-navigation-secondary'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
  ]

  propTypes:
    bannerActive: React.PropTypes.bool
    focusOnLastLink: React.PropTypes.bool
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
    block:
      "#{@BLOCK_CLASS}
      u-pr u-ps--900
      u-tac
      u-dib--900
      u-tal--900
      u-vam--900
      u-pt18
      u-color-bg--light-gray-alt-2 u-color-bg--white--900
    "
    list: "
      #{@BLOCK_CLASS}__list
      u-dib
      u-mt24 u-mra u-mb24 u-mla
      u-m0--900
      u-p0 u-pt24--900 u-pb12--900 u-p0--1200
      u-mw100p
      u-pr u-pa--900 u-ps--1200
      u-tac u-tal--900
      u-ta--1200 u-la--1200
      u-vam--1200
    "
    item: "
      #{@BLOCK_CLASS}__item
      u-tal
      u-db u-dib--1200
      u-vam
    "
    itemUtility: "
      #{@BLOCK_CLASS}__item-utility
      u-tal
      u-db u-dn--900
      u-vam
    "
    listToggle: "
      #{@BLOCK_CLASS}__list-toggle
      u-fs12 u-ffss
      u-link--nav
      u-p0 u-pr8 u-pl8
      u-dn u-dib--900 u-dn--1200
      u-vam--900
      u-bw0
    "
    link:
      'u-fs12 u-ffss
      u-link--nav
      u-color--dark-gray
      u-db
      u-pr8--1200 u-pl8--1200
      u-pb12 u-pb0--900
      u-mt0--900 u-mr24--900 u-mb12--900 u-ml24--900
      u-m0--1200'
    searchWrapper: '
      u-mr18 u-ml18 u-dn--900
      u-bc--light-gray u-bw0 u-bbw1 u-bss
      u-tal
    '
    search: "
      #{@BLOCK_CLASS}__search
      u-db u-dn--900
      u-m0a
      u-w100p
      u-tal
      u-reset--button
      u-reset u-fs12
      u-link--nav
      u-color-bg--light-gray-alt-2
      u-pb12
    "
    icon: "
      u-mr8
      u-mtn1
      u-icon
      u-fill--dark-gray
    "

  classesWillUpdate: ->
    block:
      '-visible': @isSubListVisible()
    list:
      '-banner': @props.bannerActive

  isSubListVisible: (props = @props) ->
    props.layout.visibleNavSubList is @getId()

  componentDidMount: ->
    @attachKeyDownHandlers()

  componentWillUnmount: ->
    @removeKeyDownHandler()

  componentDidUpdate: (prevProps, prevState) ->
    if not prevProps.focusOnLastLink and
      @props.focusOnLastLink
        @getLastLink()?.focus()

  attachKeyDownHandlers: ->
    # Keep focus inside navigation while it's visible.
    @getLastLink()?.addEventListener 'keydown', @handleLastLinkKeyDown

  removeKeyDownHandler: ->
    @getLastLink()?.removeEventListener 'keydown', @handleLastLinkKeyDown

  getLastLink: ->
    links = React.findDOMNode(@refs.list)?.querySelectorAll 'li a'
    links[links.length - 1]

  handleLastLinkKeyDown: (evt) ->
    # User is tabbing from the last link in the nav, so tell the parent to
    # move focus to the first focusable element there.
    if evt.key is 'Tab' and
      not evt.shiftKey and
      _.isFunction @props.handleTabKeyDownOnLastLink
        evt.preventDefault()
        @props.handleTabKeyDownOnLastLink()

  renderSecondaryLinks: (link, index) ->
    title = if link.route is '/retail' and @inExperiment 'retailNavLink', 'stores'
      'Stores'
    else
      link.title

    <li className=@classes.item key=link.title>
      <a href=link.route
        className=@classes.link
        onClick={@clickInteraction.bind(@, link.title)}
        children=title />
    </li>

  handleClick: (evt) ->
    evt.preventDefault()

    subListId = @getId()
    action =
      if @isSubListVisible()
        type: 'hide'
        id: null
        state: 'off'
      else
        type: 'show'
        id: subListId
        state: 'on'

    @commandDispatcher 'layout', "#{action.type}Navigation", action.id

    @trackInteraction "#{@getInteractionCategory()}-click-\
      #{subListId}-#{action.state}"

  getTitle: ->
    _.get @props, 'secondary.title', ''

  getId: ->
    _.camelCase @getTitle()

  getListToggleJsProps: ->
    if @props.layout.jsSupport
      'aria-controls': @getId()
      'aria-expanded': @isSubListVisible()
      onClick: @handleClick
    else
      {}

  handleClickSearch: (evt) ->
    @commandDispatcher 'search', 'enable'

  render: ->
    @classes = @getClasses()

    secondary = @props.secondary or {}
    utilities = @props.utilities or {}

    secondaryId = @getId()
    secondaryTitle = @getTitle()

    isLoggedIn = _.get @props, 'session.customer'

    status = utilities["log#{if isLoggedIn then 'out' else 'in'}"] or {}

    <div className=@classes.block>
      <div className=@classes.searchWrapper>
        <button className=@classes.search onClick=@handleClickSearch>
          <SearchIcon cssUtility=@classes.icon /> SEARCH WARBY PARKER
        </button>
      </div>
      <button
        children=@getTitle()
        className=@classes.listToggle
        type='button'
        {...(@getListToggleJsProps())} />

      <ul className=@classes.list ref='list' id=@getId()>
        {_.map secondary.links, @renderSecondaryLinks}

        {if _.isObject(utilities.help)
          <li className=@classes.itemUtility>
            <Link href=utilities.help.route
              className=@classes.link
              onClick={@clickInteraction.bind(@, utilities.help.title)}
              children=utilities.help.title />
          </li>}

        {if isLoggedIn and _.isObject(utilities.my_account)
          <li className=@classes.itemUtility>
            <Link href=utilities.my_account.route
              className=@classes.link
              onClick={@clickInteraction.bind(@, utilities.my_account.title)}
              children=utilities.my_account.title />
          </li>}

        {if _.isObject(status)
          <li className=@classes.itemUtility>
            <Link href=status.route
              className=@classes.link
              onClick={@clickInteraction.bind(@, status.title)}
              children=status.title />
          </li>}
      </ul>
    </div>
