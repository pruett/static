_ = require 'lodash'
React = require 'react/addons'
DownArrow = require 'components/quanta/icons/down_arrow_thin/down_arrow_thin'
Img = require 'components/atoms/images/img/img'
Link = require 'components/atoms/link/link'
Markdown = require 'components/molecules/markdown/markdown'
Frame = require 'components/molecules/products/gallery_frame_radio/gallery_frame_radio'
Mixins = require 'components/mixins/mixins'

require './quiz_frames.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-quiz-frames'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
    Mixins.image
    Mixins.scrolling
  ]

  getDefaultProps: ->
    addedVia: 'hto-quiz'
    analyticsCategory: 'quizResults'
    cart: {}
    content: {}
    favorites: []
    frames: []
    gender: 'f'
    moreFramesCount: 6
    hideResults: false
    showFavorites: false
    showTooltip: false

  getInitialState: ->
    visibleFrameCount: 9
    moreFramesShown: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-mw1440
      u-mla u-mra
      u-tac
    "
    headerContainer: '
      u-ml18 u-mr18
      u-pt24 u-pt48--600 u-pb60 u-pb72--600
    '
    headerImage: "
      #{@BLOCK_CLASS}__header-image
    "
    header: "
      #{@BLOCK_CLASS}__promo-header
      u-ffs u-fws u-fs30 u-fs45--600
      u-mt12 u-mb18 u-mla u-mra
    "
    subhead: "
      #{@BLOCK_CLASS}__subhead
      u-db
      u-ffss u-fs16 u-fs18--600 u-m0a
      u-color--dark-gray-alt-3
    "
    framesGrid: '
      u-grid
    '
    frames: '
      u-grid__row
    '
    moreFramesCta: "
      #{@BLOCK_CLASS}__more-frames
      u-button-reset
      u-mtn12 u-mb48 u-mb72--600
      u-fs16 u-fws u-color--blue
    "
    plus: '
      u-sign -plus -w10 u-pr u-mr12
    '
    promoHeader: "
      #{@BLOCK_CLASS}__promo-header
      u-dib
      u-ffs u-fws u-fs24 u-fs36--600
      u-mt0 u-mb18
    "
    galleryPromo: '
      u-ml18 u-mr18
      u-pt36 u-pt72--600 u-pb36 u-pb72--600
      u-bss u-bw0 u-btw1 u-bc--light-gray-alt-1
    '
    ctaWrapper: '
      u-mt6 u-mt24--600 u-mb24
    '
    ctaLink: '
      u-button -button-white -button-medium
      u-fws
      u-fs16
    '
    link: '
      u-link--hover u-fws u-dib
      u-fs16
    '
    htoPromo: '
      u-pr
      u-p24 u-pt0 u-p0--600 u-pt24--600
    '
    htoSection: '
      u-df--600 u-ai--c u-jc--sb
      u-pt24 u-pb24 u-p0--600
      u-tal--600
    '
    htoSectionText: "
      u-pr u-dib
      u-w6c--600 u-w5c--1200
      u-tac u-tal--600
      u-pt24--600 u-pb24--600
      u-pl24--600 u-pr24--600 u-pl72--900 u-pr72--900
    "
    eyebrow: '
      u-ffss u-fs12 u-fws u-ls2_5 u-ttu
      u-mt0 u-mb8 u-mb12--600
    '
    htoSectionHeader: '
      u-ffs u-fs30 u-fs36--600 u-fws
      u-mt0 u-mb12 u-mb24--600
    '
    htoSectionDescription: '
      u-m0
      u-ffss u-fs16 u-fs18--600
      u-color--dark-gray-alt-3
    '
    htoSectionLink: "
      #{@BLOCK_CLASS}__link-button
      u-button-reset
      u-color--blue
      u-fws u-dib u-mt18
    "
    htoSectionImage: "
      u-dn u-dib--600 u-w6c u-as--c
    "
    htoSectionImageMobile: "
      u-dn--600 u-mb36
    "
    downArrow: "
      #{@BLOCK_CLASS}__down-arrow
      u-dib
      u-stroke--blue
      u-mt8 u-ml12
    "
    framesCtas: "
      u-mb24 u-mtn24--600 u-mtn48--900
    "
    priceCallout: "
      u-mb24
      u-color-bg--light-gray-alt-2
      u-pt84 u-pb84 u-pr48 u-pl48
      u-p120--600
    "
    priceCalloutHeader: "
      #{@BLOCK_CLASS}__price-callout-header
      u-mla u-mra u-mb0 u-mt24 u-mt36--600
      u-ffs u-fws
      u-fs30 u-fs40--600 u-fs50--900
    "

  classesWillUpdate: ->
    block:
      '-hidden': @props.hideResults

  componentDidMount: ->
    window?.scrollTo 0, 0

    @setupFrames(@props.frames) if @props.frames.length

  componentWillReceiveProps: (props) ->
    # If we didn't fire the product impressions on mount, do them now
    @setupFrames(props.frames) if @props.frames.length is 0 and props.frames.length

  setupFrames: (frames) ->
    if _.includes @getExperimentVariant('quizResultsFrameCount'), 'All'
      count = frames.length
    else
      count = @props.moreFramesCount + (frames.length % @props.moreFramesCount)

    @setState visibleFrameCount: count
    @fireProductImpressions frames.slice(0, count)

  getPromoSrcSet: (image) ->
    @getSrcSet(
      url: image
      widths: [700, 980, 1200, 1440]
    )

  getPromoSizes: ->
    @getImgSizes [
      breakpoint: 0
      width: '700px'
    ,
      breakpoint: 700
      width: '100vw'
    ,
      breakpoint: 1440
      width: '1440px'
    ]

  fireProductImpressions: (products) ->
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productImpression'
      products: products

  handleShowMoreFrames: ->
    frameCount = @state.visibleFrameCount + @props.moreFramesCount
    @trackInteraction "#{@props.analyticsCategory}-click-showMoreFrames#{if @state.moreFramesShown then 'Second' else ''}"
    @fireProductImpressions @props.frames.slice(@state.visibleFrameCount, frameCount)
    @setState
      visibleFrameCount: frameCount
      moreFramesShown: true

  handleClickHtoLink: (evt) ->
    @trackInteraction "#{@props.analyticsCategory}-click-aboutHto"
    node = @refs['htoSection']
    @scrollToNode node

  renderFrame: (frames, i) ->
    <Frame
      key={frames[0].product_id}
      addedVia=@props.addedVia
      analyticsCategory=@props.analyticsCategory
      atcAnalyticsCategory=@props.analyticsCategory
      cart=@props.cart
      favorites=@props.favorites
      firstFrame={i is 0 and @props.showTooltip}
      index={i + 1}
      products=frames
      showHtoQuickAdd=true
      showFavorites=true />

  renderHtoSection: (classes, section, i) ->
    <div className="#{classes.htoSection} #{if i%2 > 0 then 'u-flexd--rr' else '' }">
      <Img cssModifier=classes.htoSectionImage
        sizes='720px'
        srcSet={@getSrcSet
          url: section.image
          widths: [720, 1440]
          quality: 80
        } />
      <Img cssModifier=classes.htoSectionImageMobile
        sizes='327px'
        srcSet={@getSrcSet
          url: section.image_mobile
          widths: [327, 654]
          quality: 80
        } />
      <div key=i className=classes.htoSectionText>
        <div className=classes.eyebrow children=section.eyebrow />
        <h3 className=classes.htoSectionHeader children=section.header />
        <p className=classes.htoSectionDescription children=section.description />
      </div>
    </div>

  renderPriceCallout: ->
    classes = @getClasses()
    startingPrice = (parseInt(@getFeature('basePriceCents'), 10) / 100).toFixed()

    <div className=classes.priceCallout>
      <p className=classes.eyebrow children='Thought you’d like to know' />
      <Markdown
        tagName='h3'
        cssBlock={@BLOCK_CLASS}
        className=classes.priceCalloutHeader
        cssModifiers={p: 'u-m0'}
        rawMarkdown="Our eyeglasses start at
         $#{startingPrice}—that includes both frames
         *and* prescription lenses." />
    </div>

  render: ->
    classes = @getClasses()
    htoPromo = _.get @props, 'content.hto_promo', {}
    galleryPromo = _.get @props, 'content.gallery_promo', {}
    galleryUrl = "/eyeglasses/#{if @props.gender is 'm' then 'men' else 'women'}?availability=hto"
    frames = @props.frames.slice 0, @state.visibleFrameCount

    <div className=classes.block>
      <div className=classes.headerContainer>
        {if @props.content.image
          <img className=classes.headerImage src=@props.content.image />}
        <h1 className=classes.header children=@props.content.header />
        <p className=classes.subhead children=@props.content.subhead />
        <button
          className=classes.htoSectionLink
          onClick=@handleClickHtoLink>
          {'See how Home Try-On works'}
          <DownArrow cssUtility=classes.downArrow />
        </button>
      </div>

      {if _.size @props.frames
        <div>
          <div className=classes.framesGrid>
            <div className=classes.frames>
              { _.map frames, @renderFrame }
              {if @state.visibleFrameCount is @props.frames.length
                <div className=classes.framesCtas>
                  <div className=classes.ctaWrapper>
                    <Link
                      className=classes.ctaLink
                      href=galleryUrl
                      onClick={@trackInteraction.bind(@, "#{@props.analyticsCategory}-click-galleryLinkMore")}
                      children=galleryPromo.link_text />
                  </div>
                  <Link
                    className=classes.link
                    href='/quiz'
                    onClick={@trackInteraction.bind(@, "#{@props.analyticsCategory}-click-retakeQuizMore")}
                    children=galleryPromo.retake_text />
                </div>
              else
                <div>
                  <button
                    className=classes.moreFramesCta
                    onClick=@handleShowMoreFrames>
                    <span className=classes.plus />{@props.content.more_text}
                  </button>
                </div>
              }
            </div>
          </div>

          {if @inExperiment('quizResultsPriceCopy', 'enabled')
            @renderPriceCallout()
          }

          {if htoPromo.sections
            <div
              ref='htoSection'
              className=classes.htoPromo
              children={_.map htoPromo.sections, @renderHtoSection.bind @, classes} />}

          <div className=classes.galleryPromo>
            <h3 className=classes.promoHeader children=galleryPromo.header />
            <div className=classes.ctaWrapper>
              <Link
                className=classes.ctaLink
                href=galleryUrl
                onClick={@trackInteraction.bind(@, "#{@props.analyticsCategory}-click-galleryLink")}
                children=galleryPromo.link_text />
            </div>
            <Link
              className=classes.link
              href='/quiz'
              onClick={@trackInteraction.bind(@, "#{@props.analyticsCategory}-click-retakeQuiz")}
              children=galleryPromo.retake_text />
          </div>

        </div>}
    </div>
