[
  React

  Mixins
] = [
  require 'react/addons'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    text: 'Free shipping and free returns'

  getStaticClasses: ->
    block: '
      u-flex--none
      u-color-bg--dark-gray-alt-4
    '
    text: '
      u-m0 u-p7
      u-fs14 u-fws
      u-tac
      u-color--white
    '

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <p className=classes.text children=@props.text />
    </div>
