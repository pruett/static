[
  _
  React

  CopyBox
  Picture
  Markdown

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/landing/process/copy_box/copy_box'
  require 'components/atoms/images/picture/picture'
  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.analytics
  ]

  getDefaultProps: ->
    copy: []

  BLOCK_CLASS: 'c-landing-process-block-split'

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
      u-grid__col u-w12c -c-8--900 u-tal
    '
    columnCopy: '
      u-grid__col u-w12c u-w7c--600 u-w5c--900  u-tal
      -col-middle
    '
    columnPicture: '
      u-grid__col u-w12c u-w5c--600 u-w3c--900
      -col-middle
    '
    columnVideo: '
      u-grid__col u-w12c u-w5c--600 u-w3c--900
      -col-middle
    '
    markdown: '
      u-reset
    '
    bodyCopy: '
      u-body-standard
      u-mb18
    '
    picture: '
      u-w100p
    '
    splitWrapper: '
      u-pr
    '

  classesWillUpdate: ->
    columnPicture:
      'u-pr u-l7c--600 u-l5c--900': @props.flip
    columnCopy:
      'u-pr u-r5c--600 u-r3c--900': @props.flip

  getDefaultProps: ->
    css_modifiers: {}
    flip: false
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
      alt: 'TBD'
      className: @classes.picture

  renderImagery: ->
    pictureAttrs = @getPictureAttrs()
    <div className=@classes.columnPicture>
      <Picture children={@getPictureChildren(pictureAttrs)} />
    </div>

  renderBody: ->
    <div className=@classes.row>
      <div className=@classes.splitWrapper>
        { @renderImagery() }
        <div className=@classes.columnCopy>
          <CopyBox {...@props.copy} gaTarget=@props.ga_target />
        </div>
      </div>
    </div>

  renderHeader: ->
    if @props.header
      <div className=@classes.row>
        <div className=@classes.columnHeader>
          <h1 className=@classes.header children=@props.header />
        </div>
      </div>

  render: ->
    @classes = @getClasses()

    <div className=@classes.block>
      { @renderHeader() }
      { @renderBody() }
    </div>
