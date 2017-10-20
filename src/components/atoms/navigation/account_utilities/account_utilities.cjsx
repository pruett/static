_ = require 'lodash'
React = require 'react/addons'

Link = require 'components/atoms/link/link'
Mixins = require 'components/mixins/mixins'

require './account_utilities.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-navigation-account-utility'
  ANALYTICS_CATEGORY: 'favoritesAccountNav'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  getDefaultProps: ->
    bannerActive: false

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-pr
      u-tac
      u-dib--900
      u-ps--900
      u-tal--900
      u-vam--900"
    listToggle: "
      #{@BLOCK_CLASS}__list-toggle
      u-fs12 u-ffss
      u-link--nav
      u-dn u-dib--900
      u-pt18 u-pr8 u-pb18 u-pl8
      u-vam--900
      u-bw0
    "
    list: "
      #{@BLOCK_CLASS}__list
      u-dib
      u-mt24 u-mra u-mb24 u-mla
      u-m0--900
      u-p0 u-pt24--900 u-pb12--900
      u-mw100p
      u-pr u-pa--900
      u-tac u-tal--900
      u-oh
    "
    item:
      'u-tal
      u-db
      u-vam'
    itemUtility:
      'u-tal
      u-db u-dn--900
      u-vam'
    link: "
      #{@BLOCK_CLASS}__link
      u-fs12 u-ffss
      u-link--nav
      u-color--dark-gray
      u-db
      u-pt18 u-p0--900
      u-mt0-900 u-mr24--900 u-mb12--900 u-ml24--900
    "

  classesWillUpdate: ->
    block:
      '-visible': @isSubListVisible()
    list:
      '-banner': @props.bannerActive
      '-icon-align':
        @props.navigationIconVariant in ['cartAndAccount', 'all']

  isSubListVisible: (props = @props) ->
    props.layout.visibleNavSubList is @getId()

  getTitle: ->
    _.get @props, 'account_utilities.title', ''

  getId: ->
    _.camelCase @getTitle()

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

  getListToggleJsProps: ->
    id = @getId()
    props = 'data-nav-id': id
    if @props.layout.jsSupport
      _.assign props,
        'aria-controls': @getId()
        'aria-expanded': @props.layout.isNavVisible
        onClick: @handleClick
    else
      props

  render: ->
    classes = @getClasses()

    accountUtilities = @props.account_utilities or {}

    isLoggedIn = _.get @props, 'session.customer'

    <div className=classes.block>

      <button
        children=@getTitle()
        className=classes.listToggle
        type='button'
        {...(@getListToggleJsProps())} />

      <ul className=classes.list id=@getId()>

        {_.map accountUtilities.links, (link, index) =>
          <li className=classes.item key=link.title>
            <a href=link.route
               className=classes.link
               onClick={@clickInteraction.bind(@, link.title)}
               children=link.title />
          </li>
        }
      </ul>

    </div>
