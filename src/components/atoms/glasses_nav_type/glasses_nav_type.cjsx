[
  _
  React

  X

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/icons/x/x'

  require 'components/mixins/mixins'

  require './glasses_nav_type.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-glasses-nav-type'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    cssModifier: React.PropTypes.string
    handleClickClose: React.PropTypes.func
    handleClickOpen: React.PropTypes.func
    isExpanded: React.PropTypes.bool
    title: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''
    handleClickClose: ->
    handleClickOpen: ->
    isExpanded: false

  getInitialState: ->
    jsSupport: false

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-pr u-ps--600
      u-db u-dib--600
      u-mb48 u-mb0--600"
    open: "
      #{@BLOCK_CLASS}__open
      u-fs12 u-ffss
      u-link--nav
      u-w100p
      u-pr"
    openText:
      'u-pa
      u-t0
      u-center-x'
    list: "
      #{@BLOCK_CLASS}__list
      u-reset--list
      u-pa
      u-t0 u-r0 u-b0 u-l0
      u-vh
      u-color-bg--white
      u-tac
      u-w100p"
    item:
      "#{@BLOCK_CLASS}__item
      u-dib
      u-pr
      u-vam
      u-color-bg--white"
    link:
      "#{@BLOCK_CLASS}__link
      u-pa
      u-r0 u-b0 u-l0"
    variant:
      "#{@BLOCK_CLASS}__variant
      u-color--white u-color--dark-gray--600
      u-b0 u-ba--600
      u-ls0
      u-pa
      u-ttn
      u-center-x
      u-pen"
    preVariant:
      "#{@BLOCK_CLASS}__pre-variant
      u-dn u-dib--600
      u-vam--600"
    close:
      "#{@BLOCK_CLASS}__close
      u-dn
      u-m0a
      u-bw0
      u-link--nav
      u-fs12 u-ffss
      u-pa
      u-center-x"
    x:
      "#{@BLOCK_CLASS}__x
      u-m0a
      u-db"

  componentDidMount: ->
    @setState jsSupport: true

  bgImage: (props = @props) ->
    width = props.width or 420
    quality = props.quality or 70
    backgroundImage: "url(#{props.image}?quality=#{quality}&width=#{width})"

  handleClickOpen: (evt) ->
    @props.handleClickOpen evt
    @trackInteraction "#{@getInteractionCategory()}-click-#{@props.title}-on", evt

  handleClickClose: (evt) ->
    @props.handleClickClose evt

  renderGender: (classes, gender, index) ->
    style = if @props.isExpanded then @bgImage(gender) else {}
    <li className=classes.item style=style key=index>
      <a href=gender.route
        target=@props.linkTarget
        className=classes.link
        onClick={@clickInteraction.bind(@, _.camelCase("#{@props.title}-#{gender.title}"))}>
        <span className=classes.variant>
          <span className=classes.preVariant
            children=@props.pre /> {gender.title}
        </span>
      </a>
    </li>

  getOpenJsProps: ->
    if @state.jsSupport
      'aria-controls': @getListId()
      'aria-expanded': @props.isExpanded
      onClick: @handleClickOpen
    else
      {}

  getCloseJsProps: ->
    if @state.jsSupport
      'aria-controls': @getListId()
      'aria-expanded': @props.isExpanded
      onClick: @handleClickClose
    else
      {}

  getListId: ->
    "#{_.kebabCase @props.title}-nav"

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <button {...@getOpenJsProps()}
        className=classes.open
        ref='open'
        style=@bgImage()
        type='button'>
        <span children=@props.title
          className=classes.openText />
      </button>

      <ul className=classes.list id=@getListId()>
        { _.map @props.genders, @renderGender.bind(@, classes) }
      </ul>

      <button {...@getCloseJsProps()}
        className=classes.close
        type='button'>
        <X altText='' cssModifier=classes.x />
        View Categories
      </button>
    </div>
