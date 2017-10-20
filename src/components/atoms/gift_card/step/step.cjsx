[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './step.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-gift-card-step'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    label: React.PropTypes.string
    headline: React.PropTypes.string
    subhead: React.PropTypes.string

  getDefaultProps: ->
    id: ''
    content: ''
    label: ''
    headline: ''
    subhead: ''
    cssModifier: ''
    cssModifierContent: ''
    cssModifierChildren: ''

  getStaticClasses: ->
    variation = "-#{_.kebabCase @props.content}"
    variation = "#{variation}--#{_.kebabCase @props.id}" if @props.id

    block: "
      #{@BLOCK_CLASS} #{variation}
      #{@props.cssModifier}
      u-pr
      u-tac
      u-w100p
      u-ma
    "
    content: "
      #{@BLOCK_CLASS}__content
      u-dib
      u-w100p
      u-vam
    "
    label: "
      #{@BLOCK_CLASS}__label
      u-fs12 u-ffss
      u-ls2_5
      u-ttu
      u-color--blue
      u-m0
    "
    headline: "
      #{@BLOCK_CLASS}__headline
      u-heading-md
      u-mt12
      u-mt24--600 u-mt48--1200
    "
    subhead: "
      #{@BLOCK_CLASS}__subhead
      u-reset
      u-body-standard
      u-ma
      u-mb24 u-mb36--600 u-mb48--1200
      u-w10c u-w3c--900
    "
    children: "
      #{@props.cssModifierChildren}
    "

  classesWillUpdate: ->
    children:
      'u-h100p': @props.content is 'hero'
    headline:
      'u-mb18': @props.subhead?
      'u-mb48': not @props.subhead?
    content:
      'u-grid -maxed u-pt84 u-pb84 u-ma': @props.content isnt 'hero'

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <div className=classes.content>
        {if @props.label
          <h6 className=classes.label children=@props.label />}
        {if @props.headline
          <h2 className=classes.headline children=@props.headline />}
        {if @props.subhead
          <h4 className=classes.subhead children=@props.subhead />}
        {if @props.children
          <div className=classes.children children=@props.children />}
      </div>
    </div>
