[
  _
  React

  LeftArrow

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/left_arrow/left_arrow'

  require 'components/mixins/mixins'

  require './fade.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-slider-fade'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    cssModifier: ''
    cssUtility: ''
    slides: []
    slideDuration: 3000
    autoPlay: true
    showArrows:
      left: true
      right: true

  getInitialState: ->
    activeSlide: 0

  getStaticClasses: ->
    wrapper: [
      "#{@BLOCK_CLASS}"
      "#{@props.cssModifier}"
      "#{@props.cssUtility}"
    ]
    slide: "#{@BLOCK_CLASS}__slide"
    image: "#{@BLOCK_CLASS}__image"
    arrowWrapperLeft: "#{@BLOCK_CLASS}__arrow-wrapper -left-arrow"
    arrowWrapperRight: "#{@BLOCK_CLASS}__arrow-wrapper -right-arrow"
    leftArrowModifier: 'u-w100p u-fill--white'
    rightArrowModifier: 'u-w100p u-fill--white -icon-mirror'

  componentDidMount: ->
    if @props.autoPlay
      @setState slideTimeout: setTimeout(@play, @props.slideDuration)

  componentWillUnmount: ->
    if @state.slideTimeout
      clearTimeout @state.slideTimeout

  play: ->
    @incrementSlide()
    @setState slideTimeout: setTimeout(@play, @props.slideDuration)

  goToSlide: (slide) ->
    @setState activeSlide: slide %% @props.slides.length

  incrementSlide: ->
    @goToSlide(@state.activeSlide + 1)

  decrementSlide: ->
    @goToSlide(@state.activeSlide - 1)

  handleClick: (direction) ->
    if @state.slideTimeout
      clearTimeout(@state.slideTimeout)

    if direction is 'left'
      @decrementSlide()
    else if direction is 'right'
      @incrementSlide()

    @setState slideTimeout: setTimeout(@play, @props.slideDuration)

  render: ->
    classes = @getClasses()

    <div className=classes.wrapper>
      {_.map @props.slides, (slide, i) =>
        <div
          key=i
          className={[classes.slide, '-active' if @state.activeSlide is i].join ' '}>
          {
            if _.isFunction @props.imageLoad
              <img
                className=classes.image
                src=slide.image
                alt=slide.alt_text
                onLoad={@props.imageLoad}
              />
            else
              <img
                className=classes.image
                src=slide.image
                alt=slide.alt_text
              />
          }
          {if @props.slideChildren[i]?
            @props.slideChildren[i]}
          {if @props.showArrows.left
            <div
              className=classes.arrowWrapperLeft
              onClick={@handleClick.bind(@, 'left')}>
              <LeftArrow cssModifier=classes.leftArrowModifier />
            </div>}
          {if @props.showArrows.right
            <div
              className=classes.arrowWrapperRight
              onClick={@handleClick.bind(@, 'right')}>
              <LeftArrow cssModifier=classes.rightArrowModifier />
            </div>}
        </div>}
    </div>
