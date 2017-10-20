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

  getDefaultProps: ->
    hero: {}

  propTypes:
    hero: React.PropTypes.object

  getPictureAttrs: ->
    images = _.get @props, "hero.image.#{@props.version}"

    sources: [
      url: @getImageBySize(images, 'desktop-hd')
      widths: _.range 720, 2000, 150
      sizes: '80vw'
      mediaQuery: '(min-width: 1200px)'
    ,
      url: @getImageBySize(images, 'desktop-sd')
      widths: _.range 1000, 2200, 200
      sizes: '80vw'
      mediaQuery: '(min-width: 960px)'
    ,
      url: @getImageBySize(images, 'tablet')
      widths: _.range 800, 1200, 200
      sizes: '80vw'
      mediaQuery: '(min-width: 640px)'
    ,
      url: @getImageBySize(images, 'mobile')
      widths: _.range 300, 700, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Warby Parker'
      className: @classes.picture

  getStaticClasses: ->
    block: '
      u-mb48 u-mb60--600
      u-pt36 u-pt60--600 u-pt84--900
    '
    grid: '
      u-grid -maxed
      u-ma
    '
    row: '
      u-grid__row
      u-tac
    '
    columnText: '
      u-grid__col u-w12c u-w10c--900
    '
    columnImage: '
      u-grid__col u-w12c
    '
    header: '
      u-heading-lg
      u-reset
      u-mb8 u-mb12--600
    '
    body: '
      u-fs18 u-fs20--900 u-reset
      u-mb30 u-mb72--600 u-mb108--900
      u-lh30
    '
    picture: '
      u-w100p
    '
    reset: '
      u-reset
    '

  render: ->
    @classes = @getClasses()
    hero = _.get @props, 'hero', {}
    image = @getPictureAttrs()

    <section className=@classes.block>
      <div className=@classes.grid>
        <div className=@classes.row>
          <div className=@classes.columnText>
            <h1 children=hero.header className=@classes.header />
            <Markdown rawMarkdown=hero.body className=@classes.body cssBlock=@classes.reset  />
          </div>
        </div>
        <div className=@classes.row>
          <div className=@classes.columnImage>
            <Picture children={@getPictureChildren(image)} />
          </div>
        </div>
      </div>
    </section>
