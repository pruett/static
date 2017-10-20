[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'
  require 'components/mixins/mixins'

  require './step_number.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-step-number'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    number: React.PropTypes.number

  getDefaultProps: ->
    number: 1

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-dib
      u-mb12"
    circle:"
      #{@BLOCK_CLASS}__circle
      u-pr
      u-color--blue
      u-color-bg--white
      u-mt6
      "
    number: "
      #{@BLOCK_CLASS}__number
      u-color--blue
      u-reset u-fs14 u-fws u-mb8
      u-mt1
      u-center
      u-tac
      u-pa"

  render: ->
    classes = @getClasses()
    <div className=classes.block>
      <div className={classes.circle}>
        <span className=classes.number children=@props.number />
      </div>
    </div>
