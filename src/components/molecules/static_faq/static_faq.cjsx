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

  require './static_faq.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-static-faq'

  mixins: [
    Mixins.classes
    Mixins.scrolling
  ]

  propTypes:
    section: React.PropTypes.object

  getDefaultProps: ->
    section: {}

  componentDidMount: ->

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-pr
      u-tal
      u-grid -maxed
      u-m0a"
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
    body:
      'u-db'
    block:
      "#{@BLOCK_CLASS}__section-#{@props.section.section_id}":
        @props.section.section_id
      '-last': @props.isLast

  render: ->
    classes = @getClasses()
    sectionId = @props.section.section_id
    contentId = "#{sectionId}-content"

    <section className=classes.block id=sectionId>
      <div className=classes.body
        id=contentId>
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
