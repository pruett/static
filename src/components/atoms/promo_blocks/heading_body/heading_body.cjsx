[
  _
  React

  Markdown

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-promo-block-heading-body'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    name: React.PropTypes.string
    title: React.PropTypes.string
    body_text: React.PropTypes.string
    position: React.PropTypes.number

  getStaticClasses: ->
    heading: 'u-mt0 u-mb12'
    markdown: 'u-mla u-mb36 u-mra
      u-w8c--900'
    body: "#{@BLOCK_CLASS}__body"

  classesWillUpdate: ->
    headingClasses = @props.heading_font_class or
      'u-ffs u-fws u-fs20 u-fs24--600 u-fs26--900 u-fs30--1200'
    markdownClasses = _.get(@props, 'text_styling.body_font_class') or 'u-ffss u-fs16 u-fs18--900'

    heading:
      "#{headingClasses}": true
    markdown:
      "#{markdownClasses}": true

  handleClick: (evt) ->
    # We track this both as a promotionClick and a generic wp.event
    @commandDispatcher 'analytics', 'pushPromoEvent',
      type: 'promotionClick'
      promos: @props

    @trackInteraction "promo-click-#{_.camelCase (@props.name or 'headingBody')}", evt

  render: ->
    classes = @getClasses()

    <section>
      <h1 children=@props.title
        className=classes.heading
        key='heading' />
      <Markdown cssBlock=classes.body
        cssModifiers={
          p: 'u-m0'
          a: 'u-fws'
        }
        className=classes.markdown
        key='body'
        handleClick=@handleClick
        rawMarkdown=@props.body_text  />
    </section>
