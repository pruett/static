[
  _
  React

  IconX

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/x/x'

  require 'components/mixins/mixins'

  require './takeover.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-modal-takeover'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    active: React.PropTypes.bool
    children: React.PropTypes.node
    cssModifier: React.PropTypes.string
    hasHeader: React.PropTypes.bool
    title: React.PropTypes.string
    manageClose: React.PropTypes.func
    verticallyCenter: React.PropTypes.bool

  getDefaultProps: ->
    active: false
    analyticsSlug: 'page-close-takeover'
    children: ''
    cssModifier: 'u-color-bg--white'
    hasHeader: true
    hasHeaderRule: true
    pageHeader: false
    title: ''
    manageClose: ->
    transitionAppear: true

  getStaticClasses: ->
    block:"
      #{@BLOCK_CLASS}
      #{@props.cssModifier or ''}
    "
    headerWrapper: "
      #{@BLOCK_CLASS}__header-wrapper
    "
    header: "
      #{@BLOCK_CLASS}__header
    "
    title: "
      #{@BLOCK_CLASS}__title
    "
    close: "
      #{@BLOCK_CLASS}__close
      u-button-reset
    "
    iconX: "
      #{@BLOCK_CLASS}__icon-x
    "
    contentWrapper: "
      #{@BLOCK_CLASS}__content-wrapper
    "
    content: "
      #{@BLOCK_CLASS}__content
    "

  classesWillUpdate: ->
    contentWrapper:
      '-full': not @props.hasHeader
    content:
      '-centered': @props.verticallyCenter

  componentDidMount: ->
    @commandDispatcher('layout', 'showTakeover', @props.pageHeader) if @props.active

  componentDidUpdate: ->
    @commandDispatcher('layout', 'showTakeover', @props.pageHeader) if @props.active

  handleClose: (event) ->
    @commandDispatcher 'layout', 'hideTakeover'
    @trackInteraction @props.analyticsSlug, event
    @props.manageClose event

  render: ->
    classes = @getClasses()

    <ReactCSSTransitionGroup
      transitionName='-transition-fade'
      transitionAppear=@props.transitionAppear>
      {if @props.active
        <div className=classes.block key='takeover'>
          {if @props.hasHeader
            <div className=classes.headerWrapper>
              <div className=classes.header>
                <h2 className=classes.title children=@props.title />
                <button className=classes.close onClick=@handleClose>
                  <IconX cssModifier=classes.iconX />
                </button>
              </div>
            </div>}
          <div className=classes.contentWrapper>
            <div className=classes.content children=@props.children />
          </div>
        </div>}
    </ReactCSSTransitionGroup>
