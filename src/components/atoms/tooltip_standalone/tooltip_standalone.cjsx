[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './tooltip_standalone.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-tooltip-standalone'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    cssModifier: ''

  getInitialState: ->
    isOpen: false

  componentDidMount: ->
    document.addEventListener 'click', @handleClickDocument
    _.delay (-> @setState isOpen: true).bind(@), 500

  componentWillUnmount: ->
    document.removeEventListener 'click', @handleClickDocument

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-color-bg--white
      u-bw1 u-bss u-bc--dark-gray-alt-2
      u-mt12
    "
    contentWrapper: "
      #{@BLOCK_CLASS}__content-wrapper
      u-oh
    "
    contents: '
      u-pt12 u-pb12
      u-pl18 u-pr18
    '

  classesWillUpdate: ->
    block:
      '-open': @state.isOpen
    contentWrapper:
      '-open': @state.isOpen

  handleClickDocument: (evt) ->
    container = React.findDOMNode @refs.container
    if container and not container.contains evt.target
      @setState isOpen: false

  render: ->
    classes = @getClasses()

    <div className=classes.block ref='container'>
      <div className=classes.contentWrapper>
        <div className=classes.contents children=@props.children />
      </div>
    </div>
