[
  _
  React

  IconAdd
  IconAlert
  IconBurger
  IconCheckmark
  IconSuccessCheck
  IconClear
  IconDelete
  IconEdit
  IconI
  IconInfo
  IconDownArrow
  IconLeftArrow
  IconLeftArrowLarge
  IconRightArrow
  IconRightArrowLarge
  IconSearch
  IconX
  IconFilter
  IconHeart
  IconCart
  IconMenu
]=[
  require 'lodash'
  require 'react/addons'
  require 'components/quanta/icons/add/add'
  require 'components/quanta/icons/alert/alert'
  require 'components/quanta/icons/burger/burger'
  require 'components/quanta/icons/checkmark/checkmark'
  require 'components/quanta/icons/success_check/success_check'
  require 'components/quanta/icons/clear/clear'
  require 'components/quanta/icons/delete/delete'
  require 'components/quanta/icons/edit/edit'
  require 'components/quanta/icons/i/i'
  require 'components/quanta/icons/info/info'
  require 'components/quanta/icons/down_arrow/down_arrow'
  require 'components/quanta/icons/left_arrow/left_arrow'
  require 'components/quanta/icons/left_arrow_large/left_arrow_large'
  require 'components/quanta/icons/right_arrow/right_arrow'
  require 'components/quanta/icons/right_arrow_large/right_arrow_large'
  require 'components/quanta/icons/search/search'
  require 'components/quanta/icons/x/x'
  require 'components/quanta/icons/filter/filter'
  require 'components/quanta/icons/heart/heart'
  require 'components/quanta/icons/cart/cart'
  require 'components/quanta/icons/menu/menu'
]

module.exports = React.createClass

  propTypes:
    isChecked: React.PropTypes.bool

    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    isChecked: false

    cssUtility: 'u-icon u-fill--dark-gray -icon-margin -size-200'
    cssModifier: ''

  render: ->
    <div>
      <IconAdd {...@props}/>
      <IconAlert {...@props}/>
      <IconBurger {...@props}/>
      <IconCheckmark {...@props}/>
      <IconSuccessCheck {...@props}/>
      <IconClear {...@props}/>
      <IconDelete {...@props}/>
      <IconEdit {...@props}/>
      <IconI {...@props}/>
      <IconInfo {...@props}/>
      <IconDownArrow {...@props}/>
      <IconLeftArrow {...@props}/>
      <IconLeftArrowLarge {...@props}/>
      <IconRightArrow {...@props}/>
      <IconRightArrowLarge {...@props}/>
      <IconSearch {...@props}/>
      <IconX {...@props}/>
      <IconFilter />
      <IconHeart />
      <IconCart />
      <IconMenu />
    </div>
