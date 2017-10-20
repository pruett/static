[
  React

  Img
  Markdown

  Mixins

] = [
  require 'react/addons'

  require 'components/atoms/images/img/img'
  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'

  require './gallery_promo.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-landing-gallery-promo'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
    Mixins.image
  ]

  getStaticClasses: ->
    block: '
      u-grid -maxed
      u-mla u-mra
      u-mb60
    '
    image: "
      #{@BLOCK_CLASS}__image
    "
    imageWrapper: '
      u-mb12
    '
    contentWrapper: '
      u-color-bg--light-gray-alt-2
      u-grid__row
      u-tac
      u-pt24 u-pb24 u-pt36--600 u-pb36--600
    '
    header: '
      u-fs20 u-fs26--600 u-fs30--900
      u-ffs
      u-fws
    '
    headerWrapper: '
      u-grid__col u-w12c -c10--600
    '
    description: "
      #{@BLOCK_CLASS}__description
      u-fs16 u-fs18--600
    "
    descriptionWrapper: '
      u-grid__col u-w12c -c-8--600
    '
    markdown: 'u-reset'

  classesWillUpdate: ->
    # header will need a bit of padding bottom if a description is provided
    # font size also alters slightly in that event
    # use background color if specified
    header:
      'u-mb6 u-mb8--600 u-fs24 u-fs30--600 u-fs36--900': @props.description

  getImgProps: ->
    url: @props.image
    widths: [25, 50, 100, 150, 200]

  imgSizes: [
    breakpoint: 0,
    width: '20vw'
  ,
    breakpoint: 600,
    width: '15vw'
  ]

  renderImage: ->
    if @props.image
      imgSrcSet = @getSrcSet @getImgProps()
      <div className=@classes.imageWrapper>
        <Img srcSet=imgSrcSet
          cssModifier=@classes.image
          sizes={@getImgSizes @imgSizes}
        />
      </div>

  renderHeader: ->
    if @props.header
      <div className=@classes.headerWrapper>
        <Markdown
          rawMarkdown=@props.header
          className=@classes.header
          cssBlock=@classes.markdown />
      </div>

  renderDescription: ->
    if @props.description
      <div className=@classes.descriptionWrapper>
        <Markdown
          rawMarkdown=@props.description
          className=@classes.description
          cssBlock=@classes.markdown />
      </div>

  render: ->
    @classes = @getClasses()

    <section className=@classes.block>
      <div className=@classes.contentWrapper>
        { @renderImage() }
        { @renderHeader() }
        { @renderDescription() }
      </div>
    </section>
