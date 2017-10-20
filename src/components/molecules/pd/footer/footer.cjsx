[
  _
  React

  Help

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/footer/help/help'

  require 'components/mixins/mixins'

  require './footer.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-pd-footer'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    cssModifier: ''
    cssUtility: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssUtility}
      #{@props.cssModifier}
      u-color-bg--light-gray-alt-2 u-mt48 u-pl24
      u-pr24 u-pt42 u-pb42 u-pt72--900 u-pb72--900
    "
    footer: 'u-w100p u-w11c--600 u-m0a u-df--600
      u-flexd--c--600 u-jc--sb--600 u-ai--c
      u-flexd--r--1200 u-tac
    '

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <div className=classes.footer>
        <Help {...@props} />
      </div>
    </div>
