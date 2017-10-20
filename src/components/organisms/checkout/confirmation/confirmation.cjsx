[
  _
  React

  ContactLinks
  AppPromo
  Img
  Markdown

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/contact_links/contact_links'
  require 'components/molecules/app_promo/app_promo'
  require 'components/atoms/images/img/img'
  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'

  require './confirmation.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-checkout-confirmation'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.image
  ]

  propTypes:
    completedOrderIds: React.PropTypes.array
    contactLinks: React.PropTypes.array
    fallbackOrderLeadTimeCategory: React.PropTypes.oneOfType [
      React.PropTypes.string
      React.PropTypes.number
    ]
    help: React.PropTypes.object
    intro: React.PropTypes.object
    order: React.PropTypes.object
    showRxUpload: React.PropTypes.bool
    upload: React.PropTypes.object
    estimate: React.PropTypes.object
    isApplePay: React.PropTypes.bool

  getDefaultProps: ->
    completedOrderIds: []
    contactLinks: []
    fallbackOrderLeadTimeCategory: '14'
    help: {}
    intro: {}
    order: {}
    showRxUpload: false
    upload: {}
    estimate: {}
    isApplePay: false

  getStaticClasses: ->
    block: '
      u-mt48 u-mt96--600 u-mb48
      u-ffss u-fs16'

    grid: '
      u-grid -maxed u-m0a'
    row: '
      u-grid__row
      u-tac'
    col: '
      u-grid__col u-pr
      u-w12c u-w10c--600 u-w6c--900
      u-mla u-mra
      u-l0
      u-tac'
    hr: '
      u-mb24 u-mt30
      u-bc--light-gray u-bw0 u-bbw3
      u-mb24'
    content: '
      u-ffss u-fs16'
    heading: '
      u-reset
      u-fs18 u-fs20--600
      u-mb12
      u-ffss u-fws'

    intro: '
      u-mb18'
    introHeading: '
      u-reset
      u-fs30 u-fs40--600
      u-ffs u-fws'
    introSubheading: "
      #{@BLOCK_CLASS}__intro-subhead
      u-reset
      u-fs18 u-fs20--600
      u-ffss u-fws
      u-mb18 u-mt10 u-mla u-mra
    "
    introHr: '
      u-bw0 u-bbw2 u-bss u-bc--blue'

    upload: '
      u-bw0 u-bbw1 u-bss u-bc--light-gray-alt-1'
    uploadBody: '
      u-reset
      u-fs16 u-fs18--600
      u-ffss
      u-mb24'
    uploadCta: "
      #{@BLOCK_CLASS}__cta
      u-button -button-blue
      u-center--vertical
      u-fs16 u-ffss u-fws
      u-pr36 u-pr36
      u-h60
      u-mb18
      u-mw100p"
    uploadEmail: '
      u-fs16 u-ffss
      u-mt18 u-mb48 u-mb60--600'
    uploadEmailLink: '
      u-db u-di--600 u-ml6'

    order: '
      u-pb48'
    orderBody: '
      u-fs16 u-ffss
      u-mt0 u-mb24'
    fallbackShipTimeLink: "
      u-color--blue
      u-bbss u-bbw1 u-bc--blue u-bc--white--600 u-pb3
      u-fs16 u-ffss u-fws
      u-mt0 u-mb48 u-mb60--600"

    callDoc: "
      #{@BLOCK_CLASS}__call-doc
      u-pr
      u-pt60 u-pb60
      u-mb48"
    callDocImg: '
      u-m0a u-mb24
      u-db'
    callDocBody: '
      u-reset
      u-fs16 u-ffss'
    callDocGrid: '
      u-grid -maxed u-m0a
      u-color-bg--light-gray-alt-2'

    helpArea: '
      u-pt48 u-pl18 u-pr18
      u-btss u-btw1 u-bc--light-gray-alt-1'
    helpWrap: '
      u-tac'
    helpHeading: '
      u-ffs u-fs24 u-fs26--600 u-fws u-mb12'
    helpBody: '
      u-color--dark-gray-alt-1
      u-ffss u-fs16 u-fs18--900 u-mb48'

  classesWillUpdate: ->
    orderContainsHto = _.get @props, 'estimate.has_hto', false

    order:
      'u-pt48': @props.showRxUpload
      'u-pt12': not @props.showRxUpload

    helpArea:
      'u-w12c u-w10c--600 u-w8c--900 u-w6c--1200
      u-mla u-mra': not orderContainsHto
    helpWrap:
      'u-w12c u-w10c--600 u-w8c--900 u-w6c--1200
      u-mla u-mra': orderContainsHto

  getOrderMessage: ->
    size = _.size(@props.completedOrderIds)
    if size is 1      then 'Your order number is '
    else if size > 1  then 'Your order numbers are '
    else ''

  getSendLaterCtaHref: ->
    if _.size(@props.completedOrderIds) is 1
      "/account/orders/#{@props.completedOrderIds[0]}"
    else
      '/account/orders/'

  getSendLaterEmailSubject: ->
    "subject=Order ##{@props.completedOrderIds.join ','}"

  handleClickLink: (slug) ->
    _.bind @trackInteraction, @, "checkoutConfirmation-clickLink-#{slug}"

  handleClickMarkdownLink: (evt) ->
    return unless _.get(evt, 'target.parentNode.tagName') is 'A'

    href = _.camelCase evt.target.parentNode.href
    @trackInteraction "checkoutConfirmation-clickLink-#{href}"

  renderOrderLink: (orderId, index, ids) ->
    <strong key=index>
      <a children=orderId
        href="/account/orders/#{orderId}"
        onClick=@handleClickLink('order') />
      {if index isnt ids.length - 1
        <span children=', ' />}
    </strong>

  renderOrder: (classes) ->
    return false if _.isEmpty @props.order

    leadTimeCategory = @props.orderLeadTimeCategory or @props.fallbackOrderLeadTimeCategory
    leadTimeMessage = _.get @props.order,
      "order_lead_time_copy_by_order_type.#{leadTimeCategory}"

    <section className=classes.order key='order'>
      {if @props.showRxUpload
        <h2 className=classes.heading children=@props.order.heading />}
      <p className=classes.orderBody>
        {@getOrderMessage()}
        {_.map @props.completedOrderIds, @renderOrderLink}{leadTimeMessage or '.'}
      </p>

      {if @props.order.secondary_information
        <Markdown rawMarkdown=@props.order.secondary_information />}

      {if leadTimeCategory is @props.fallbackOrderLeadTimeCategory and
      not _.isEmpty @props.order.fallback_ship_time_link
        <a href=@props.order.fallback_ship_time_link.url
          children=@props.order.fallback_ship_time_link.text
          className=classes.fallbackShipTimeLink
          onClick=@handleClickLink('orderShippingTime') />}
    </section>

  getIntroSubheading: ->
    if @props.isApplePay and _.get(@props, 'apple_pay_promo.show', false)
      _.get(@props, 'apple_pay_promo.subheading', @props.intro.subheading)
    else
      @props.intro.subheading

  renderIntro: (classes) ->
    return false if _.isEmpty @props.intro

    <section className=classes.intro key='intro'>
      <h1 className=classes.introHeading children=@props.intro.heading />
      <h2 className=classes.introSubheading children=@getIntroSubheading() />
      <hr className=classes.introHr width='60' />
    </section>

  renderUpload: (classes) ->
    return false if not @props.showRxUpload or _.isEmpty @props.upload
    <section className=classes.upload key='upload'>
      <p className=classes.uploadBody children=@props.upload.body />
      <a className=classes.uploadCta
        children=@props.upload.cta
        href=@getSendLaterCtaHref()
        onClick=@handleClickLink('introUpload') />

      {unless _.isEmpty @props.upload.email_prompt
        <p className=classes.uploadEmail>
          <span children=@props.upload.email_prompt />
          <a className=classes.uploadEmailLink
            children={_.get @props, 'upload.email_link.text'}
            href="#{_.get @props, 'upload.email_link.url'}?#{@getSendLaterEmailSubject()}"
            onClick=@handleClickLink('introEmail') />
        </p>}
    </section>

  renderCallDoc: (classes) ->
    return false if not @props.showRxUpload or _.isEmpty @props.call_doc
    <section className=classes.callDoc key='callDoc'>
      {unless _.isEmpty @props.call_doc.image
        <img
          width='100'
          className=classes.callDocImg
          src=@props.call_doc.image.url
          alt=@props.call_doc.image.alt_text />
      }
      <h3 className=classes.heading children=@props.call_doc.heading />
      <Markdown
        cssModifiers={p: classes.callDocBody}
        onClick=@handleClickMarkdownLink
        rawMarkdown={
          (@props.call_doc.body or '').replace(
            /mailto:([^\)]+)/i
            "mailto:$1?#{@getSendLaterEmailSubject()}"
          )
        } />
    </section>

  renderHelp: (classes) ->
    return false if _.isEmpty @props.help
    <div className=classes.helpArea key='help'>
      <div className=classes.helpWrap>
        <div className=classes.help>
          <h1 className=classes.helpHeading children=@props.help.heading />
          <Markdown className=classes.helpBody
            cssModifiers={p: 'u-fs16 u-fs18--900'}
            rawMarkdown=@props.help.body />

          <ContactLinks links=@props.help.contact_links />
        </div>
      </div>
    </div>

  render: ->
    classes = @getClasses()

    <section className=classes.block>
      <div className=classes.grid>
        <div className=classes.row>
          <div className=classes.col>
            {[
              @renderIntro(classes)
              @renderUpload(classes)
              @renderOrder(classes)
              @renderCallDoc(classes)
            ]}
          </div>
        </div>
      </div>
      {if _.get(@props, 'estimate.has_hto', false) and _.get(@props.app_promo, 'layout_variation') isnt 'no-promo'
        <AppPromo {...@props.app_promo} />
      }
      {@renderHelp classes}
    </section>
