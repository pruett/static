[
  _
  React

  Markdown
  ExpandingFAQ
  DownArrow

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
  require 'components/molecules/expanding_faq/expanding_faq'
  require 'components/quanta/icons/down_arrow/down_arrow'

  require 'components/mixins/mixins'

  require './faq.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-checkout-faq'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    content: React.PropTypes.object

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    heading:
      'u-reset u-fs24 u-ffs u-fws u-mb12'
    subHeading:
      'u-reset u-fs20 u-fws u-mb24'
    contactOption:
      'u-reset u-fs16 u-mb24'
    contactMain:
      "#{@BLOCK_CLASS}__contact-main"
    contactLink:
      'u-reset u-fws'
    contactDetail:
      'u-reset u-color--dark-gray-alt-2'

  render: ->
    return false if _.isEmpty(@props.content)

    classes = @getClasses()

    <div className=classes.block>

      <h1 className=classes.heading
        children='Checkout FAQ' />

      <Markdown className=classes.subHeading
        cssBlock="#{@BLOCK_CLASS}__subheading"
        rawMarkdown=@props.content.contact_intro.heading />

      {_.map @props.content.contact_intro.contact_options, (option, i) ->
        <div className=classes.contactOption key=i>
          <Markdown cssBlock=classes.contactMain
            rawMarkdown=option.main_text />
          <span className=classes.contactDetail
            children=option.detail_text />
        </div>}

      <section>
        {_.map @props.content.faq_sections, (section, i, sections) ->
          <ExpandingFAQ key=i
            section=section
            isLast={sections.length - 1 is i} />
        }
      </section>
    </div>
