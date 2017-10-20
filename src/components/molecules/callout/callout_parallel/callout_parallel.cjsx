[
  _
  React

  Element
  Picture

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/callout/callout_element/callout_element'
  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  # All elements stacked and centered horizontally till 900px.
  # At 900px, the main picture and copy are horizontally aligned.

  BLOCK_CLASS: 'c-callout c-callout--parallel'

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

  getDefaultProps: ->
    elements: []
    picture: {}
    analytics: {}
    flip: false
    className: ''
    copy_cols_900: 4
    copy_cols_1200: 4
    css_utilities_content: ''
    css_utilities_callout: ''

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.css_utilities_callout or
        'u-pt48 u-pt60--600 u-pt72--900 u-pt84--1200
        u-pb48 u-pb60--600 u-pb72--900 u-pb84--1200 '}"
    calloutGrid:
      'u-grid -maxed u-ma u-tac u-tal--900'
    calloutRow:
      'u-grid__row'
    calloutColPicture:
      "u-grid__col u-w12c -col-middle u-tac
      u-w#{12 - @props.copy_cols_900}c--900
      u-w#{12 - @props.copy_cols_1200}c--1200"
    calloutColCopy:
      "u-tac
      u-grid__col u-w12c -col-middle
      u-w#{@props.copy_cols_900}c--900
      u-w#{@props.copy_cols_1200}c--1200"
    callout:
      'u-ma
      u-mw1440
      u-oh'
    picture:
      'u-db u-oh u-pr u-w100p u-h0 u-pb3x2'
    image:
      'u-db u-w100p'
    content:
      @props.css_utilities_content or
        'u-pt36 u-pt0--900'

  classesWillUpdate: ->
    calloutColPicture:
      "u-pr u-l#{@props.copy_cols_900}c--900": @props.flip
    calloutColCopy:
      "u-pr u-r#{12 - @props.copy_cols_900}c--900": @props.flip

  getSources: ->
    # Only one image required.
    image = _.get @props, 'picture.images[0]', {}
    sources = [
      widths: _.range 720, 1300, 150
      mediaQuery: '(min-width: 1200px)'
      sizes: '(min-width: 1440px) 824px, 60vw'
    ,
      widths: _.range 540, 1100, 100
      mediaQuery: '(min-width: 900px)'
      sizes: '60vw'
    ,
      widths: _.range 480, 1000, 100
      mediaQuery: '(min-width: 600px)'
      sizes: '88vw'
    ,
      widths: _.range 300, 600, 100
      mediaQuery: '(min-width: 0)'
      sizes: '(min-width: 360px) 360px, 100vw'
    ]

    sources.map (source) ->
      source.url = image.url
      source.quality = source.quality
      source

  renderElement: (props, index) ->
    <Element {...props}
      key=index
      index=index
      elements=@props.elements
      moduleName=@props.name
      typeIndex={@getTypeIndex(props.type, props)}
      analytics=@props.analytics />

  render: ->
    classes = @getClasses()
    style = if @props.border_color then borderColor: @props.border_color else {}
    fallbackAlt = _.lowerCase(@props.name)
    alt = _.get(@props, 'picture.alt') || fallbackAlt

    <section className=classes.block>
      <div className=classes.callout>
        <div className=classes.calloutGrid>
          <div className=classes.calloutRow>
            <div className=classes.calloutColPicture>
              <Picture
                cssModifier=classes.picture
                children={@getPictureChildren(
                  sources: @getSources()
                  img:
                    className: 'u-db u-w100p'
                    alt: alt
                )}/>
            </div>
            <div className=classes.calloutColCopy>
              <div className=classes.content style=style>
                {_.map @props.elements, @renderElement }
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
