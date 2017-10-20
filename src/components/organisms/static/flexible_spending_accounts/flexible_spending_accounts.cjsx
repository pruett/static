[
  _
  React

  Cta
  ResponsiveImage
  Markdown
  Reimbursements

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/responsive_picture_v2/responsive_picture_v2'
  require 'components/molecules/markdown/markdown'
  require 'components/molecules/landing/insurance/reimbursements/reimbursements'

  require 'components/mixins/mixins'

  require './flexible_spending_accounts.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-flexible-spending-accounts'

  # Link to anchor tag on the insurance page
  INSURANCE_STEPS_LINK: '/insurance#steps'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    content: React.PropTypes.object
    imageSizes: React.PropTypes.oneOfType [React.PropTypes.array, React.PropTypes.object]
    middleCalloutImagePosition: React.PropTypes.number

  getDefaultProps: ->
    imageSizes:
      top_image:
        default: [
          break: 320
          image: 210
        ,
          break: 640
          image: 274
        ]
      middle_callout_image:
        default: [
          break: 320
          image: 304
        ,
          break: 640
          image: 459
        ,
          break: 768
          image: 385
        ]
      cross_sell_image:
        default: [
          break: 320
          image: 320
        ,
          break: 640
          image: 320
        ,
          break: 768
          image: 320
        ]
    middleCalloutImagePosition: 3

  getStaticClasses: ->
    block: @BLOCK_CLASS
    topImageCaption:
      'u-mt48
      u-fs12 u-ttu u-ls2_5 u-ffss u-fws'
    introSection:
      'u-w9c--600 u-w6c--900
      u-mla u-mra
      u-pl24 u-pr24 u-pl0--900 u-pr0--900
      u-pt48--900
      u-tac'
    qaSection:
      'u-w6c--900
      u-mt48 u-mb0 u-mla u-mra
      u-pl24 u-pr24
      u-tal'
    crossSellsSection:
      'u-mt96 u-mb60
      u-tac'
    headline:
      'u-mt24 u-mb36
      u-tac
      u-fs40 u-ffs u-fws'
    description:
      'u-mb36
      u-fs16 u-fs18--600 u-ffss'
    ctaButtons:
      'u-mb60
      u-tac'
    ctaButtonWrap:
      'u-w8c u-wauto--600
      u-dib--600
      u-mt4 u-mla u-mra u-ml8--600 u-mr8--600'
    ctaButton:
      'u-button -button-blue -button-medium -button-full
      u-fs16 u-ffss u-fws'
    ctaTextButtonWrap:
      'u-db u-mt30 u-mt36--600'
    ctaTextButton:
      "#{@BLOCK_CLASS}__cta-text-button
      u-pr
      u-pb5 u-pb7--900
      u-bbw2 u-bbss
      u-bc--blue u-bc--white-0p--900
      u-fs16 u-ffss u-fws"
    subhead:
      'u-mt48 u-mb48
      u-tac
      u-fs30 u-ffs u-fws'
    subheadRuled:
      'u-mt48 u-mb48
      u-tac
      u-fs30 u-ffs u-fws'
    subheadRuledInner: "
      #{@BLOCK_CLASS}__subhead-ruled-inner
      u-dib
      u-pr
      u-pl12 u-pr12
      u-color-bg--white"
    hr:
      'u-hr'
    qaPair: "
      #{@BLOCK_CLASS}__qa-pair"
    question: "
      #{@BLOCK_CLASS}__question
      u-reset u-fs20 u-ffs u-fws"
    answer:
      'u-mt12'
    copyImage:
      'u-w8c--600
      u-mt36 u-mla u-mra
      u-tac'
    crossSells:
      'u-w6c--900
      u-mla u-mra'
    crossSell: "
      #{@BLOCK_CLASS}__cross-sell
      u-db u-dib--600
      u-mla u-mra
      u-tac
      u-color--dark-gray
      u-reset u-fs12
      u-link--nav"
    crossSellImage: "
      #{@BLOCK_CLASS}__cross-sell-image"
    crossSellCaption:
      'u-mb12'
    reimbursement: '
      u-fs16 u-fws u-color--dark-gray u-reset
    '
    reimbursementLink: '
      u-fws u-fs16
    '
    reimbursementWrapper: '
      u-tac u-w12c u-w9c--900 u-mla u-mra u-mb36 u-mb96--900
    '

  classesWillUpdate: ->
    useWideLayout = @useWideLayout()

    topImageWrap:
      'u-w6c--900
      u-mt36 u-mla u-mra
      u-tac
      u-pl24--600 u-pr24--600 u-pl0--900 u-pr0--900': not useWideLayout
      'u-mln18 u-mrn18': useWideLayout
    topImage:
      'u-w8c u-w6c--600': not useWideLayout
      'u-pb4x3 u-pb2x1--600 u-pb3x1--900
      u-bgs--cv u-bgp--tc u-bgr--nr': useWideLayout

  useWideLayout: ->
    Boolean _.get(@props, 'content.wide_image_layout')

  getWideTopImageUrl: ->
    url = @props.content.top_image
    return '' if not url
    if url.indexOf('quality=') is -1
      if url.indexOf('?') is -1
        url += '?quality=95'
      else
        url += '&quality=95'

    return url

  renderTopImage: ->
    classes = @getClasses()

    <div className=classes.topImageWrap>
      {if @useWideLayout()
        <div className=classes.topImage
          style={backgroundImage: "url('#{@getWideTopImageUrl()}')"}
        />
      else
        <ResponsiveImage cssModifier=classes.topImage
          sizes=@props.imageSizes.top_image
          sourceImages={[
            image: @props.content.top_image
            size: 'default'
          ]} />
      }
    </div>

  renderFaqItems: ->
    content = @props.content
    classes = @getClasses()

    faqItems = _.map content.faq, (qa, i) ->
      <div className=classes.qaPair key=i>
        <div className=classes.question children=qa.question />
        <Markdown className=classes.answer rawMarkdown=qa.answer />
      </div>

    if content.middle_callout_image
      faqItems.splice @props.middleCalloutImagePosition,
        0,
        <div className=classes.copyImage key='middle-callout-image'>
          <ResponsiveImage sizes=@props.imageSizes.middle_callout_image
            sourceImages={[
              image: content.middle_callout_image
              size: 'default'
            ]} />
        </div>

    return faqItems

  handleInsuranceLinkClick: ->
    @trackInteraction 'fsaPage-clickLink-insurance'

  render: ->
    return false unless @props.content

    content = @props.content
    classes = @getClasses()

    <div className=classes.block>

      {@renderTopImage()}

      <div className=classes.introSection>
        <Markdown className=classes.subHeading
          cssBlock=classes.topImageCaption
          rawMarkdown=content.image_tagline />

        <h1 className=classes.headline children=content.headline_text />

        <Markdown className=classes.description
          cssBlock=classes.block
          rawMarkdown=content.intro_text />

        <div className=classes.reimbursementWrapper>
          <span className=classes.reimbursement children='No FSA or HSA? ' />
          <a href=@INSURANCE_STEPS_LINK
          children=' Head here'
          className=classes.reimbursementLink
          onClick=@handleInsuranceLinkClick />
          <span className=classes.reimbursement
            children=' to learn how to get reimbursed by your vision insurance company.' />
        </div>
      </div>

      <Reimbursements
        {...@props.content.reimbursements}
        nearbyExams=@props.nearbyExams
        showBottomBorder=true />

      <div className=classes.qaSection>
        <h2 className=classes.subhead children=content.faq_header />
        {@renderFaqItems()}
      </div>

      <div className=classes.crossSellsSection>
        <h2 className=classes.subheadRuled>
          <hr className="#{classes.hr} -no-margin" />
          <span className=classes.subheadRuledInner children=content.cross_sells_headline />
        </h2>
        <div className=classes.crossSells>
          {_.map content.cross_sells, (crossSell, i) =>
            <a className=classes.crossSell
              href=crossSell.link
              key=i
              onClick={@clickInteraction.bind @, crossSell.caption}>
              <div children=crossSell.caption className=classes.crossSellCaption />
              <ResponsiveImage cssModifier=classes.crossSellImage
                sizes=@props.imageSizes.cross_sell_image
                sourceImages={[
                  image: crossSell.image
                  size: 'default'
                ]} />
            </a>
          }
        </div>
      </div>

    </div>
