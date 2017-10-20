[
  _
  React

  Markdown
  Picture

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.context
  ]

  getDefaultProps: ->
    css_utility_title: 'u-color--dark-gray'
    css_utility_description: 'u-color--light-gray-alt-4'
    css_utility_highlight: 'u-color--dark-gray'
    css_utility_eyebrow: 'u-color--dark-gray'
    text_align: 'left'

  getStaticClasses: ->
    block: '
      u-mw1440
      u-mla u-mra
    '
    blockWrapper: '
      u-pr
      u-oh
    '
    grid: '
      u-t50p
      u-pa--900 u-ttyn50--900
      u-pb0--600
      u-grid -maxed u-mra u-mla
      u-pt30 u-pt36--600
    '
    row: '
      u-grid__row'
    col: '
      u-grid__col u-w5c--900 u-tac'
    picture:
      'u-tac u-pr u-mra u-mla u-w100p
      u-pr u-h0 u-ratio--1-1 u-ratio--3-2--600 u-ratio--2-1--900
      u-db'
    image:
      'u-w100p u-db'
    title: "
      u-heading-lg
      u-mb12 u-mb6--600
      u-grid__col u-w12c
      u-ffs u-fws
      #{@props.css_utility_title}
    "
    description: "
      u-fs16 u-fs18--900
      u-ffss
      u-grid__col u-w12c -c-10--600 -c-12--900
      u-mb12
      #{@props.css_utility_description}
    "
    markdown:
      'u-reset'
    highlight: "
      u-fs16 u-fs18--900
      u-ffss
      u-grid__col u-w12c -c-10--600 -c-12--900
      u-mb48 u-mb60--600
      u-fws
      #{@props.css_utility_highlight}
    "
    hr: '
      u-reset
      u-bc--light-gray u-bw0 u-bbw4 u-bss
      u-w2c u-w1c--600
      u-mla u-mra
      u-mb48 u-mb60--600 u-dn--900
    '
    eyebrow: "
      u-mb12 u-mb6--600
      u-grid__col u-w12c
      u-ls2 u-fs12 u-ffss
      u-ffs u-fwb
      #{@props.css_utility_eyebrow}
    "

  classesWillUpdate: ->
    description:
      'u-mb48 u-mb60--600': not @props.highlight_text
    col:
      'u-pr u-l7c': @props.text_align is 'right'

  getPictureAttrs: ->
    sources: [
      quality: @getQualityBySize(@props.images, 'm')
      url: @getImageBySize(@props.images, 'm')
      widths: _.range 900, 2880, 200
      mediaQuery: '(min-width: 900px)'
      sizes: '(min-width: 1440px) 1440px, 100vw'
    ,
      quality: @getQualityBySize(@props.images, 's')
      url: @getImageBySize(@props.images, 's')
      widths: _.range 768, 2048, 200
      mediaQuery: '(min-width: 600px)'
    ,
      quality: @getQualityBySize(@props.images, 'xs')
      url: @getImageBySize(@props.images, 'xs')
      widths: _.range 320, 1500, 200
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: _.get @props, 'analytics.name', 'Landing Page Hero'
      className: @classes.image

  renderHighlight: ->
    # Allow for rendering context-based highlight text (I.E. Price, HTO)
    country = @getLocale('country')
    if country is 'CA' and @props.highlight_text_canada
      <Markdown
        rawMarkdown=@props.highlight_text_canada
        className=@classes.highlight
        cssBlock=@classes.markdown />
    else
      <Markdown
        rawMarkdown=@props.highlight_text
        className=@classes.highlight
        cssBlock=@classes.markdown />

  render: ->
    @classes = @getClasses()
    pictureAttrs = @getPictureAttrs()

    <section className=@classes.block>
      <div className=@classes.blockWrapper>
        <Picture
          children={@getPictureChildren(pictureAttrs)}
          cssModifier=@classes.picture />
        <div className=@classes.grid>
          <div className=@classes.row>
            <div className=@classes.col>
              {if @props.eyebrow
                <Markdown
                  rawMarkdown=@props.eyebrow
                  className=@classes.eyebrow
                  cssBlock=@classes.markdown />}
              <Markdown
                rawMarkdown=@props.title
                className=@classes.title
                cssBlock=@classes.markdown />
              <Markdown
                rawMarkdown=@props.description
                className=@classes.description
                cssBlock=@classes.markdown />
              {@renderHighlight()}
            </div>
          </div>
        </div>
      </div>
      <hr className=@classes.hr />
    </section>
