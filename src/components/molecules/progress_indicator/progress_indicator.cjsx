[
  React

  Link

  Mixins
] = [
  require 'react/addons'

  require 'components/atoms/link/link'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-progress-indicator-v2'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    steps: React.PropTypes.arrayOf React.PropTypes.object

  getDefaultProps: ->
    steps: []

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-tac u-mb24
    "
    active:'
      u-fs14 u-fws
      u-link--unstyled
      u-color--dark-gray
      u-pb2
      u-bbss u-bw2
    '
    complete: '
      u-fs14 u-fws
    '
    disabled: '
      u-fs14 u-fwn
      u-pen u-dib
      u-color--dark-gray-alt-2
    '

  renderStep: (step, i) ->
    classes = unless step.enabled
      @classes.disabled
    else if step.active
      @classes.active
    else
      @classes.complete

    classes = [
      classes
      'u-mr42' if i isnt @props.steps.length - 1
    ].join ' '

    <Link key=i
      href=step.route
      className=classes
      children=step.title
      onClick={@trackInteraction.bind @, "checkout-click-navStep#{step.title}"} />

  render: ->
    return false if @props.steps.length is 0

    @classes = @getClasses()

    <nav className=@classes.block
      children={@props.steps.map @renderStep} />
