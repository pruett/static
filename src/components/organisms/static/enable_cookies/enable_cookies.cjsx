[
  _
  React

  Markdown
  ExpandingFAQ

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
  require 'components/molecules/expanding_faq/expanding_faq'

  require 'components/mixins/mixins'

  require './enable_cookies.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-enable-cookies'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    content: React.PropTypes.object

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    heading:
      "#{@BLOCK_CLASS}__heading
      u-reset u-fs24 u-mb12 u-fws u-ffs"
    subHeading:
      'u-reset u-fs24 u-mb12'
    hr:
      "#{@BLOCK_CLASS}__hr
      u-hr -three -dark"
    faqHeading:
      "#{@BLOCK_CLASS}__section-heading
      u-reset u-fs20 u-mb24 u-fws"

  render: ->
    return false unless @props.content

    content = @props.content

    classes = @getClasses()

    <div className=classes.block>
      <h1 className=classes.heading children=content.header.title />

      <Markdown className=classes.subHeading
        rawMarkdown=content.header.description />

      <hr className=classes.hr />

      <section>
        <h2 className=classes.faqHeading children=content.faq_header.title />

        {_.map @props.content.section_faqs, (section, i) ->
          <ExpandingFAQ key=i section=section />}
      </section>
    </div>
