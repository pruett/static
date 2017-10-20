[
  _
  React
  Mixins
  BreadcrumbListSchema
] = [
  require 'lodash'
  require 'react/addons'
  require 'components/mixins/mixins'
  require 'components/atoms/structured_data/breadcrumb_list/breadcrumb_list'
  require './breadcrumbs.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-breadcrumbs'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    centered: React.PropTypes.bool
    cssModifier: React.PropTypes.string
    links: React.PropTypes.arrayOf(
      React.PropTypes.shape
        href: React.PropTypes.string
        text: React.PropTypes.string
    )

  getDefaultProps: ->
    links: []
    cssModifier: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-mw1440
      u-w100p
      u-center-x
      u-pr12 u-pr18--900
      u-pl12 u-pl18--900
      u-pr
    "
    list: "
      #{@BLOCK_CLASS}__list
      #{@props.cssModifier}
      u-reset--list
    "
    listItem: "
      #{@BLOCK_CLASS}__list-item
      u-dib
      u-text u-ttu
    "
    link: "
      #{@BLOCK_CLASS}__link
      u-reset u-fs12
      u-link--nav
      u-color--dark-gray
    "
    current: "
      #{@BLOCK_CLASS}__current
      u-reset  u-fs12 u-ls2_5 u-ttu
      u-color--dark-gray-alt-2
    "
    currentIndicator: '
      u-hide--visual
    '
    loading: '
      u-color--light-gray
      u-fs12
      u-ttu
      u-ls2_5
    '

  classesWillUpdate: ->
    list:
      'u-tac': @props.centered

  renderLink: (link, i) ->
    classes = @getClasses()

    <li key=i
      className=classes.listItem
      onClick={@trackInteraction.bind @, "breadcrumbs-click-#{_.camelCase link.text}"}>
      {if link.href
        <a href=link.href
          children=link.text
          className=classes.link />
      else
        <span className=classes.current>
          <span className=classes.currentIndicator
            children='Current:' />
          {link.text}
        </span>}
    </li>

  render: ->
    classes = @getClasses()

    <nav className=classes.block
      role='navigation'
      aria-label='Breadcrumbs'>

      {if _.get @props, 'links[0].text'
        <ul
          children={_.map @props.links, @renderLink}
          className=classes.list />}
        <BreadcrumbListSchema links={@props.links} />
    </nav>
