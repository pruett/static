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
  BLOCK_CLASS: 'c-appear-on-scroll'

  mixins: [
    Mixins.classes
    Mixins.scrolling
  ]

  getInitialState: ->
    entered: false

  componentDidMount: ->
    @addScrollListener @checkIfInViewport

    @checkIfInViewport()

  checkIfInViewport: ->
    if @refIsInViewport(@refs.appearOnScroll) and not @state.entered
      @setState entered: true

  getStaticClasses: ->
    block: "#{@BLOCK_CLASS}
      -transition-slide-up-fade-appear
      -force-visible-mobile"

  classesWillUpdate: ->
    block:
      '-transition-slide-up-fade-appear-active': @state.entered

  render: ->
    classes = @getClasses()

    <div
      ref='appearOnScroll'
      className=classes.block
      children=@props.children />
