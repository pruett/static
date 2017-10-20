[
  _
  React

  CTA
  Picture

  Mixins

] = [

  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'


  require './hero.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-summer-2016-editorial-hero'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  getStaticClasses: ->
    block: '
      u-mw1440
      u-mla u-mra
      u-mbn36 u-mbn60--900
    '
    grid: '
      u-grid
    '
    row: '
      u-grid__row
      u-tac
    '
    copyWrapper: '
      u-grid__col -c-11 -c-7--600
      u-pt24 u-pb48 u-pt48--900 u-pb24--900
      u-color-bg--white
    '
    contentWrapper: "
      #{@BLOCK_CLASS}__content-wrapper
    "
    header: '
      u-heading-lg
      u-summer-2016__header
      u-typekit--filson
      u-reset
      u-mb12
      u-color--black
    '
    hashtag: '
      u-reset
      u-fs20 u-fs24--900
      u-color--black
      u-mb24
      u-fwb
    '
    description: '
      u-reset
      u-fs16 u-fs18--600
      u-color--dark-gray
      u-mb24
      u-summer-2016__body
    '
    descriptionTwo: '
      u-reset
      u-fs16 u-fs18--600
      u-color--dark-gray
      u-summer-2016__body
      u-mb36--900
    '
    img: '
      u-w100p
    '
    ctaHeader: '
      u-reset
      u-summer-2016__cta-header
      u-typekit--filson
      u-color--black
    '
    cta: '
      u-mr12--600
      u-mb12 u-mb0--600
      u-button -button-white -button-modular
    '
    ctaNewText: '
      u-reset
      u-color--blue
      u-typekit--filson
      u-summer-2016__cta-header
    '
    ctaWrapper: '
      u-grid__col -c-10
      u-pb48 u-pb72--600
    '
    ctaUtility: '
      u-color-bg--white
    '
    ctaCopyWrapper: '
      u-mb24
    '
    ctaColumnTop: '
      u-grid__col u-w12c u-w10c--600 u-w6c--900
      u-mb48 u-mb84--900
    '
    ctaColumnBottom: '
      u-grid__col u-w12c u-w10c--600 u-w6c--900
      u-mb36 u-mb84--900
    '

  getPictureAttrs: ->
    images = _.get @props, 'content.image', []

    sources: [
      url: @getImageBySize(images, 'm')
      quality: @getQualityBySize(images, 'm')
      widths: _.range 900, 2200, 200
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 's')
      quality: @getQualityBySize(images, 's')
      widths: _.range 700, 1400, 200
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'xs')
      quality: @getQualityBySize(images, 'xs')
      widths: _.range 300, 700, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Summer 2016 Editorial'
      className: @classes.img

  renderCtaSection: (keyword) ->
    ctaSection = _.get @props, 'content.cta_section', {}
    ctas = ctaSection.cta_groups[keyword]
    headline = ctaSection.headlines[keyword]
    newText = ctaSection.new_text[keyword]
    <div className={if keyword is 'sun' then @classes.ctaColumnBottom else @classes.ctaColumnTop}>
      <div className=@classes.ctaCopyWrapper>
        {
          if newText
            <span children=newText className=@classes.ctaNewText />
        }
        <span children=headline className=@classes.ctaHeader />
      </div>
      {_.map ctas, @renderCta}
    </div>

  renderCta: (cta, i) ->
    <CTA
      tagName='a'
      href=cta.href
      children=cta.text
      cssModifier=@classes.cta
      cssUtility=@classes.ctaUtility
      analyticsSlug={@getWPEventSLug(cta)}
      key=i
    />

  getWPEventSLug: (cta) ->
    #  Scheme: PromoBlock-Click-name_of_section_block__buttonName
    "PromoBlock-Click-#{cta.section_name}__#{_.camelCase cta.text}"

  render: ->
    @classes = @getClasses()
    @pictureAttrs = @getPictureAttrs()
    copy = _.get @props, 'content.copy', {}
    ctaBox = _.get @props, 'content.cta_box', {}

    <section className=@classes.block>
      <Picture children={@getPictureChildren(@pictureAttrs)} />
      <div className=@classes.grid>
        <div className=@classes.contentWrapper>
          <div className=@classes.row>
            <div className=@classes.copyWrapper>
              <h2 children=copy.header className=@classes.header />
              <h3 children=copy.hashtag className=@classes.hashtag />
              <p children=copy.description_one className=@classes.description />
              <p children=copy.description_two className=@classes.descriptionTwo />
            </div>
          </div>
          <div className=@classes.row>
            {@renderCtaSection('optical')}
            {@renderCtaSection('sun')}
          </div>
        </div>
      </div>
    </section>
