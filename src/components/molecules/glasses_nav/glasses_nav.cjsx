[
  _
  React

  GlassesNavType

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/glasses_nav_type/glasses_nav_type'

  require 'components/mixins/mixins'

  require './glasses_nav.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-glasses-nav'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    glasses: React.PropTypes.array
    linkTarget: React.PropTypes.string

  getDefaultProps: ->
    glasses: []
    linkTarget: null

  getInitialState: ->
    expandedIndex: null

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-pr
      u-mt60 u-mra u-mb60 u-mla"

  handleClickClose: (index, evt) ->
    @trackInteraction "#{@getInteractionCategory()}-click-viewCategories"
    @setState expandedIndex: @getNextExpandedIndex index

  handleClickOpen: (index, evt) ->
    @setState expandedIndex: @getNextExpandedIndex index

  getNextExpandedIndex: (toggledIndex) ->
    if toggledIndex is @state.expandedIndex
      null
    else
      toggledIndex

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      {_.map @props.glasses, (glasses, index) =>
        <GlassesNavType {...glasses}
          handleClickClose={@handleClickClose.bind(@, index)}
          handleClickOpen={@handleClickOpen.bind(@, index)}
          isExpanded={index is @state.expandedIndex}
          linkTarget=@props.linkTarget
          key=index />
      }
    </div>
