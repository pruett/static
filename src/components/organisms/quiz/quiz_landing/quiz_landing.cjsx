_ = require 'lodash'
React = require 'react/addons'

Img = require 'components/atoms/images/img/img'

Mixins = require 'components/mixins/mixins'

require './quiz_landing.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-quiz-landing'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.image
  ]

  getDefaultProps: ->
    header: ''
    image: ''
    subhead: ''
    cta: ''
    manageLaunchQuiz: ->
    imageWidths: [320, 500, 640, 800, 1000, 1280, 1600]
    imageSizes: [
      breakpoint: 0,
      width: '320px'
    ,
      breakpoint: 500,
      width: '500px'
    ,
      breakpoint: 900,
      width: '50vw'
    ,
      breakpoint: 1600,
      width: '800px'
    ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
    "
    container: "
      #{@BLOCK_CLASS}__container
      u-df u-ai--c u-jc--c
      u-flexd--c u-flexd--r--900
      u-mla u-mra
      u-pl18 u-pr18 u-pt48 u-pb48
      u-pt60--900 u-pb60--900
      u-pl24--900 u-pr24--900
      u-tac
    "
    content: "
      #{@BLOCK_CLASS}__content
      u-pt24 u-pt0--900 u-pl48--900
    "
    header: '
      u-m0
      u-ffs u-fws
      u-fs30 u-fs55--600
    '
    subhead: '
      u-mt12 u-mt18--600 u-mb30
      u-ffss u-fs18--600 u-lh24
      u-color--dark-gray-alt-3
    '
    cta: "
      #{@BLOCK_CLASS}__cta
      u-button -button-white -button-medium -v2
      u-fws
    "

  handleLaunch: ->
    @trackInteraction 'quiz-click-start'
    @props.manageLaunchQuiz()

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <div className=classes.container>
        <Img
          srcSet={@getSrcSet {url: @props.image, widths: @props.imageWidths, quality: 90}}
          sizes={@getImgSizes @props.imageSizes} />
        <div className=classes.content>
          <h1 className=classes.header children=@props.header  />
          <p className=classes.subhead children=@props.subhead />
          <button className=classes.cta children=@props.cta onClick=@handleLaunch />
        </div>
      </div>
    </div>
