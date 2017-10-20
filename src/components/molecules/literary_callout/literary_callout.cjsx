[
  React

  Mixins
] = [
  require 'react/addons'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-literary-callout'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    label: React.PropTypes.string
    headline: React.PropTypes.string
    copy: React.PropTypes.string
    photoV2Enabled: React.PropTypes.bool

  getDefaultProps: ->
    label: ''
    headline: ''
    copy: ''
    photoV2Enabled: false

  getStaticClasses: ->
    block: '
      u-color-bg--light-gray-alt-2
      u-tac u-pt48 u-pb48 u-mb72
    '
    label: '
      u-grid__col u-w12c -c-8--600
      u-mla u-mra
      u-reset  u-fs12 u-ls2_5 u-ttu u-ffss u-fws
      u-ttu u-tac u-mb24
    '
    headline: '
      u-grid__col -c-8
      u-mla u-mra
      u-reset u-fs20 u-fs24--600 u-fs30--1200
      u-ffs u-fws u-mb24
    '
    copy: '
      u-grid__col -c-10 -c-8--900 -c-6--1200
      u-mla u-mra
      u-reset u-fs16 u-fs18--900 u-fwl u-ffss
      u-color--dark-gray
    '

  classesWillUpdate: ->
    block:
      'u-mt72': not @props.photoV2Enabled
      'u-mt24 u-mt12--900': @props.photoV2Enabled

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <div children=@props.label className=classes.label />
      <div children=@props.headline className=classes.headline />
      <div children=@props.copy className=classes.copy />
    </div>
