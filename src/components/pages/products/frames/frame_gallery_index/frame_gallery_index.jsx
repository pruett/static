const _ = require("lodash");
const React = require("react/addons");

const LayoutDefault = require("components/layouts/layout_default/layout_default");

const FrameGallery = require("components/organisms/gallery/frame_gallery/frame_gallery");
const FrameSearch = require("components/organisms/gallery/gallery_search/gallery_search");
const FavoriteLoginModal = require("components/molecules/products/favorite_login_modal/favorite_login_modal");

const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  mixins: [
    Mixins.context,
    Mixins.dispatcher,
  ],

  statics: {
    route() {
      return {
        path: [
          "/eyeglasses/men",
          "/eyeglasses/women",
          "/sunglasses/men",
          "/sunglasses/women",
        ],
        asyncPrefetch: ["/.*"],
        handler: "FrameGallery"
      };
    }
  },

  receiveStoreChanges() {
    return [
      "frameGallery",
      "favorites",
      "session",
      "search"
    ];
  },

  getInitialState() {
    return { searchActive: false };
  },

  openSearch() {
    this.setState({ searchActive: true });
  },

  closeSearch() {
    this.setState({ searchActive: false });
  },

  render() {
    const favorites = this.getStore("favorites");
    const frameGallery = this.getStore("frameGallery");
    const globalSearch = this.getStore("search");
    const session = this.getStore("session");

    const showFavorites = (
      (favorites.__fetched || !session.isLoggedIn) && typeof window === "object"
    ) || false;

    return (
      <LayoutDefault {...this.props} cssModifier={"-full-width -push-footer"}>
        <FrameSearch
          active={this.state.searchActive}
          favoritesLoginActive={favorites.showLogin}
          filters={frameGallery.filters}
          frames={frameGallery.frames}
          globalSearchActive={globalSearch.active}
          htoMode={frameGallery.htoMode}
          title={_.get(frameGallery, "hero.headline")}
          openSearch={this.openSearch}
          closeSearch={this.closeSearch}/>

        {showFavorites ?
          <FavoriteLoginModal
            active={favorites.showLogin}
            session={session} />
          : null}

        <FrameGallery {...frameGallery}
          cart={_.get(session, "cart")}
          favorites={_.get(favorites, "favoritedProducts", [])}
          manageSearchClick={this.openSearch}
          searchEnabled={this.state.searchEnabled}
          showFavorites={showFavorites} />
      </LayoutDefault>
    );
  }
});
