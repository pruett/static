React = require 'react/addons'
_ = require 'lodash'

Mixins = require 'components/mixins/mixins'

Markdown = require 'components/molecules/markdown/markdown'

Img = require 'components/atoms/images/img/img'

require './copy_box.scss'


module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.context
  ]

  BLOCK_CLASS: 'c-tyler-oakley-copy-box'

  componentDidMount: ->
    # Attach a scroll listener if we're on desktop
    @throttledScrollHandler = _.throttle @handleScroll, 100
    window.addEventListener 'scroll', @throttledScrollHandler

  componentWillUnmount: ->
    window.removeEventListener 'scroll', @throttledScrollHandler

  getInitialState: ->
    showCopy: 'one'

  handleScroll: ->
    ref = @refs.copyBlock
    el = React.findDOMNode(ref)
    @handleCopyStyles(el)

  handleCopyStyles: (el) ->
    # This flips a state boolean once the copy block has started to exit a user's viewport
    viewPortHeight = window.innerHeight or _.get(document, 'documentElement.clientHeight')

    # DOM el attributes to get percentage of El in viewport
    rect = el.getBoundingClientRect()
    scrollTop = rect.top
    elementHeight = el.clientHeight

    distance = viewPortHeight - scrollTop
    percentage = distance / (elementHeight / 100)

    if percentage > 110
      @setState showCopy: 'two'
    else if percentage < 110
      @setState showCopy: 'one'

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-color-bg--black
      u-mw1440 u-mla u-mra
      u-color--white
      u-fs24 u-fs36--1200
      u-tac
      u-fws
      u-mb60 u-mb36--600 u-mb120--900
    "
    copyWrapper: "
      #{@BLOCK_CLASS}__copy-wrapper
      u-pr
      u-h0
      u-pb-2x1--900
    "
    copyOne: "
      #{@BLOCK_CLASS}__copy
      u-pa u-t0 u-l0
      u-center
      u-w10c u-w9c--1200
      u-ffs
      u-lh34 u-lh36--900
    "
    copyTwo: "
      #{@BLOCK_CLASS}__copy
      u-pa u-t0 u-l0
      u-center
      u-w10c u-w9c--1200
      u-ffs
      u-lh34 u-lh36--900
    "
    buttonLeft: "
      #{@BLOCK_CLASS}__button
      u-dib
    "
    buttonRight: "
      #{@BLOCK_CLASS}__button
      u-dib
    "
    buttonsWrapper: '
      u-pa u-b0 u-center-x
      u-mb36 u-mb24--900 u-mb48--1200
    '
    markdown: '
      u-reset
    '

  classesWillUpdate: ->
    copyOne:
      '-show': @state.showCopy is 'one'
      '-hide': @state.showCopy isnt 'one'
    copyTwo:
      '-show': @state.showCopy is 'two'
      '-hide': @state.showCopy isnt 'two'
    buttonLeft:
      '-light': @state.showCopy is 'one'
      '-dark': @state.showCopy is 'two'
    buttonRight:
      '-dark': @state.showCopy is 'one'
      '-light': @state.showCopy is 'two'

  showCopy: (layer) ->
    @setState showCopy: layer

  getRegionalPricing: ->
    locale = @getLocale('country')
    _.get @props, "pricing_text[#{locale}]"

  render: ->
    classes = @getClasses()

    <div className=classes.block ref='copyBlock'>
      <div className=classes.copyWrapper>

        <div className=classes.copyOne ref='topParagraph'>
          <Markdown
            rawMarkdown=@props.copy_one
            className=classes.copy
            cssBlock=classes.markdown />
        </div>

        <div className=classes.copyTwo ref='bottomParagraph'>
          <Markdown
            rawMarkdown=@props.copy_two
            className=classes.copy
            cssBlock=classes.markdown />
          <p children=@getRegionalPricing() />
        </div>

        <div className=classes.buttonsWrapper>
          <div onClick={@showCopy.bind @, 'one'} className=classes.buttonLeft />
          <div onClick={@showCopy.bind @, 'two'} className=classes.buttonRight />
        </div>

      </div>
    </div>
