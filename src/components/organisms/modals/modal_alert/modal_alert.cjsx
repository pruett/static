[
  _
  React

  LayoutDefault

  Confirm

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/molecules/modals/confirm/confirm'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-modal-alert'

  mixins: [
    Mixins.classes
  ]

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    heading:
      'u-reset u-fs30 u-ffs'

  getDefaultProps: ->
    children: ''
    txtHeading: ''
    txtConfirm: 'Okay'
    routeConfirm: '/'

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <Confirm {...@props}
        key='confirm'
        txtHeading=@props.txtHeading
        txtConfirm=@props.txtConfirm
        routeConfirm=@props.routeConfirm
        children=@props.children />
    </div>
