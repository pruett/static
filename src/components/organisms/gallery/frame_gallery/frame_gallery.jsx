const _ = require("lodash");
const React = require("react/addons");

const Hero = require("components/molecules/gallery_hero/gallery_hero");
const FramesGrid = require("components/molecules/products/frames_grid/frames_grid");
const QuizPromo = require("components/molecules/quiz_promo/quiz_promo");
const QuizPromoNew = require("components/molecules/quiz_promo_v2/quiz_promo_v2");
const Filters = require("components/organisms/gallery/filters/filters");

const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  mixins: [ Mixins.context ],

  getInitialState() {
    return {
      frameGalleryVisible: true,
      quizPromoActive: this.props.htoFilter || false,
    };
  },

  componentWillReceiveProps(nextProps) {
    this.setState({
      frameGalleryVisible: true,
    });
  },

  handleFilterChange() {
    this.setState({ frameGalleryVisible: !this.state.frameGalleryVisible });
  },

  handleHtoFilterChange(checked) {
    this.setState({
      frameGalleryVisible: !this.state.frameGalleryVisible,
      quizPromoActive: checked,
    });
  },

  render() {
    const stickyFilterVariant = this.getExperimentVariant("stickyGalleryFilters");
    const QuizPromoComponent = this.inExperiment('galleryQuizPromo', 'new') ? QuizPromoNew : QuizPromo;

    return (
      <div>
        <Hero {...this.props.hero} />

        <Filters
          filters={this.props.filters}
          filtersSummary={this.props.filtersSummary}
          activeFilters={this.props.activeFilters}
          filtersList={this.props.filtersList}
          htoChecked={this.props.htoFilter}
          searchEnabled={this.props.searchEnabled}
          visibleFrames={this.props.visibleFrames}
          framesCount={this.props.framesCount}
          clearFiltersAfter={this.props.clearFiltersAfter}
          handleSearch={this.props.manageSearchClick}
          manageFilterChange={this.handleFilterChange}
          manageHtoFilterChange={this.handleHtoFilterChange}
          isSticky={_.includes(stickyFilterVariant, "sticky")}
          isInline={stickyFilterVariant === "stickyNoSearch"} />

        <div className="c-frame-gallery__content">
          {this.props.type === "eyeglasses" ?
            <QuizPromoComponent
              active={this.state.quizPromoActive}
              cart={this.props.cart}
              hasQuizResults={this.props.hasQuizResults}
              gender={this.props.gender} />
            : null}

          {this.props.__fetched ?
            <FramesGrid
              cart={this.props.cart}
              frames={this.props.frames}
              favorites={this.props.favorites}
              showFavorites={this.props.showFavorites}
              showHtoQuickAdd={this.props.htoFilter}
              frameIndices={this.props.frameIndices}
              isProductHidden={this.props.isProductHidden}
              promoIndices={this.props.promoIndices}
              promos={this.props.promos}
              visible={this.state.frameGalleryVisible}
              maxFrameWidth={this.props.maxFrameWidth} />
            : null}
        </div>
      </div>
    );
  }
});
