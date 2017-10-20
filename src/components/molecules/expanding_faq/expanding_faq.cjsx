[
  _
  React

  Markdown
  DownArrow

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
  require 'components/quanta/icons/down_arrow/down_arrow'

  require 'components/mixins/mixins'

  require './expanding_faq.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-expanding-faq'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.scrolling
  ]

  propTypes:
    section: React.PropTypes.object

  getDefaultProps: ->
    section: {}

  getInitialState: ->
    isOpen: false

  componentWillMount: ->
    unless typeof window is 'undefined'
      hash = @getHash()
      @setState isOpen: hash.startsWith(@props.section.section_id)

  componentDidMount: ->
    @scrollToNode @refs[@getHash()].getDOMNode() if @state.isOpen

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-pr
      u-tal"
    toggle:
      "#{@BLOCK_CLASS}__toggle
      u-w100p
      u-tal
      u-pr
      u-pt24 u-pt30--900
      u-pr0 u-pl24--900
      u-pb24 u-pb30--900
      u-pl0 u-pr24--900
      u-bss u-bw0 u-brw1--900 u-blw1--900 u-bc--white
      u-ffs u-fs20 u-fwn"
    heading:
      'u-fws u-ffss u-fs18 u-fs20--600 u-fs22--900 u-m0'
    statusIndicator:
      'u-sign -w16
      u-pa u-r0
      u-center-y
      u-mr6 u-mr36--900'
    intro:
      'u-ffss u-fs16 u-mb24'
    body:
      'u-oh
      u-pr24--900 u-pl24--900'
    questionBlock:
      "#{@BLOCK_CLASS}__question"
    question:
      "#{@BLOCK_CLASS}__question
      u-ffss u-fs16 u-fws"
    answer:
      "#{@BLOCK_CLASS}__answer
      u-ffss u-fs16 u-mb24"

  classesWillUpdate: ->
    statusIndicator:
      '-minus u-color--dark-gray-alt-3': @state.isOpen
      '-plus u-color--light-gray': not @state.isOpen
    body:
      'u-dn': not @state.isOpen
      'u-db': @state.isOpen
    block:
      "#{@BLOCK_CLASS}__section-#{@props.section.section_id}":
        @props.section.section_id
      '-last': @props.isLast

  handleToggleClick: (evt) ->
    evt.preventDefault()
    @setState isOpen: not @state.isOpen
    @trackInteraction "faqSection-click-#{_.camelCase @getSectionId()}-\
      #{if @state.isOpen then 'close' else 'open'}"

  handleContentClick: (evt) ->
    target = evt.target
    until target is evt.currentTarget or target.tagName is 'A'
      target = target.parentNode

    {href, tagName} = target
    if href and tagName is 'A'
      @trackInteraction "faqSectionLink-click-\
        #{_.camelCase @getSectionId()}-#{href}"

  getHash: ->
    _.get(window, 'location.hash', '').slice(1)

  getSectionId: ->
    @props.section.section_id

  render: ->
    classes = @getClasses()
    sectionId = @getSectionId()
    contentId = "#{sectionId}-content"

    <section className=classes.block id=sectionId>
      <button type='button'
        aria-controls=contentId
        aria-expanded=@state.isOpen
        className=classes.toggle
        onClick=@handleToggleClick>
        <Markdown cssModifiers={
            p: classes.heading
            h2: classes.heading
          }
          rawMarkdown=@props.section.section_title />
        <span className=classes.statusIndicator />
      </button>

      <div className=classes.body
        aria-hidden={not @state.isOpen}
        id=contentId
        onClick=@handleContentClick>
        {if @props.section.section_intro
          <Markdown className=classes.intro
            rawMarkdown=@props.section.section_intro />}

        {_.map @props.section.section_faqs, (faq, i) ->
          questionRef = if sectionId then "#{sectionId}-#{i+1}" else ''
          [
            <Markdown className=classes.question
              cssBlock=classes.questionBlock
              rawMarkdown=faq.question
              ref=questionRef />
            <Markdown className=classes.answer
              rawMarkdown=faq.answer />
          ]}
      </div>
    </section>
