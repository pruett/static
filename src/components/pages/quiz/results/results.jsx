const _ = require("lodash");
const React = require("react/addons");

const LayoutDefault = require("components/layouts/layout_default/layout_default");

const Frames = require("components/organisms/quiz/quiz_frames/quiz_frames");
const Instructions = require("components/organisms/quiz/quiz_instructions/quiz_instructions");
const ModalLoader = require("components/molecules/modals/loader/loader");
const FavoriteLoginModal = require("components/molecules/products/favorite_login_modal/favorite_login_modal");

const Mixins =  require("components/mixins/mixins");

const ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

module.exports = React.createClass({
  CONTENT_PATHS: [
    "/quiz-info",
    "/quiz-results",
  ],

  mixins: [Mixins.context, Mixins.dispatcher],

  statics: {
    route: function() {
      return {
        path: "/quiz/results",
        handler: "QuizResults",
        title: "Quiz results",
        bundle: "quiz"
      };
    }
  },

  fetchVariations: function() {
    return this.CONTENT_PATHS;
  },

  receiveStoreChanges: function() {
    return ["favorites", "quiz", "session"];
  },

  render: function() {
    const contentInfo = this.getContentVariation(this.CONTENT_PATHS[0]) || {};
    const contentResults = this.getContentVariation(this.CONTENT_PATHS[1]) || {};

    const session = this.getStore("session");
    const quizData = this.getStore("quiz");
    const favorites = this.getStore("favorites");
    const showFavorites = favorites.__fetched || !session.isLoggedIn;

    return (
      <LayoutDefault {...this.props} cssModifier={"-full-page"}>
        <Instructions
          {...contentInfo}
          isActive={quizData.showInstructionsTakeover} />

        {typeof window === "undefined" || window === null
          ? <ModalLoader caption="Reloading your quiz results. Hang tight…" />
          : null}

        <Frames
          cart={_.get(session, "cart", {})}
          favorites={_.get(favorites, "favoritedProducts", [])}
          showFavorites={showFavorites}
          hideResults={quizData.hideResults}
          frames={quizData.frames}
          gender={_.get(quizData, "answers.gender")}
          showTooltip={!quizData.showInstructionsTakeover}
          content={contentResults} />

        {showFavorites
          ? <FavoriteLoginModal
              active={favorites.showLogin}
              session={session} />
          : null}
      </LayoutDefault>
    );
  }
});
