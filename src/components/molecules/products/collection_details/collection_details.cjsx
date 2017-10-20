[
  _
  React

  Picture
  CTA
  Markdown

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/picture/picture'
  require 'components/atoms/buttons/cta/cta'
  require 'components/molecules/markdown/markdown'
  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-pdp-collection-details'

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.analytics
  ]

  propTypes:
    details: React.PropTypes.array

  getDefaultProps: ->
    body: ""
    button_href: ""
    button_text: ""
    ga_slug: ""
    header: ""
    identifier: ""
    image: []
    name: ""
    image_href: ""

  propTypes:
    header: React.PropTypes.string
    body: React.PropTypes.string
    button_href: React.PropTypes.string
    image_href: React.PropTypes.string
    button_text: React.PropTypes.string
    ga_slug: React.PropTypes.string
    identifier: React.PropTypes.string
    name: React.PropTypes.string
    image: React.PropTypes.array

  getStaticClasses: ->
    block:"
      #{@BLOCK_CLASS}
      u-pt36 u-pt48--600 u-pt72--900
      u-pb36 u-pb48--600 u-pb72--900
    "
    grid: '
      u-grid -maxed
    '
    row: '
      u-grid__row
    '
    columnDetails: '
      u-grid__col u-w12c u-w5c--600 -col-middle
    '
    columnImage: '
      u-grid__col u-w12c u-w7c--600 -col-middle
    '
    header: '
      u-fs20 u-fs16--600 u-fs20--900 u-ffs u-reset u-fws u-mb12
    '
    body: '
      u-fs16
    '
    detailsWrapper: '
      u-w10c u-w11c--600 u-w9c--900
      u-tac u-tal--600
      u-tac u-tal--600
      u-mla u-mra u-ml0--600
    '
    picture: '
      u-w100p
    '
    button: '
      c-cta c-cta--minimal
      u-dib u-reset
      u-button -button-medium u-fs16 -button-white u-fws
    '
    mobileButtonWrapper: '
      u-dn--600
      u-tac
      u-pt36
    '
    desktopButtonWrapper: '
      u-dn u-db--600
    '

  getPictureAttrs: (image) ->
    images = @props.image
    classes = @getClasses()

    sources: [
      url: @getImageBySize(images, 'desktop-sd')
      quality: @getQualityBySize(images, 'desktop-sd')
      widths: _.range 800, 1200, 100
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: _.range 400, 800, 100
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: _.range 320, 700, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Killscreen Collection'
      className: classes.picture

  handleClick: ->
    @trackInteraction @props.ga_slug

  renderButton: ->
    classes = @getClasses()
    <a href=@props.button_href
      onClick=@handleClick
      className=classes.button
      children=@props.button_text />

  render: ->
    classes = @getClasses()
    pictureAttrs = @getPictureAttrs()

    <div className=classes.block>
      <div className=classes.row>
        <div className=classes.columnDetails>
          <div className=classes.detailsWrapper>
            <h2 children=@props.header className=classes.header />
            <Markdown
              rawMarkdown=@props.body
              className=classes.body
              />
          </div>
          <div className=classes.desktopButtonWrapper>
            { @renderButton() }
          </div>
        </div>
        <div className=classes.columnImage>
          <a href=@props.image_href>
            <Picture children={@getPictureChildren(pictureAttrs)} />
          </a>
          <div className=classes.mobileButtonWrapper>
            { @renderButton() }
          </div>
        </div>
      </div>
    </div>
