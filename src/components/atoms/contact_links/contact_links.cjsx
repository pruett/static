[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './contact_links.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-contact-links'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
  ]

  propTypes:
    links: React.PropTypes.arrayOf(
      React.PropTypes.shape(
        href: React.PropTypes.string
        img: React.PropTypes.string
        primary_text: React.PropTypes.string
        secondary_text: React.PropTypes.string
      )
    )

  getDefaultProps: ->
    links: []

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-grid__row
      u-mb48 u-mb84--600"
    col:
      "#{@BLOCK_CLASS}__col
      u-grid__col u-w12c u-w4c--600
      u-mb12 u-mb0--600"
    link:
      "#{@BLOCK_CLASS}__link
      u-db
      u-p18 u-p0--600
      u-tal u-tac--600
      u-bss u-bc--light-gray-alt-1 u-bw1 u-bw0--600"
    img:
      'u-dib u-db--600
      u-mr18 u-ma--600 u-mb6--600
      u-vam'
    text:
      'u-reset
      u-dib u-db--600 u-vam
      u-ffss u-fs14
      u-color--dark-gray-alt-3'
    textPrimary:
      "#{@BLOCK_CLASS}__primary
      u-fws u-ffss
      u-fs16 u-fs18--900
      u-color--blue-shadow"
    textSecondary:
      'u-db u-tdn'

  getHref: (link) ->
    if @modifier('isMobileAppRequest')
      link.mobile_app_href or link.href
    else
      link.href

  handleClickLink: (linkText, evt) ->
    @trackInteraction "contactLink-click-#{linkText}"

  renderLink: (classes, link, i) ->
    <div className=classes.col>
      <a className=classes.link
        href=@getHref(link)
        onClick={@handleClickLink.bind(@, link.primary_text)}>
        <img className=classes.img src=link.image width='50' height='50' />
        <p className=classes.text>
          <span children=link.primary_text className=classes.textPrimary />
          <span children=link.secondary_text className=classes.textSecondary />
        </p>
      </a>
    </div>

  render: ->
    classes = @getClasses()

    <div className=classes.block
      children={@props.links.map @renderLink.bind @, classes} />
