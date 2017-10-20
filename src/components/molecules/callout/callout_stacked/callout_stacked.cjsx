[
  _
  React

  Element

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/callout/callout_element/callout_element'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  # All elements stacked and centered horizontally.
  # No main image, everything in copy elements.
  # Copy elements set there own size using u-w{column_size}c

  BLOCK_CLASS: 'c-callout c-callout--stacked'

  mixins: [
    Mixins.callout
    Mixins.classes
  ]

  propTypes:
    elements: React.PropTypes.array
    analytics: React.PropTypes.object
    css_utilities_content: React.PropTypes.string
    css_utilities_callout: React.PropTypes.string

  getDefaultProps: ->
    elements: []
    analytics: {}
    css_utilities_content: ''
    css_utilities_callout: ''

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.css_utilities_callout or ''}"
    grid:
      'u-grid -maxed u-ma u-tac'
    row:
      'u-grid__row'
    col:
      'u-grid__col u-w12c'
    content:
      @props.css_utilities_content or ''

  renderElement: (props, index) ->
    <Element {...props}
      key=index
      index=index
      moduleName=@props.name
      typeIndex={@getTypeIndex(props.type, props)}
      analytics=@props.analytics />

  render: ->
    classes = @getClasses()
    style = if @props.border_color then borderColor: @props.border_color else {}

    <section className=classes.block>
      <div className=classes.grid>
        <div className=classes.row>
          <div className=classes.col>
            <div className=classes.content style=style>
              {_.map @props.elements, @renderElement}
            </div>
          </div>
        </div>
      </div>
    </section>
