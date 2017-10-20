[
  _
  React

  CTA
  TermsAndConditions

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/terms_and_conditions/terms_and_conditions'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-checkout-summary'

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.conversion
  ]

  getDefaultProps: ->
    analyticsSlug: ''
    ctaCopy: 'Place order'
    disabled: false
    is_hto_only: false
    isFinal: false
    itemCount: 0
    minimal: false
    rows: ['subtotal', 'tax', 'discount', 'gift_card', 'shipping']
    totals: {}

  getStaticClasses: ->
    table: '
      u-w100p
    '
    tableBody: 'u-pb24'
    label: '
      u-ffss u-fs12 u-fws u-ls3 u-ttu
      u-color--dark-gray-alt-2
      u-pb8
    '
    value: '
      u-ffss
      u-color--dark-gray-alt-3
      u-tar
      u-pb8
    '
    total: '
      u-btss u-bw1 u-bc--light-gray
      u-pt12
      u-fs18 u-fws
    '
    message: '
      u-ffs u-fs16 u-fsi
      u-tac u-mt0 u-mb0
      u-color--dark-gray-alt-2
    '
    cta: '
      u-button -button-blue -button-large -button-full -v2
      u-fws u-fs16
    '
    ctaPrice: '
      u-dn--900
    '
    terms: '
      u-w9c--600
      u-mb8
      u-fs12
    '

  classesWillUpdate: ->
    block:
      'u-pt30 u-pr36 u-pl36
       u-mrn36 u-mln36
       u-color-bg--light-gray-alt-2': not @props.minimal
      'u-mb24 u-mb0--900
       u-bbss u-bc--light-gray
       u-bw1 u-bw0--900': @props.minimal
      'u-pb24': @props.ctaCopy
      'u-pb36': not @props.ctaCopy
    table:
      'u-dn u-dt--900': @props.minimal
    value:
      'u-fs16': not @props.minimal
      'u-fs18': @props.minimal
    cta:
      '-disabled': @props.disabled
      'u-mt30--900': @props.minimal
      'u-mt30': not @props.minimal
    message:
      'u-dn u-db--900': @props.minimal
    terms:
      'u-mt24': not @props.minimal
      'u-mt12 u-mt24--900': @props.minimal

  getTotalPrice: ->
    amountCents = if _.isFinite @props.totals.balance_cents
      @props.totals.balance_cents
    else
      @props.totals.total_cents

    "$#{@convert 'cents', 'dollars', amountCents}"

  getTableRow: (name, i) ->
    amountCents = @props.totals["#{name}_cents"]
    return null if not amountCents and name in ['tax', 'discount', 'gift_card']

    label = if name is 'subtotal' and @props.is_hto_only
      'Free trial'
    else if name is 'subtotal' and @props.itemCount > 1
      "Subtotal (#{@props.itemCount} items)"
    else
      name.replace '_', ' '

    displayPrice = "$#{@convert 'cents', 'dollars', amountCents}"

    value = if name in ['discount', 'gift_card']
      "- #{displayPrice}"
    else if name is 'shipping' and amountCents is 0
      'Free'
    else
      displayPrice

    <tr key=i>
      <td children=label className=@classes.label />
      <td children=value className=@classes.value />
    </tr>

  getTableTotal: ->
    <tr className=@classes.total>
      <td children='Total' className='u-pt12' />
      <td children=@getTotalPrice() className='u-tar u-pt12' />
    </tr>

  render: ->
    @classes = @getClasses()

    <div className=@classes.block>
      <table className=@classes.table>
        <tbody
          className=@classes.tableBody
          children={_.compact _.map(@props.rows, @getTableRow)} />
        <tfoot children={@getTableTotal()} />
      </table>

      {if @props.ctaCopy
        <CTA
          analyticsSlug="#{@props.analyticsSlug}#{if @props.disabled then '-disabled' else ''}"
          variation='minimal'
          cssModifier=@classes.cta
          cssUtility=''
          children=@props.ctaCopy
          onClick=@props.onClick>
          {@props.ctaCopy}
          {if @props.minimal and @props.isFinal
            <span className=@classes.ctaPrice children=" – #{@getTotalPrice()}" />}
        </CTA>}

      {if @props.isFinal and @props.totals.shipping_cents is 0 and
      @getFeature('freeShipping') and @getFeature('freeReturns')
        <p className=@classes.message children='Free shipping and free returns' />}

      {if @props.isFinal and not @props.is_hto_only
        <TermsAndConditions
          variation='checkout'
          cssModifier=@classes.terms />}
    </div>
