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

  require './copy_box.scss'
]

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.analytics
  ]

  BLOCK_CLASS: 'c-landing-process-block-copy'

  getStaticClasses: ->
    block: @BLOCK_CLASS
    bodyCopy: '
      u-body-standard
      u-mb12
    '
    reset: "
      u-reset
      #{@BLOCK_CLASS}
    "
    list: "
      #{@BLOCK_CLASS}__list
      u-color--blue
      u-pr
    "
    bullet: "
      u-body-standard
      u-mb12
      u-color--light-gray
      #{@BLOCK_CLASS}__bullet
    "

  getCSSModifiers: ->
    reset:
      p: 'u-color--dark-gray-alt-3'
      a: 'u-fws u-bbw1 u-bbss u-bc--blue u-bbw0--900'
      strong: 'u-fwb'
      ul: 'u-mt18 u-mb18 u-pl48'
    bullet:
      li: 'u-color--light-gray'
      p: 'u-color--dark-gray-alt-3'
      a: 'u-fwb u-bbw1 u-bbss u-bc--blue u-bbw0--900'

  getDefaultProps: ->
    gaTarget: 'Process'

  getWPEvent: (id) ->
    "ProcessPage-Click-#{id}"

  handleClickLink: (e) ->
    #  Handle GA while allowing links in Markdown
    #  Crawl up the DOM, looking to see if we've clicked inside or on an anchor tag
    #  If we have, fire a WP event
    target = e.target
    until not target.parentNode? or target.tagName in ['BODY', 'A']
      target = target.parentNode
      if target.tagName is 'A' and target.href
        @trackInteraction(@getWPEvent(target.id))

  renderTextBlock: (copyBlock, i) ->
    cssModifiers = @getCSSModifiers()
    <Markdown
      key=i
      gaModifier={"#{_.camelCase @props.gaTarget}#{i}"}
      rawMarkdown=copyBlock.text
      className=@classes.bodyCopy
      handleClick=@handleClickLink
      cssModifiers=cssModifiers.reset
      cssBlock=@classes.reset />

  renderBullet: (bullet, i) ->
    cssModifiers = @getCSSModifiers()
    <Markdown
      tagName='li'
      key=i
      gaModifier={"#{_.camelCase @props.gaTarget}#{i}"}
      rawMarkdown=bullet
      className=@classes.bullet
      handleClick=@handleClickLink
      cssModifiers=cssModifiers.bullet
      cssBlock=@classes.reset />

  renderCopyBlock: (copyBlock={}, i) ->
    if copyBlock.copy_type is 'text_block'
      @renderTextBlock(copyBlock, i)
    else if copyBlock.copy_type is 'list'
      <ul className=@classes.list>
        {_.map copyBlock.bullets, @renderBullet}
      </ul>

  render: ->
    @classes = @getClasses()

    <div
      className=@classes.block
      onClick=@handleClickLink
      children={_.map @props, @renderCopyBlock} />
