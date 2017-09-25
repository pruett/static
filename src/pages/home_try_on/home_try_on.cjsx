[
  React

  LayoutDefault

  FavoriteLoginModal
  HomeTryOn

  Mixins

] = [
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/molecules/products/favorite_login_modal/favorite_login_modal'
  require 'components/organisms/static/home_try_on/home_try_on'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      path: '/home-try-on'
      handler: 'HomeTryOn'
      title: 'Home Try-On'

  receiveStoreChanges: -> [
    'favorites'
    'homeTryOn'
    'session'
  ]

  render: ->
    session = @getStore 'session'
    favorites = @getStore 'favorites'
    showFavorites = favorites.__fetched or not session.isLoggedIn

    <LayoutDefault {...@props} cssModifier='-full-width'>
      <HomeTryOn
        cms={@getStore 'homeTryOn'}
        favorites={favorites.favoritedProducts or []}
        showFavorites=showFavorites
        session=session />
      {if showFavorites
        <FavoriteLoginModal
          active=favorites.showLogin
          session=session />}
    </LayoutDefault>
