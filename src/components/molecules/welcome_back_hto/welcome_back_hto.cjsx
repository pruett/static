[
  _
  React

  Takeover
  BuyableFrame
  CTA
  Img
  IconX

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/modals/takeover/takeover'
  require 'components/molecules/products/buyable_frame/buyable_frame'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/img/img'
  require 'components/quanta/icons/x/x'

  require 'components/mixins/mixins'

  require './welcome_back_hto.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-welcome-back-hto'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  getDefaultProps: ->
    active: false
    items: []
    name: ''
    version: 1

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
    "
    content: '
      u-grid -maxed
      u-mla u-mra
    '
    contentWrapper: '
      u-grid__row
      u-pl12--900 u-pr12--900 u-p0--1200
    '
    closeButton: "
      #{@BLOCK_CLASS}__close-button
      u-pa--900 u-t0 u-r0
      u-mt18 u-mr6 u-mr18--900
      u-fr
      u-button-reset
    "
    closeIcon: 'u-icon u-fill--dark-gray-alt-2'
    buyableFrame: "
      #{@BLOCK_CLASS}__buyable-frame
      u-grid__col u-w12c
    "
    text: '
      u-tac
      u-pt24 u-pt48--600
      u-pb24 u-pb48--600
    '
    greeting: "
      #{@BLOCK_CLASS}__greeting
      u-ffss u-fs12 u-ttu
      u-mt0 u-mb8
      u-color--dark-gray-alt-1
    "
    headline: "
      u-ffs u-fws
      u-fs24 u-fs30--600
      u-mt24 u-mb12
    "
    subhead: "
      u-ffss
      u-fs16 u-fs18--900
      u-mt0 u-mb0
      u-pr30 u-pl30 u-p0--600
      u-color--dark-gray-alt-1
    "
    cta: "
      #{@BLOCK_CLASS}__cta
    "
    linkWrapper: 'u-dn'
    bottomLinkWrapper: '
      u-mtn24 u-mtn48--900
      u-mb48
    '
    link: '
      u-button-reset
      u-link--underline
      u-fs16
    '
    frames: 'u-tac'
    insuranceWrapper: '
      u-tac u-mla u-mra
      u-w10c u-fs16
      u-btss u-btw1 u-bc--light-gray
      u-lh24 u-pt24 u-pt36--900 u-mb48
    '
    insuranceHighlight: 'u-fws'
    insuranceLink: 'u-fws u-fs16'

  classesWillUpdate: ->
    isV1 = @props.version is 1
    isV2 = @props.version is 2

    buyableFrame:
      '-c-6--900 -c-4--1200': isV1
      '-c-12--900': isV2
    headline:
      'u-fs40--900': isV1
      'u-fs50--900': isV2
    gutter:
      'u-grid__col u-w12c -c-5--900 -c-4--1200': isV2
    framesWrapper:
      'u-pl30--900 u-pr30--900': isV1
      'u-grid__row': isV2
    frames:
      "#{@BLOCK_CLASS}__frames
       u-grid__col u-w12c -c-7--900 -c-8--1200": isV2
    text:
      "#{@BLOCK_CLASS}__text
      u-grid__col u-w12c u-tal--900 u-pa--900 u-center-y--900 ": isV2
    linkWrapper:
      'u-db--900 u-mt24': isV2
    bottomLinkWrapper:
      'u-dn--900': isV2

  handleClose: (target, event) ->
    @commandDispatcher 'layout', 'hideTakeover'
    @props.handleClose()
    @trackInteraction "welcomeBackHto-close-#{target}", event

  handleLinkClick: (target) ->
    @trackInteraction "welcomeBackHto-clickLink-#{target}"

  render: ->
    @classes = @getClasses()

    imageSizes =
      1: [
        breakpoint: 0, width: '100vw'
      ,
        breakpoint: 450, width: '426px'
      ,
        breakpoint: 1200, width: '368px'
      ]
      2: [
        breakpoint: 0, width: '100vw'
      ,
        breakpoint: 450, width: '426px'
      ,
        breakpoint: 900, width: '50vw'
      ,
        breakpoint: 1200, width: '60vw'
      ,
        breakpoint: 1440, width: '808px'
      ]

    <Takeover
      active=@props.active
      hasHeader=false
      pageHeader=true>
      <div className=@classes.content>
        <div className=@classes.contentWrapper>
          <button className=@classes.closeButton onClick={@handleClose.bind @, 'X'}>
            <IconX cssUtility=@classes.closeIcon />
          </button>
          <div className=@classes.text>
            <p className=@classes.greeting children="Hi #{@props.name}" />
            <h1 className=@classes.headline children='Try anything you liked?' />
            <p className=@classes.subhead children='Make your favorite Home Try-On pair yours for keeps.' />
            <div className=@classes.linkWrapper>
              <button className=@classes.link
                onClick={@handleClose.bind @, 'keepShopping'}
                children='Keep shopping' />
            </div>
          </div>
          <div className=@classes.framesWrapper>
            <div className=@classes.gutter />
            <div className=@classes.frames>
              {_.map @props.items, (product, i) =>
                <BuyableFrame
                  addedVia='hto-welcome-back'
                  analyticsCategory='welcomeBackHto'
                  isInline=false
                  canHto=false
                  canFavorite=false
                  cssModifier=@classes.buyableFrame
                  imageSizes={_.get imageSizes, @props.version}
                  key=i
                  product=product
                  size={if @props.version is 2 then 'large' else 'small'} />}
              <div className=@classes.bottomLinkWrapper>
                <button className=@classes.link
                  onClick={@handleClose.bind @, 'keepShopping'}
                  children='Keep shopping' />
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className=@classes.insuranceWrapper>
        <span children='Save on prescription frames! ' className=@classes.insuranceHighlight />
        <span children='You can pay with' />
        <a
          href='/flexible-spending-accounts'
          children=' FSA or HSA'
          className=@classes.insuranceLink
          target="_blank"
          onClick={@handleLinkClick.bind(@, 'FSA')}
          />
        <span children=', or apply for ' />
        <a
          href='/insurance'
          children='insurance reimbursement.'
          className=@classes.insuranceLink
          target="_blank"
          onClick={@handleLinkClick.bind(@, 'Insurance')}
          />
      </div>
    </Takeover>
