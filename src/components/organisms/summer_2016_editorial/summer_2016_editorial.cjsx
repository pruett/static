[
  _
  React

  TypeKit
  CTA
  Img
  Instagram
  FrameContainer
  Hero
  VideoBox
  FloatCallout
  FullCallout
  SplitCallout

  Mixins

] = [

  require 'lodash'
  require 'react/addons'

  require 'components/atoms/scripts/typekit/typekit'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/img/img'
  require 'components/molecules/eye_sun/instagram/instagram'
  require 'components/molecules/summer_2016_editorial/frame_container/frame_container'
  require 'components/molecules/summer_2016_editorial/hero/hero'
  require 'components/molecules/summer_2016_editorial/video/video'
  require 'components/molecules/summer_2016_editorial/callouts/float/float'
  require 'components/molecules/summer_2016_editorial/callouts/full/full'
  require 'components/molecules/summer_2016_editorial/callouts/split/split'

  require 'components/mixins/mixins'

  require './summer_2016_editorial.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-summer-2016-editorial'

  TYPEKIT_ID: 'zzq0ivh'

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.analytics
    Mixins.dispatcher
  ]

  componentDidMount: ->
    @getProductImpressions()

  reduceImpression: (finalImpressions, impression, i) ->
    impressions = _.reduce impression.ids, (acc, id) ->
      acc.concat
        brand: 'Warby Parker'
        category: 'Frame'
        name: impression.name
        color: impression.color
        list: 'Collection-Summer2016'
        position: i + 1
        id: id
    , []
    finalImpressions.concat impressions

  getProductImpressions: ->
    impressions = _.get @props, 'content.ga_product_impressions', []
    finalImpressions = _.reduce impressions, @reduceImpression, []

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productImpression'
      products: finalImpressions

  getStaticClasses: ->
    grid: '
      u-grid -maxed
      u-mla u-mra
      u-tac
    '
    row: '
      u-grid__row
      u-pt48 u-pb48
      u-pt64--600 u-pb64--600
      u-btw1 u-btss u-bc--light-gray
      u-tac
    '
    ctaSection: '
      u-grid -maxed
      u-mla u-mra
      u-tac
      u-pt24
      u-mb72 u-mb84--900
    '
    cssModifierInstagramDescriptionModifier: '
      u-pt24
      u-grid__col u-w12c -c-10--600 -c-6--900
      u-fwn
    '
    cssModifierInstagramHeaderModifier: '
      u-reset
      u-summer-2016__subheader
      u-typekit--filson
      u-color--black
      u-grid__col -c-10
    '
    cssModifierInstagramSlides: '
      u-mb24
    '
    cssModifierInstagramLabel: "
      #{@BLOCK_CLASS}__instagram-label
    "
    ctaHeaderWrapper: '
      u-grid__col u-w12c
      u-mb8
    '
    ctaRow: '
      u-grid__row
    '
    spotifyRow: '
      u-bbw1 u-btw1 u-btss u-bbss u-bc--light-gray
      u-pt48 u-pb48
    '
    ctaColumnTop: '
      u-grid__col u-w12c u-w10c--600 u-w6c--900
      u-mb24 u-mb0--900
    '
    ctaColumnBottom: '
      u-grid__col u-w12c u-w10c--600 u-w6c--900
    '
    ctaHeader: '
      u-reset
      u-summer-2016__cta-header
      u-typekit--filson
      u-mb18 u-mb24--600
      u-color--black
    '
    cta: '
      u-button -button-white -button-modular
      u-mr12--600
      u-mb12
    '
    spotifyHeader: '
      u-reset u-heading-md
      u-color--black
      u-mb12
      u-typekit--filson
      u-summer-2016__spotify-header
    '
    spotifyDescription: '
      u-reset
      u-color--dark-gray
      u-summer-2016__body
      u-mb18
    '
    spotifyWrapper: '
      u-mb48 u-mb72--600 u-mb96--900
    '
    spotifyLogoWrapper: '
      u-grid__col -c-6 -c-4--600 -c-3--900
    '
    spotifyLogo: "
      #{@BLOCK_CLASS}__spotify-logo
      u-mb36 u-mb24--900
    "
    spotifyCopyWrapper: '
      u-grid__col -c-12
      u-pt18--900
      u-tac
    '
    spotifyLink: '
      u-fs16 u-fs18--900
    '
    spotifyShoppable: "
      #{@BLOCK_CLASS}__spotify-shoppable
      u-fs16 u-fs18--600
      u-pb6
      u-fws
      u-bbss u-bbw2 u-bbw0--900 u-bc--blue
    "
    instaGramWrapper: '
      u-grid -maxed
      u-mla u-mra
    '
    instagramRow: '
      u-tac
      u-btw1 u-btss u-bc--light-gray
      u-pt48 u-pt72--600 u-pt84--900
      u-mb12 u-mb48--600 u-mb0--900
    '

  renderCtaSection: (keyword, i) ->
    ctaSection = _.get @props, 'content.cta_section', {}
    ctas = ctaSection.cta_groups[keyword]
    <div className={if keyword is 'sun' then @classes.ctaColumnBottom else @classes.ctaColumnTop} key=i>
      {_.map ctas, @renderCta}
    </div>


  getWPEventSLug: (cta) ->
    #  Apostrophe throws of GA
    target = cta.text.replace("'", "")
    #  Scheme: PromoBlock-Click-name_of_section_block__buttonName
    "PromoBlock-Click-#{cta.section_name}__#{_.camelCase target}"

  renderCta: (cta, i) ->
    <CTA
      tagName='a'
      key=i
      href=cta.href
      children=cta.text
      cssModifier=@classes.cta
      analyticsSlug={@getWPEventSLug(cta)}
    />

  handleSpotifyClick: ->
    @trackInteraction('LandingPage-clickLink-spotifyListen')

  renderSpotifySection: ->
    spotify = _.get @props, 'content.spotify', {}
    logoSrc = @getSrcSet @getSpotifyImgProps(spotify)
    sizes = @getImgSizes @logoSizes
    <section className=@classes.spotifyWrapper>
      <div className=@classes.grid>
        <div className=@classes.spotifyRow>
          <div className=@classes.ctaRow>
            <div className=@classes.spotifyLogoWrapper>
              <Img srcSet=logoSrc sizes=sizes cssModifier=@classes.spotifyLogo />
            </div>
          </div>
          <div className=@classes.ctaRow>
            <div className=@classes.spotifyCopyWrapper>
              <h3 className=@classes.spotifyHeader children=spotify.headline />
              <p className=@classes.spotifyDescription children=spotify.description />
              <a
                href=spotify.href
                onClick=@handleSpotifyClick
                className={if spotify.shoppable then @classes.spotifyShoppable else @classes.spotifyLink}
                children=spotify.link_text />
            </div>
          </div>
        </div>
      </div>
    </section>

  getSpotifyImgProps: (spotifyData) ->
    url: spotifyData.img
    widths: [400, 500, 600]

  logoSizes: [
    breakpoint: 0
    width: '100vw'
  ,
    breakpoint: 600
    width: '70vw'
  ]

  render: ->
    callouts = _.get @props, 'content.callouts', {}
    instagram = _.get @props, 'content.instagram', {}
    @classes = @getClasses()
    ctaSection = _.get @props, 'content.cta_section', {}

    <section>
      <TypeKit typeKitModifier=@TYPEKIT_ID />
      <Hero content={_.get @props, 'content.hero'} />
      <FullCallout content=callouts.frame_full_one firstCallout=true />
      <FloatCallout content=callouts.frame_float_one />
      <FloatCallout content=callouts.frame_float_two invert=true />
      <FloatCallout content=callouts.frame_float_three />
      <section className=@classes.ctaSection>
          <h3 className=@classes.ctaHeader children=ctaSection.headline />
          {
            _.map ['optical', 'sun'], @renderCtaSection
          }
      </section>
      <FullCallout content=callouts.frame_full_two />
      { @renderSpotifySection() }
      <FullCallout content=callouts.frame_full_three />
      <SplitCallout content=callouts.frame_split_one invert=true />
      <SplitCallout content=callouts.frame_split_two />
      <VideoBox content={_.get @props, 'content.video'} />
      <section className=@classes.instaGramWrapper>
        <div className=@classes.instagramRow>
          <Instagram
            {...instagram}
            cssModifierDescription=@classes.cssModifierInstagramDescriptionModifier
            cssModifierHeading=@classes.cssModifierInstagramHeaderModifier
            headingOrientation='bottom'
            cssModifierSlide=@classes.cssModifierInstagramSlides
            cssModifierLabel=@classes.cssModifierInstagramLabel />
        </div>
      </section>
      <FrameContainer content={_.get @props, 'content.frame_container'} />
    </section>
