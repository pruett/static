[
  _
  React

  CollectionFrame

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/products/collection_frame/collection_frame'

  require 'components/mixins/mixins'

  require '../../../products/frames_grid/frames_grid.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-frames-grid--deprecated'
  GA_CATEGORY: 'Landing-Page-Fall-2015'

  mixins: [
    Mixins.classes
  ]

  fadeWrappers: []

  propTypes:
    version: React.PropTypes.oneOf(['fans', 'men', 'women'])

  getDefaultProps: ->
    version: 'fans'
    cssModifier: '-two-column'

  componentDidMount: ->
    @throttledOnViewportChange = _.throttle(@onViewportChange, 100)
    window?.addEventListener 'scroll', @throttledOnViewportChange
    window?.addEventListener 'resize', @throttledOnViewportChange

    @onViewportChange()

  componentWillUnmout: ->
    @cleanUpEventListeners()

  elementIsInViewport: (el) ->
    rect = el.getBoundingClientRect()
    windowHeight = window?.innerHeight || document?.documentElement.clientHeight
    windowWidth = window?.innerWidth || document?.documentElement.clientWidth

    return rect.top <= windowHeight - 10 &&
           rect.bottom >= 10 &&
           rect.right > 0 &&
           rect.left < windowWidth

  onViewportChange: ->
    numInvisible = 0

    _.forEach @refs, (ref, name) =>
      if name.indexOf('fadeWrapper') is 0 and not _.get @state, "fadingInitialized_#{name}"
        numInvisible += 1
        if @elementIsInViewport(React.findDOMNode ref)
          @setState "fadingInitialized_#{name}": true
          setTimeout ( () =>
            @setState "faded_#{name}": true
          ), Math.random() * 300
    if numInvisible is 0
      @cleanUpEventListeners()


  cleanUpEventListeners: ->
    window?.removeEventListener 'scroll', @throttledOnViewportChange
    window?.removeEventListener 'resize', @throttledOnViewportChange

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
    "
    container: "
      #{@BLOCK_CLASS}__container
    "

  render: ->
    classes = @getClasses()
    # CollectionFrame uses abbreviations for men's and women's versions
    frameVersion = {men: 'm', women: 'w', fans: 'fans'}[@props.version]
    collectionFrames = _.map @props.frames, (frame, i) =>
      faded = _.get @state, "faded_fadeWrapper_#{frame.section}_#{i}"
      frameProps =
        key: i
        ref: "fadeWrapper_#{frame.section}_#{i}"
        products: frame.products
        version: frameVersion
        cssModifier: [
          "#{@BLOCK_CLASS}__fade-wrapper -two-column"
          if faded then "-faded-in" else "-not-yet-faded-in"
        ].join ' '

      <CollectionFrame {...frameProps} />

    <div className=classes.container>
      <div className=classes.block children=collectionFrames />
    </div>
