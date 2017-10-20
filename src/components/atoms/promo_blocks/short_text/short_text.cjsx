[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  mixins: [
    Mixins.classes
  ]

  getStaticClasses: ->
    block: 'u-mt0 u-mt12--600 u-mt0--900 u-mb30'

  classesWillUpdate: ->
    blockClasses = _.get(@props, 'text_styling.heading_font_class') or
      'u-ffs u-fws u-fs20 u-fs24--600 u-fs26--900 u-fs30--1200'

    block:
      "#{blockClasses}": true

  render: ->
    classes = @getClasses()

    <section>
      <h1 children=@props.title className=classes.block />
    </section>
