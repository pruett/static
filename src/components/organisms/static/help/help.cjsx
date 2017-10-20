[
  _
  React

  Picture
  Markdown
  ExpandingFAQ
  ContactLinks

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/picture/picture'
  require 'components/molecules/markdown/markdown'
  require 'components/molecules/expanding_faq/expanding_faq'
  require 'components/atoms/contact_links/contact_links'

  require 'components/mixins/mixins'

  require './help.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-help'

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.image
  ]

  propTypes:
    content: React.PropTypes.object

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-m0a
      u-oh"
    hero:
      "#{@BLOCK_CLASS}__hero
      u-mra u-mb36 u-mb54--600 u-mb72--900 u-mla
      u-h0
      u-pb4x3
      u-db"
    body:
      "#{@BLOCK_CLASS}__body
      u-grid -maxed
      u-m0a"
    bodyRow:
      'u-grid__row -center'
    bodyCol:
      'u-grid__col u-w12c u-w10c--1200'
    headingText:
      'u-fs24 u-fs30--600 u-fs--900
      u-ffs u-fws
      u-mra u-mb12 u-mb24--600 u-mla'
    flashMsgContainer:
      'u-fws u-ffss
      u-fs16 u-fs18--900
      u-w8c--600
      u-mra u-mb24 u-mla'
    flashMsg:
      'u-di'
    bodyText:
      'u-fs16 u-fs18--900
      u-ffss
      u-w8c--600
      u-m0a
      u-mb24 u-mb54--600 u-mb60--900'

  render: ->
    return false if _.isEmpty @props.content

    classes = @getClasses()

    heroChildrenOptions = _.assign {}, _.get(@props, 'content.hero')
    _.set heroChildrenOptions, 'img.className', 'u-w100p'

    flashMsg = _.get @props, 'content.header.flash_msg'

    <div className=classes.block>
      <Picture cssModifier=classes.hero
        children={@getPictureChildren heroChildrenOptions} />

      <section className=classes.body>
        <div className=classes.bodyRow>
          <div className=classes.bodyCol>
            <h1 className=classes.headingText
              children={_.get @props, 'content.header.heading'} />

            {if _.get(@props, 'content.header.flash_msg_active') and flashMsg
              <div className=classes.flashMsgContainer>
                <Markdown className=classes.flashMsg
                  cssModifiers={p: 'u-di u-fs16 u-fs18--900'}
                  rawMarkdown=flashMsg />
              </div>
            }

            <Markdown className=classes.bodyText
              cssModifiers={p: 'u-fs16 u-fs18--900'}
              rawMarkdown={_.get @props, 'content.header.body'} />

            <ContactLinks links={_.get @props, 'content.contact_links'} />

            {_.get(@props, 'content.help_topics', []).map (topic, i, topics) ->
              section =
                section_id:    topic.tab_id
                section_title: topic.topic
                section_faqs:  topic.q_and_a

              <ExpandingFAQ key=i
                section=section
                isLast={topics.length - 1 is i} />
            }
          </div>
        </div>
      </section>
    </div>
