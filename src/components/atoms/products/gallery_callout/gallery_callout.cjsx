[
  React

  IconStaffPickVertical

  Mixins
] = [
  require 'react/addons'

  require 'components/quanta/icons/staff_pick_vertical/staff_pick_vertical'

  require 'components/mixins/mixins'

  require './gallery_callout.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-gallery-callout'

  mixins: [
    Mixins.classes
  ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-pa u-l0 u-grid__col
    "

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <IconStaffPickVertical />
    </div>
