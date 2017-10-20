[
  _
  React
  Mixins
] = [
  require 'lodash'
  require 'react/addons'
  require 'components/mixins/mixins'

  require './do_good_nav.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-do-good-nav'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    omit: 'history'
    links:
      bapgap:
        href: "/buy-a-pair-give-a-pair"
        src: "/assets/img/legacy/our_story/nav/bpgp.png"
        title: 'Buy a Pair, Give a Pair'
        blurb: 'Making an impact'
      design:
        href: "/design"
        src: "/assets/img/legacy/our_story/nav/design.png"
        title: 'Design'
        blurb: 'From concept to construction'
      culture:
        href: "/culture"
        src: "/assets/img/legacy/our_story/nav/culture.png"
        title: 'Culture'
        blurb: 'Step into our office'
      history:
        href: "/history"
        src: "/assets/img/legacy/our_story/nav/history.png"
        title: 'History'
        blurb: 'Who, what, when, where, why'

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-btw1 u-bc--dark-gray u-btss
      u-mw960 u-ma u-pt12--900 u-pb12--900"
    link:
      'u-color--dark-gray
      u-db u-dib--900 u-w4c--900 u-vam u-ma
      u-pt24 u-pb24 u-tac
      u-btss u-bc--dark-gray
      u-btw1 u-btw0--900'
    wrapper:
      "#{@BLOCK_CLASS}__wrapper
      u-dib u-ma u-tal"
    img:
      "#{@BLOCK_CLASS}__img
      u-mr10 u-dib u-vam"
    copy:
      "#{@BLOCK_CLASS}__copy
      u-dib u-vam"
    title:
      'u-reset
      u-fs24 u-ffs u-fws u-mb3'
    blurb:
      'u-reset
      u-fs16 u-color u-color--dark-gray-alt-3'

  renderLink: (classes, link) ->
    <a className=classes.link href=link.href>
      <span className=classes.wrapper>
        <img src=link.src className=classes.img />
        <span className=classes.copy>
          <h2 className=classes.title children=link.title />
          <h3 className=classes.blurb children=link.blurb />
        </span>
      </span>
    </a>

  render: ->
    classes = @getClasses()
    links = _.omit @props.links, @props.omit
    <div className=classes.block
        children={_.map links, @renderLink.bind(@, classes)} />
