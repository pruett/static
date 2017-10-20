[
  _
  React

  Element
  Video
  Picture
  Labels

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/callout/callout_element/callout_element'
  require 'components/molecules/callout/callout_video/callout_video'
  require 'components/atoms/images/picture/picture'
  require 'components/atoms/callout/labels/labels'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  # All elements stacked and centered horizontally till 900px.
  # At 900px, the main picture goes behind the copy.
  # At 900px, the copy is positioned to the left
  # At 900px w/ flip, the copy is positioned right.

  BLOCK_CLASS: 'c-callout c-callout--overlap'

  mixins: [
    Mixins.callout
    Mixins.classes
    Mixins.image
  ]

  propTypes:
    elements: React.PropTypes.array
    picture: React.PropTypes.object
    analytics: React.PropTypes.object
    css_utilities: React.PropTypes.string
    flip: React.PropTypes.bool
    copy_cols_900: React.PropTypes.number
    copy_cols_1200: React.PropTypes.number
    css_utilities_content: React.PropTypes.string
    css_utilities_callout: React.PropTypes.string
    center_copy: React.PropTypes.bool
    css_utilities_copy: React.PropTypes.string

  getDefaultProps: ->
    elements: []
    labels: []
    picture: {}
    analytics: {}
    flip: false
    copy_cols_900: 4
    copy_cols_1200: 4
    css_utilities_content: ''
    css_utilities_callout: ''
    css_utilities_copy: ''
    center_copy: false

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.css_utilities_callout or ''}"
    wrapper:
      'u-pr u-h0--900 u-pb2x1--900'
    copyGrid:
      'u-grid -maxed u-ma'
    copyRow:
      'u-grid__row'
    copyCol:
      "u-grid__col u-w12c u-tac
      u-mb0--900
      #{@props.css_utilities_copy or ''}
      u-w#{@props.copy_cols_900}c--900
      u-w#{@props.copy_cols_1200}c--1200"
    callout:
      'u-ma u-mw1440 u-oh'
    copy:
      'u-pa--900 u-t50p--900 u-ttyn50--900
      u-l0--900 u-r0--900 u-ma--900 u-w100p--900'
    picture:
      'u-db u-oh u-pr
      u-pa--900 u-l0--900
      u-w100p u-h0
      u-pb5x4 u-pb3x2--600 u-pb2x1--900'
    content:
      @props.css_utilities_content or
        'u-pt36 u-pt0--900 u-pb48 u-pb0--900'
    pictureWrapper: '
      u-pr u-ps--900
    '

  classesWillUpdate: ->
    copyRow:
      'u-tac': @props.center_copy
      'u-tal': not @props.center_copy
    copyCol:
      "u-pr u-l#{12 - @props.copy_cols_900}c--900
       u-l#{12 - @props.copy_cols_1200}c--1200": @props.flip

  mapSize: (size) ->
    image = _.find _.get(@props, 'picture.images'), size: size.name

    return size unless image
    switch size.name
      when 'desktop-hd'
        image.widths = _.range 1200, 1800, 100
        image.mediaQuery = '(min-width: 1200px)'
        image.sizes = '(min-width: 1440px) 1440px, 100vw'
      when 'desktop-sd'
        image.widths = _.range 900, 1800, 100
        image.mediaQuery = '(min-width: 900px)'
        image.sizes = '(min-width: 1440px) 1440px, 100vw'
      when 'tablet'
        image.widths = _.range 600, 900, 100
        image.mediaQuery = '(min-width: 600px)'
        image.sizes = '100vw'
      else
        image.widths = _.range 300, 600, 100
        image.mediaQuery = '(min-width: 0)'
        image.sizes = '100vw'
    image

  renderElement: (props, index) ->
    <Element {...props}
      key=index
      index=index
      moduleName=@props.name
      typeIndex={@getTypeIndex(props.type, props)}
      analytics=@props.analytics />

  render: ->
    classes = @getClasses()
    style = if @props.border_color then borderColor: @props.border_color else {}
    fallbackAlt = _.lowerCase(@props.name)
    alt = _.get(@props, 'picture.alt') || fallbackAlt
    showVideos = Boolean(_.get(@props, 'videos[0].url'))
    showLabels = _.get(@props, 'labels.show_labels', false)

    <section className=classes.block>
      <div className=classes.callout>
        <div className=classes.wrapper>

          <div className=classes.pictureWrapper>
            <Picture
              cssModifier=classes.picture
              children={@getPictureChildren(
                sources: @SIZES.map @mapSize
                img:
                  className: 'u-db u-w100p'
                  alt: alt
              )}/>
            {<Video {...@props} /> if showVideos}
            {<Labels {...@props.labels} /> if showLabels}
          </div>

          <div className=classes.copy>
            <div className=classes.copyGrid>
              <div className=classes.copyRow>
                <div className=classes.copyCol>
                  <div className=classes.content style=style>
                    {_.map @props.elements, @renderElement}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
