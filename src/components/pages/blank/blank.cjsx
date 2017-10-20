[
  React

  LayoutBlank

  Mixins
] = [
  require 'react/addons'

  require 'components/layouts/layout_blank/layout_blank'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-blank-page'

  mixins: [
    Mixins.context
  ]

  render: ->
    <LayoutBlank {...@props}>
      <div className="#{@BLOCK_CLASS} u-tac">
        <p className='u-reset u-ffs -no-margin'>This page is intentionally left blank.</p>
      </div>
    </LayoutBlank>
