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
    Mixins.callout
    Mixins.image
  ]

  propTypes:
    body: React.PropTypes.string
    header: React.PropTypes.string
    image: React.PropTypes.array

  getDefaultProps: ->
    body: ''
    header: ''
    image: []

  getStaticClasses: ->
    block: '
      u-mb36 u-mb48--600 u-mb72--900
    '
    grid: '
      u-grid -maxed
      u-ma
    '
    row: '
      u-grid__row
      u-tac
    '
    columnImage: '
      u-grid__col -col-middle u-w12c u-w8c--600 u-w6c--900 u-w5c--1200
      u-mb18 u-mb24--600 u-mb0--900
    '
    columnCopy: '
      u-grid__col -col-middle u-w12c u-w10c--600 u-w6c--900 u-w5c--1200
    '
    header: '
      u-fs16 u-fs18--600 u-fwb
      u-color--dark-gray
      u-reset
      u-mb8 u-mb12--600
    '
    body: '
      u-body-standard
      u-reset
    '
    reset: '
      u-reset
    '
    picture: '
      u-w100p
    '

  classesWillUpdate: ->
    columnCopy:
      'u-pr u-r6c--900 u-r5c--1200': @props.flip
    columnImage:
      'u-pr u-l6c--900 u-l5c--1200': @props.flip


  getPictureAttrs: (classes) ->
    images = @props.image

    sources: [
      url: @getImageBySize(images, 'desktop-sd')
      widths: _.range 1000, 2200, 200
      sizes: '60vw'
      mediaQuery: '(min-width: 960px)'
    ,
      url: @getImageBySize(images, 'tablet')
      widths: _.range 800, 1200, 200
      sizes: '60vw'
      mediaQuery: '(min-width: 640px)'
    ,
      url: @getImageBySize(images, 'mobile')
      widths: _.range 300, 700, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Warby Parker'
      className: classes.picture

  render: ->
    classes = @getClasses()
    image = @getPictureAttrs(classes)

    <section className=classes.block>
      <div className=classes.grid>
        <div className=classes.row>
          <div className=classes.columnImage>
            <Picture children={@getPictureChildren(image)} />
          </div>
          <div className=classes.columnCopy>
            <h1 className=classes.header children=@props.header />
            <Markdown
              className=classes.body
              rawMarkdown=@props.body
              cssBlock=classes.reset />
          </div>
        </div>
      </div>


    </section>
