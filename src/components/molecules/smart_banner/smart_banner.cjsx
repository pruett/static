[
  _
  React

  IconX

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/thin_x/thin_x'

  require 'components/mixins/mixins'

  require './smart_banner.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-smart-banner'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
  ]

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string
    cssBackgroundColor: React.PropTypes.string
    cta_text: React.PropTypes.string
    cta_url: React.PropTypes.string
    banner_title: React.PropTypes.string
    banner_description: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: ''
    cssModifier: ''
    cssBackgroundColor: 'dark-gray'
    enabled: false
    icon_image: '//i.warbycdn.com/v/c/assets/smart-banner/image/icon/0/9bd7ddf9b9.png'
    whitelist: ['/']
    cta_text: 'View'
    cta_url: 'https://app.appsflyer.com/id1107693363?pid=warbyParker&c=smartBannerQuirky'
    banner_title: 'Warby Parker for iOS'
    banner_description: '(It’s app-tastically app-rageous)'
    rating: 90

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      #{@props.cssUtility}
      u-color-bg--#{@props.cssBackgroundColor} u-tac u-w100 u-pr"
    iconWrapper: "
      #{@BLOCK_CLASS}__icon-wrapper
      u-fl u-w100p
      "
    iconImage: "
      #{@BLOCK_CLASS}__icon-image
      u-mt24 u-fl"
    details: "
      #{@BLOCK_CLASS}__details
      u-fl u-tal
      u-fs12
      "
    title: "
      #{@BLOCK_CLASS}__title
      u-fs16"
    reviews: "
      #{@BLOCK_CLASS}__reviews
      u-dib u-mt4 u-oh u-pr"
    stars: "
      #{@BLOCK_CLASS}__stars
      u-bgs--c u-h100p u-l0 u-t0 u-w100p u-pa"
    rating: "
      #{@BLOCK_CLASS}__stars--rating
      u-bgs--c u-h100p u-l0 u-t0 u-w100p u-pa"
    wrapper: "#{@BLOCK_CLASS}__wrapper"
    viewButton: "
      #{@BLOCK_CLASS}__view-button
      u-color--white u-fs14
      u-bw1 u-bss u-bc--light-gray u-br2
      u-fr u-mr10 u-p5 u-pl10 u-pr10"
    iconX: '
      u-ml0 u-mr0 u-mt5 u-mb5 u-stroke--dark-gray-alt-2
    '
    xButton: "
      #{@BLOCK_CLASS}__x-button
      u-pl0 u-pr0"
    xButtonWrapper: "
      #{@BLOCK_CLASS}__x-button-wrapper
      u-fl u-pl0 u-pr0"


  trackViewClick: ->
    @trackInteraction "smartBanner#{if not @props.homepage_variant then 'Expansion' else ''}-click-view"

  trackXClick: ->
    @trackInteraction "smartBanner#{if not @props.homepage_variant then 'Expansion' else ''}-click-x"
    @commandDispatcher 'navigation', 'closeSmartBanner'

  render: ->
    return false if not @props.enabled or @modifier('isMobileAppRequest')

    classes = @getClasses()

    <div className=classes.wrapper>
      <div className=classes.block role='banner'>
        <div className=classes.xButtonWrapper>
          <button className=classes.xButton onClick=@trackXClick>
            <IconX cssModifier=classes.iconX />
          </button>
        </div>
        <div className=classes.iconWrapper>
          <img className=classes.iconImage src={@props.icon_image} />
        </div>
        <div className=classes.details>
          <div className=classes.title children=@props.banner_title />
          <div className=classes.description>{@props.banner_description}</div>
          <div className=classes.reviews>
            <div className=classes.stars />
            <div className=classes.rating style={width: "#{@props.rating}%"} />
          </div>
        </div>
        <a className=classes.viewButton
          onClick=@trackViewClick
          href={@props.cta_url}>{@props.cta_text}
        </a>
      </div>
    </div>
