[
  _
  React

  PromoBlockHeadingBody
  PromoBlockSilo
  PromoBlockImageTextCta
  PromoBlockShortText

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/promo_blocks/heading_body/heading_body'
  require 'components/atoms/promo_blocks/silo/silo'
  require 'components/atoms/promo_blocks/image_text_cta/image_text_cta'
  require 'components/atoms/promo_blocks/short_text/short_text'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-promo-block'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
  ]

  getDefaultProps: ->
    alt_text: ''
    id: ''
    image: ''
    index: 1
    label: ''
    link_text: null
    template: ''
    title: ''
    url_slug: ''

  getStaticClasses: ->
    block: 'u-mt0 u-mra u-mla
      u-mb78 u-mb66--600 u-mb90--900 u-mb78--1200
      u-tac
      u-grid__col u-w12c'

  classesWillUpdate: ->
    block:
      'u-dn': not @props.index

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      {if @props.template is 'heading_body'
        <PromoBlockHeadingBody {...@props} />
      else if @props.template in [
        'image_text_cta', 'image_text_cta_text_left', 'image_text_cta_text_right'
      ]
        <PromoBlockImageTextCta {...@props}
          textPosition={if @props.template is 'image_text_cta_text_left' then 'left' else 'right'}
        />
      else if @props.template is 'short_text'
        <PromoBlockShortText {...@props} />
      else
        <PromoBlockSilo {...@props}
          textPosition={if @props.template is 'silo_text_left' then 'left' else 'right'}
        />
      }
    </div>
