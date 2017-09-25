[
  _
  React

  Markdown

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'

  require './plain_document.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-plain-document'

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
      u-reset u-fs24 u-fws u-ffs"
    body:
      "#{@BLOCK_CLASS}__body"
    section:
      "#{@BLOCK_CLASS}__section"
    sectionHeading:
      "#{@BLOCK_CLASS}__section-heading
      u-reset u-fs20 u-mb24 u-fws"
    sectionBody:
      "#{@BLOCK_CLASS}__section-body"

  render: ->
    return false unless @props.content

    content = @props.content

    classes = @getClasses()

    <div className=classes.block>
      {if content.header.body
        <Markdown className=classes.heading rawMarkdown=content.header.body />}

      {_.map content.sections, (section, i) ->
        <div key=i className=classes.section>
          <h2 className=classes.sectionHeading children=section.heading />

          <Markdown className=classes.sectionBody
            rawMarkdown=section.body />
        </div>}

      {if content.footer.body
        <Markdown className=classes.heading rawMarkdown=content.footer.body />}
    </div>
