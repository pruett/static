[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './navigation.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-footer-navigation'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-list-reset"
    item:
      "#{@BLOCK_CLASS}__item"
    link: "
      #{@BLOCK_CLASS}__link
      u-reset u-fs12
      u-link--nav
    "

  render: ->
    classes = @getClasses()

    footer_navigation = @props.footer_navigation or {}

    <ul className=classes.block>
      {_.map footer_navigation.links, (link) =>
        <li className=classes.item key=link.title>
          <a href=link.route
            className=classes.link
            onClick={@clickInteraction.bind(@, link.title)}
            children=link.title />
        </li>
      }
    </ul>
