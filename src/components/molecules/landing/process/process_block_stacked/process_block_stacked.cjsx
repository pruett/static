[
  _
  React

  CopyBox
  Picture
  Markdown
  Video

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/landing/process/copy_box/copy_box'
  require 'components/atoms/images/picture/picture'
  require 'components/molecules/markdown/markdown'
  require 'components/molecules/landing/process/video/video'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  BLOCK_CLASS: 'c-landing-process-block-stacked'

  getStaticClasses: ->
    block: "
      u-mla u-mra u-tac
      u-grid -maxed
      #{@props.css_utilities.block_margin_bottom}
    "
    row: '
      u-grid__row
    '
    header: "
      u-reset
      #{@props.css_utilities.header_size}
      #{@props.css_utilities.header_margin_bottom}
      #{@props.css_utilities.header_font_family}
    "
    columnHeader: '
      u-grid__col u-w12c -c-8--900
      u-tal
    '
    columnPicture: '
      u-grid__col u-w12c -c-8--900
      u-tal
    '
    columnVideo: '
      u-grid__col u-w12c -c-8--900
      u-tal
    '
    columnCopy: '
      u-grid__col u-w12c -c-8--900
      u-tal
    '
    markdown: '
      u-reset
    '
    bodyCopy: '
      u-body-standard
    '
    picture: '
      u-w100p
    '

  getDefaultProps: ->
    css_modifiers: {}
    ga_target: 'Process'

  getPictureAttrs: ->
    images = _.get @props, 'media.image', {}

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

  renderHeader: ->
    if @props.header
      <div className=@classes.row>
        <div className=@classes.columnHeader>
          <h1 className=@classes.header children=@props.header />
        </div>
      </div>

  renderImagery: ->
    pictureAttrs = @getPictureAttrs()
    <div className=@classes.columnPicture>
      <Picture children={@getPictureChildren(pictureAttrs)} />
    </div>

  renderMedia: ->
    if _.get @props, 'media.show_video'
      @renderVideo()
    else
      @renderImagery()

  renderVideo: ->
    <div className=@classes.columnVideo>
      <Video {...@props} />
    </div>

  renderBody: ->
    unless @props.callout_type is 'text_only'
      <div>
        <div className=@classes.row>
          { @renderMedia() }
        </div>
        <div className=@classes.row>
          <div className=@classes.columnCopy>
            <CopyBox {...@props.copy} gaTarget=@props.ga_target />
          </div>
        </div>
      </div>
    else
      <div className=@classes.row>
        <div className=@classes.columnCopy>
          <CopyBox {...@props.copy} gaTarget=@props.ga_target />
        </div>
      </div>

  render: ->
    @classes = @getClasses()

    <div className=@classes.block>
      { @renderHeader() }
      { @renderBody() }
    </div>
