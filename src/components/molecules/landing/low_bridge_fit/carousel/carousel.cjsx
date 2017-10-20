[
  _
  React

  Callout

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/callout/callout'

  require 'components/mixins/mixins'

  require './carousel.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-low-bridge-fit-carousel'

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.analytics
  ]

  getDefaultProps: ->
    men: []
    fans: []
    women: []

  getInitialState: ->
    counter: 0

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-grid__row
      u-oh
      u-pr"
    heading:
      "u-reset u-fs24 u-fs30--600 u-fs34--900 u-fs40--1200 u-ffs"
    slider:
      'u-oh
      u-pr
      u-grid__col u-w12c -c-12--600
      u-tar'
    slides:
      "#{@BLOCK_CLASS}__slides
      u-wsnw
      u-pr
      u-h0
      u-grid__row
      u-cursor--pointer
      u-ratio--1-1
      u-ratio--3-2--600
      u-ratio--2-1--900
      u-mb12"
    slide:
      "#{@BLOCK_CLASS}__slide
      u-dib
      u-pa
      u-t0
      u-l0
      u-wsn
      u-w100p
      u-grid__col u-w12c"
    label:
      "#{@BLOCK_CLASS}__label
      u-dib u-dn--900
      u-color-bg--light-gray
      u-ml6"
    radio:
      "#{@BLOCK_CLASS}__radio
      u-hide--visual"
    calloutBlock:
      'u-oh
      u-ratio--1-1 u-ratio--3-2--600 u-ratio--2-1--900
      u-w100p
      u-pr
      u-h0
      u-color--white'
    calloutWrapper:
      "#{@BLOCK_CLASS}__wrapper
      u-size--fill"
    calloutCopy:
      'u-pa u-center
      u-tac
      u-mra u-mla
      u-grid__col u-w12c'
    calloutPicture:
      'u-w100p'
    calloutImage:
      'u-w100p'
    cssModifierHighlight:
      '-highlight'

  incrementCounter: ->
    if @state.counter < @props["#{@props.version}"].length - 1
      @setState counter: @state.counter + 1
    else
      @setState counter: 0

    @trackInteraction "LandingPage-Touch-CarouselImage#{@state.counter}"

  getSlideKlass: (i) ->
    if @state.counter is i
      "#{@classes.slide} #{@classes.cssModifierHighlight}"
    else
      @classes.slide

  getLabelKlass: (i) ->
    if @state.counter is i
      @classes.labelHighlight
      "#{@classes.label} #{@classes.cssModifierHighlight}"
    else
      @classes.label

  renderSlide: (post, i) ->
    pictureAttrs =
      sources: [
        url: @getImageBySize(post.images, 'desktop-hd')
        widths: _.range 720, 1300, 150
        sizes: '80vw'
        mediaQuery: '(min-width: 1200px)'
      ,
        url: @getImageBySize(post.images, 'desktop-sd')
        widths: _.range 320, 1500, 200
        sizes: '80vw'
        mediaQuery: '(min-width: 900px)'
      ,
        url: @getImageBySize(post.images, 'tablet')
        widths: _.range 320, 1500, 200
        sizes: '80vw'
        mediaQuery: '(min-width: 600px)'
      ,
        url: @getImageBySize(post.images, 'mobile')
        widths: _.range 320, 1500, 200
        sizes: '80vw'
        mediaQuery: '(min-width: 0px)'
      ]
      img:
        alt: _.get post, 'analytics.name', ''

    <div key=i className={@getSlideKlass(i)}>
      <Callout {...post} key=i
        cssUtilities={@pickClasses(@classes, 'callout')}
        pictureAttrs=pictureAttrs />
    </div>

  renderLabel: (slide, i) ->
    <label key=i className={@getLabelKlass(i)} />

  render: ->
    @classes = @getClasses()
    slides = @props["#{@props.version}"]

    <div className=@classes.block>
      <div className=@classes.slider onClick=@incrementCounter aria-role='button'>
        <div className=@classes.slides children={_.map slides, @renderSlide}/>
        {_.map slides, @renderLabel}
      </div>
    </div>
