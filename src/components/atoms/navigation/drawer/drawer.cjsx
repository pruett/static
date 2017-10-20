[
  _
  React

  Link
  LeftLineArrow
  XIcon

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/link/link'
  require 'components/quanta/icons/left_line_arrow/left_line_arrow'
  require 'components/quanta/icons/x/x'

  require 'components/mixins/mixins'

  require './drawer.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-navigation-drawer'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
    Mixins.image
  ]

  propTypes:
    bannerActive: React.PropTypes.bool
    visibleNavSubList: React.PropTypes.string

  getDefaultProps: ->
    bannerActive: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-pr u-ps--900
      u-dib--900
      u-ma u-m0--900
      u-pt18
      u-vam--900
      #{@BLOCK_CLASS}--large u-ps u-db
    "
    listToggle: "
      #{@BLOCK_CLASS}__list-toggle
      u-fs12 u-ffss
      u-link--nav
      u-pa u-ps--900
      u-r0 u-b0 u-l0
      u-ta--900 u-la--900 u-ra--900 u-b0--900
      u-tac u-tal--900
      u-p0 u-pr8--900 u-pl8--900
      u-bw0
      u-w100p
      u-flexd--c
      u-ai--c
    "
    listContainer: "
      #{@BLOCK_CLASS}__list-container
      u-pf u-pa--900
      u-t0 u-b0 u-l0 u-r0
      u-vh
    "
    largeList: "
      #{@BLOCK_CLASS}__large-list
      u-list-reset
      u-df u-flexd--c u-flexd--r--900 u-ai--s--900 u-jc--sb--900
    "
    listHide: "
      #{@BLOCK_CLASS}__list-hide
      u-pa u-t0 u-l0 u-dn--900
      u-pt24 u-pb24 u-pl24 u-pr24
      u-bw0
    "
    button: "
      #{@BLOCK_CLASS}__button
      u-dn
    "
    linkLabelWrap: "
      #{@BLOCK_CLASS}__link-wrap
      u-pa u-center-y
      u-color--dark-gray
      u-la u-r0--900 u-mr18--900
    "
    linkLabel: "
      #{@BLOCK_CLASS}__link-label
      u-dib
      u-pb5
      u-bbw2 u-bbss u-bc--dark-gray
      u-bc--white-0p--900
    "
    pictureGlasses: "
      #{@BLOCK_CLASS}__picture--glasses
      u-pa
      u-r0 u-l0
      u-ma
      u-bgr--nr
      u-dn--900
    "
    link: "
      #{@BLOCK_CLASS}__link
      u-db u-pr u-color--dark-gray
      u-fws u-fs16 u-fs18--600
    "
    item: "
      #{@BLOCK_CLASS}__item
      u-pr u-w12c u-w6c--900
    "

  classesWillUpdate: ->
    block:
      '-visible': @isSubListVisible()
    list:
      '-banner': @props.bannerActive

  isSubListVisible: (props = @props) ->
    props.visibleNavSubList is @getId()

  renderLargeDrawerGender: (gender, index) ->
    <li className=@classes.item key=index>
      <a
        href=gender.route
        className=@classes.link
        style={{paddingBottom: "#{@props.aspectRatio}%"}}
        id={@getModelPictureId gender}
        onClick={@clickInteraction.bind(@, "#{@props.title}-#{gender.title}")}
      >
        <span className=@classes.linkLabelWrap>
          <span className=@classes.linkLabel children={"#{@props.pre} #{gender.title}"}/>
        </span>
      </a>
    </li>

  renderImageStyles: ->
    # Use these selectors to defer the loading of images until either the nav is
    # active or React mounts.
    container = "#{@BLOCK_CLASS}__list-container"
    imageWidth = 420

    imageLoadSelectors = [
      '.c-navigation__list.-visible'
      ".#{@BLOCK_CLASS}__list-toggle:focus:not([aria-expanded=false]) ~ .#{container}"
      ".#{@BLOCK_CLASS}.-visible .#{container}"
      '#navigation:target'
      '.react-mounted'
    ]

    <style dangerouslySetInnerHTML={__html: "
      #{imageLoadSelectors.map (selector) ->
        "#{selector} ##{@getGlassesPictureId()}"
      , @} {
        background-image: url(#{@props.image}?\
          quality=#{@props.quality or 70}&width=#{imageWidth});
      }

      #{@props.genders.map((gender, index) ->
        "
          #{imageLoadSelectors.map (selector) ->
            "#{selector} ##{@getModelPictureId gender}"
          , @} {
            background-image: url(#{gender.large.images.mobile}?\
              quality=#{gender.quality or 70}&width=#{gender.large.sizes.small});
          }
          @media (min-width: 600px) {
            #{imageLoadSelectors.map (selector) ->
              "#{selector} ##{@getModelPictureId gender}"
            , @} {
              background-image: url(#{gender.large.images.mobile}?\
                quality=#{gender.quality or 70}&width=#{gender.large.sizes.medium});
            }
          }
          @media (min-width: 900px) {
            #{imageLoadSelectors.map (selector) ->
              "#{selector} ##{@getModelPictureId gender}"
            , @} {
              background-image: url(#{gender.large.images.desktop}?\
                quality=#{gender.quality or 70}&width=#{gender.large.sizes.large});
            }
          }
        "
      , @).join ''}
    "} />

  getGlassesPictureId: ->
    "nav-glasses-picture--#{_.snakeCase @props.title}"

  getModelPictureId: (gender) ->
    "nav-model-picture--#{@props.title}-#{gender.title}"

  getListToggleJsProps: ->
    id = @getId()
    props = 'data-nav-id': id
    if @props.jsSupport
      _.assign props,
        'aria-controls': id
        'aria-expanded': @isSubListVisible()
        onClick: @handleClick
    else
      props

  handleClick: (evt) ->
    evt.preventDefault()

    subListId = @getId()
    isSubListVisible = @isSubListVisible()

    # Because this is contained in an off-canvas menu on smaller screens, when
    # clicking to close the menu on those screens, we don't want to hide the
    # navigation entirely, but just turn off the visibility of the sub-list. The
    # `showNavigation` command, with a null value for the `subListId`, achieves
    # this, so only use `hideNavigation` if we're on desktop and don't have a
    # value for `subListId` (the off link was clicked).
    action =
      if window.matchMedia('(min-width: 900px)').matches and isSubListVisible
        type: 'hide'
        id: null
        state: 'off'
      else
        type: 'show'
        id: if isSubListVisible then null else subListId
        state: 'on'

    @commandDispatcher 'layout', "#{action.type}Navigation", action.id

    @trackInteraction "#{@getInteractionCategory()}-click-\
      #{subListId}-#{action.state}"

    windowWidth = window.innerWidth or _.get(document, 'documentElement.clientWidth')

  handleKeyPress: (evt) ->
    # Allow users to activate A tag with spacebar.
    # A tag is used to take advantage of focus state before React mounts.
    # https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Techniques/Using_the_button_role#Keyboard_and_focus
    @handleClick(evt) if evt.key in [' ', 'Enter']

  getId: ->
    _.camelCase @props.title

  render: ->
    @classes = @getClasses()

    <div className=@classes.block>
      {@renderImageStyles()}

      <div className=@classes.pictureGlasses id=@getGlassesPictureId() />

      <a {...(@getListToggleJsProps())}
        children=@props.title
        className=@classes.listToggle
        onKeyPress=@handleKeyPress
        role="button"
        tabIndex="0" />

      <div className=@classes.listContainer id=@getId()>
        <button
          {...(@getListToggleJsProps())}
          children=@props.title
          className=@classes.listHide
          type='button'
        >
          <LeftLineArrow
            cssModifier='u-dib u-dn--900'
            cssUtility='u-stroke--dark-gray'
          />
        </button>

        <ul className=@classes.largeList style={{backgroundColor: @props.bgColor}}>
          {_.map @props.genders, @renderLargeDrawerGender }
        </ul>
      </div>

    </div>
