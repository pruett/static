_ = require 'lodash'
React = require 'react/addons'
Mixins = require 'components/mixins/mixins'
IconHeart = require 'components/quanta/icons/heart/heart'

require './add_to_favorites.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-add-to-favorites'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    cssModifier: React.PropTypes.string
    iconModifier: React.PropTypes.string
    general_label: React.PropTypes.string
    success_label: React.PropTypes.string
    product_id: React.PropTypes.number
    isFavorited: React.PropTypes.bool

  getDefaultProps: ->
    cssModifier: ''
    iconModifier: ''
    label: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
    "
    button: "
      #{@BLOCK_CLASS}__button
      u-button-reset
      u-fill--white u-stroke--dark-gray-alt-2
    "
    icon: "
      #{@BLOCK_CLASS}__icon
    "
    label: "
      #{@BLOCK_CLASS}__label u-pl12 u-pr12 u-fwl
    "

  handleClick: ->
    @commandDispatcher 'favorites', 'toggleFavorite', @props.product_id

  render: ->
    classes = @getClasses()
    label = if @props.isFavorited then @props.success_label else @props.general_label

    <div className=classes.block>

      <button
        onClick=@handleClick
        className=classes.button>

        <IconHeart
          className=classes.icon
          cssModifier=@props.iconModifier
          active=@props.isFavorited />

        {if label
          <span className=classes.label children=label />}

      </button>

    </div>
