[
  _
  React

  Cta
  Img
  Markdown

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/img/img'
  require 'components/molecules/markdown/markdown'


  require 'components/mixins/mixins'

  require './promo.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-landing-curated-promo'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
    Mixins.image
    Mixins.context
  ]

  getDefaultProps: ->
    is_hto: false

  getStaticClasses: ->
    block: '
      u-grid -maxed
      u-pr
      u-mla u-mra
    '
    image: '
      u-db
      u-w100p
    '
    imageWrapper: '
      u-grid__col u-w12c -c-7--900 -col-middle
      u-mb24
    '
    contentWrapper: '
      u-grid__row
      u-tac
      u-mt60--600 u-mt84--900
      u-mb60--600 u-mb84--900
    '
    copyWrapper: '
      u-grid__col -c-12 -c-8--600 -c-4--900 -col-middle
    '
    eyebrow: '
      u-ls2
      u-fs12 u-fwb
      u-mb12
    '
    header: '
      u-heading-md
      u-mb12
    '
    description: '
      u-ffss u-fs16 u-fs18--900
      u-color--dark-gray-alt-3
    '
    markdown: 'u-reset'
    cta: "
      #{@BLOCK_CLASS}__cta
      u-mb12
      u-mr12
    "
    hr: '
      u-bc--light-gray u-bw0 u-bbw1 u-bss
      u-mb48 u-mb60--600 u-mb84--900
    '

  classesWillUpdate: ->
    hr:
      'u-dn--900': @props.followsBleed
    header:
      'u-mb30': not @props.description
    description:
      'u-mb30': @props.cta_links
    eyebrow:
      'u-mb24': not @props.image
    copyWrapper:
      '-c-10--600 -c-8--900 -col-middle': @props.cta_links.length is 2
      'u-tal--900': _.isEmpty @props.cta_links
    contentWrapper:
      'u-mb48': not _.isEmpty @props.cta_links
      'u-tal--900': @props.image

  getImgProps: ->
    url: _.get @props, 'image'
    widths: [200, 300, 400, 500, 600, 700, 800, 900, 1000]

  imgSizes: [
    breakpoint: 0,
    width: '100vw'
  ,
    breakpoint: 640
    width: '75vw'
  ,
    breakpoint: 900
    width: '60vw'
  ]

  renderEyebrow: ->
    if @props.eyebrow
      <Markdown
        rawMarkdown=@props.eyebrow
        className=@classes.eyebrow
        cssBlock=@classes.markdown />

  renderHeader: ->
    if @props.header
      <Markdown
        rawMarkdown=@props.header
        className=@classes.header
        cssBlock=@classes.markdown />

  renderDescription: ->
    if @props.description
      <Markdown
        rawMarkdown=@props.description
        className=@classes.description
        cssBlock=@classes.markdown />

  getAnalyticsSlug: (cta) ->
    # replace spaces with _
    header = @props.header?.replace(/[- ]/g, "_")
    linkText = cta.value.replace(/[- ]/g, "_")
    slug = "PromoBlock-Click-#{header}__#{linkText}"

  renderCta: (cta, i) ->
    <Cta
      tagName='a'
      href=cta.link
      children=cta.value
      analyticsSlug={@getAnalyticsSlug(cta)}
      cssModifier=@classes.cta
      cssUtility=''
      key=i
    />

  renderImage: ->
    if @props.image
      imgSrcSet = @getSrcSet @getImgProps()
      <div className=@classes.imageWrapper>
        <Img srcSet=imgSrcSet
          cssModifier=@classes.image
          sizes={@getImgSizes @imgSizes}
        />
      </div>

  render: ->
    return false if not @getFeature('homeTryOn') and @props.is_hto
    @classes = @getClasses()

    <section className=@classes.block>
      {
        if @props.topBorder
          <hr className=@classes.hr />
      }
      <div className=@classes.contentWrapper>
        { @renderImage() }
        <div className=@classes.copyWrapper>
          { @renderEyebrow() }
          { @renderHeader() }
          { @renderDescription() }
          { @props.cta_links.map @renderCta }
        </div>
      </div>
    </section>
