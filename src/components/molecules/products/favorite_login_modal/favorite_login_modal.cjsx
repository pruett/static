React = require 'react/addons'
Takeover = require 'components/molecules/modals/takeover/takeover'
FavoriteLogin = require 'components/molecules/products/favorite_login/favorite_login'

module.exports = React.createClass
  propTypes:
    active: React.PropTypes.bool
    session: React.PropTypes.object

  render: ->
    <Takeover
      cssModifier='u-color-bg--white-95p'
      active=@props.active
      hasHeader=false
      verticallyCenter=true
      analyticsSlug=''>
      <FavoriteLogin session=@props.session />
    </Takeover>
