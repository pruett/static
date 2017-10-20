[
  _
  React

  Takeover
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/modals/takeover/takeover'
]

module.exports = React.createClass

  propTypes:
    active: React.PropTypes.bool

  getDefaultProps: ->
    active: false
    cssModifier: "u-color-bg--white-95p"

  render: ->
    <Takeover analyticsSlug=''
      cssModifier=@props.cssModifier
      active=@props.active
      hasHeader=false
      verticallyCenter=true
      children=@props.children />
