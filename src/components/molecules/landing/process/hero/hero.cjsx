
[
  _
  React

  Picture
  Markdown

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/picture/picture'
  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'
]


module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  BLOCK_CLASS: 'c-landing-process-block-hero'

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    grid: '
      u-grid u-mla u-mra
    '
    row: '
      u-grid__row
    '
    column: '
      u-tal
    '
    markdown: '
      u-reset
    '
    bodyCopy: '
      u-body-intro
      u-mb60
      u-reset
    '
    header: '
      u-heading-md
      u-reset
      u-mb12
    '
    picture: '
      u-w100p
    '
    reset: '
      u-reset
    '

  classesWillUpdate: ->
    grid:
      'u-pa--900 u-t0--900 u-l0--900 u-center-y--900': @props.show_image
      'u-tac': not @props.show_image
      '-maxed': not @props.show_image
    column:
      'u-grid__col u-w12c -c-5--900 u-pt60 u-pt0--900': @props.show_image
      'u-grid__col u-w12c -c-8--900 u-pt60': not @props.show_image
    bodyCopy:
      'u-mb96--900': not @props.show_image
      'u-mb0--900': @props.show_image
    block:
      'u-mb60--900': @props.show_image

  renderCopy: ->
    <div className=@classes.copyWrapper>
      <div className=@classes.grid>
        <div className=@classes.row>
          <div className=@classes.column>
            <Markdown
              tagName='h1'
              rawMarkdown=@props.headline
              cssBlock=@classes.reset
              className=@classes.header />
            <Markdown
              rawMarkdown=@props.body
              cssBlock=@classes.reset
              className=@classes.bodyCopy />
          </div>
        </div>
      </div>
    </div>

  renderImage: ->
    pictureAttrs = @getPictureAttrs()
    <div>
      <Picture children={@getPictureChildren(pictureAttrs)} />
      { @renderCopy() }
    </div>

  getPictureAttrs: ->
    images = _.get @props, 'image', []

    sources: [
      url: @getImageBySize(images, 'desktop')
      widths: _.range 1000, 2200, 200
      mediaQuery: '(min-width: 960px)'
    ,
      url: @getImageBySize(images, 'tablet')
      widths: _.range 700, 1400, 200
      mediaQuery: '(min-width: 640px)'
    ,
      url: @getImageBySize(images, 'mobile')
      widths: _.range 300, 700, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Warby Parker'
      className: @classes.picture

  render: ->
    @classes = @getClasses()

    <div className=@classes.block>
      {
        if @props.show_image
          <div className='u-pr'>
            {
              @renderImage()
            }
          </div>
        else
          @renderCopy()
      }
    </div>
