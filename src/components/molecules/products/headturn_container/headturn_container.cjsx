[
  _
  React

  Headturn

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/headturn/headturn'

  require 'components/mixins/mixins'

  require './headturn_container.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-product-headturn-container'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    alt: React.PropTypes.string
    analyticsCategory: React.PropTypes.string
    cssModifier: React.PropTypes.string
    urls: React.PropTypes.array

  getDefaultProps: ->
    alt: ''
    analyticsCategory: ''
    cssModifier: ''
    urls: []

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS} #{@props.cssModifier}
      u-w12c u-ma
      u-ord1 u-mw1440"

  classesWillUpdate: ->
    block:
      '-empty': @isEmpty()

  isEmpty: ->
    _.isEmpty(@props.urls)

  render: ->
    classes = @getClasses()

    <section className=classes.block>
      {unless @isEmpty()
        <Headturn
          alt=@props.alt
          analyticsSlug="#{@props.analyticsCategory}-hover-headturn"
          cssModifier=classes.image
          srcs=@props.urls />
      }
    </section>
