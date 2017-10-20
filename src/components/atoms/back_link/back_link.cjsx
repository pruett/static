[
  React

  LeftArrow
  RightArrow

  Mixins
] = [
  require 'react/addons'

  require 'components/quanta/icons/left_arrow/left_arrow'
  require 'components/quanta/icons/right_arrow/right_arrow'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-back-link'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    previousRoute: React.PropTypes.string
    backLinkText: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    backLinkText: 'Back'
    cssModifier: ''
    previousRoute: 'javascript:window.history.back()'
    version: 1

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-dib
    "
    arrow: '
      u-fill--dark-gray-alt-1
      u-mt1 u-mr8 u-ml4
    '
    arrow2: '
      u-tr180 u-fill--blue
      u-mt2 u-mr8
    '

  classesWillUpdate: ->
    block:
      'u-link--unstyled u-reset  u-fs12 u-ls2_5 u-ttu -margin
       u-color--dark-gray-alt-1': @props.version is 1
      'u-ffss u-fs14 u-fws u-mb24': @props.version is 2

  render: ->
    classes = @getClasses()

    <a className=classes.block href=@props.previousRoute>

      {if @props.version is 1
        <LeftArrow cssVariation=classes.arrow />
      else
        <RightArrow cssVariation=classes.arrow2 />}

      {@props.backLinkText}
    </a>
