[
  _
  React

  Callout
  Cta
  LeftArrow

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/callout/callout'
  require 'components/atoms/buttons/cta/cta'
  require 'components/quanta/icons/left_arrow/left_arrow'

  require 'components/mixins/mixins'

  require './instagram.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-eyesun-instagram'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  getDefaultProps: ->
    heading:''
    description: ''
    posts: []
    cssModifierHeading: ''
    radioName: 'instagram'
    headingOrientation: 'top'
    cssModifierDescription: ''
    cssModifierHeading: ''

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-grid__row
      u-oh
      u-pr"
    heading:
      "#{@props.cssModifierHeading}
      u-reset u-fs24 u-fs30--600 u-fs34--900 u-fs40--1200 u-ffs u-fws"
    description:
      "u-reset u-fs16 u-fs18--900
      u-ffss u-color--dark-gray-alt-3
      u-pb24 u-pb72--900
      #{@props.cssModifierDescription}
      "
    slider:
      'u-oh
      u-pr
      u-grid__col u-w12c -c-8--600 -c-12--900
      u-tar'
    slides:
      "#{@BLOCK_CLASS}__slides
      #{@props.cssModifierSlide}
      u-grid__row
      u-mb12"
    slide:
      "#{@BLOCK_CLASS}__slide
      u-dib
      u-pr
      u-w100p
      u-grid__col u-w12c -c-4--900"
    label:
      "#{@BLOCK_CLASS}__label
      #{@props.cssModifierLabel}
      u-dib u-dn--900
      u-cursor--pointer
      u-color-bg--dark-gray-alt-2
      u-ml12"
    radio:
      "#{@BLOCK_CLASS}__radio
      u-hide--visual"
    calloutBlock:
      'u-oh
      u-ratio--1-1
      u-w100p
      u-pr
      u-h0
      u-color--white'
    calloutWrapper:
      "#{@BLOCK_CLASS}__wrapper
      u-cursor--pointer
      u-size--fill"
    calloutCopy:
      'u-pa u-center
      u-tac
      u-mra u-mla
      u-grid__col u-w12c'
    calloutTitle:
      'u-reset u-fs24
      u-ffs
      u-mr6
      u-dib'
    calloutDescription:
      'u-reset u-fs24
      u-ffs
      u-fsi
      u-dib
      '
    calloutLink:
      "#{@BLOCK_CLASS}__link
      u-dt
      u-color--white
      u-mra u-mla
      u-pb3"
    calloutPicture:
      'u-w100p'
    calloutImage:
      'u-w100p'
    copyWrapperBottom:
      'u-pt24 u-pt36--600 u-pt72--900'


  classesWillUpdate: ->
    calloutLink:
      '-shoppable u-color--blue u-fwb u-fs16 u-fs18--600': @props.shoppable
      'u-fs18': !@props.shoppable

  getId: (i) ->
    "#{@props.radioName}-#{i}"

  renderSlide: (post, i) ->
    pictureAttrs =
      sources: [
        quality: @getQualityBySize(post.images, 'xs')
        url: @getImageBySize(post.images, 'xs')
        widths: _.range 320, 1500, 200
        sizes: '(min-width: 1024px) 33vw, 50vw'
        mediaQuery: '(min-width: 0px)'
      ]
      img:
        alt: _.get post, 'analytics.name', ''

    <div key=i className=@classes.slide>
      <Callout {...post} key=i
        cssUtilities={@pickClasses(@classes, 'callout')}
        pictureAttrs=pictureAttrs />
    </div>

  renderRadio: (post, i) ->
    <input key=i id={@getId(i)} name=@props.radioName type='radio'
      defaultChecked={i is 0}
      className=@classes.radio />

  renderLabel: (post, i) ->
    <label key=i htmlFor={@getId(i)} className=@classes.label />

  renderCopy: (orientation) ->
    <div className={if orientation is 'bottom' then @classes.copyWrapperBottom else '' }>
      <h2 className=@classes.heading children=@props.heading />
      <p className=@classes.description children=@props.description />
    </div>

  render: ->
    @classes = @getClasses()

    <div className=@classes.block>
      {
        if @props.headingOrientation is 'top'
          @renderCopy('top')
      }
      <div className=@classes.slider>
        {_.map @props.posts, @renderRadio}
        <div className=@classes.slides children={_.map @props.posts, @renderSlide}/>
        {_.map @props.posts, @renderLabel}
      </div>
      {
        if @props.headingOrientation is 'bottom'
          @renderCopy('bottom')
      }
    </div>
