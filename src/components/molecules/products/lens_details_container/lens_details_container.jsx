const React = require("react/addons");
const _ = require("lodash");

const Mixins = require("components/mixins/mixins");

const LensDetailsData = require("../lens_details_data/lens_details_data");

module.exports = Component =>
  React.createClass({
    displayName: "MoleculesProductsLensDetailsContainer",

    mixins: [Mixins.classes],

    propTypes: {
      displayShapes: React.PropTypes.array,
      gender: React.PropTypes.string,
    },

    getDefaultProps() {
      return {
        displayShapes: [],
        gender: "f",
      };
    },

    getDifference(superSet, subSet) {
      //compare array of shapeIDs from API with shape constants
      const difference = _.difference(superSet, subSet);
      return difference.length > 0;
    },

    getSingleDisplayShape(displayID, key) {
      const shape = LensDetailsData.ID_TO_SHAPE_STRING_LOOKUP[displayID];
      return LensDetailsData.DISPLAY_SHAPE_LOOKUP[key][shape];
    },

    handleCatEyeShapes() {
      switch (this.props.gender) {
        case "m":
          return "round";
        case "f":
          return "catEye";
        default:
          return "round";
      }
    },

    handleMultipleDisplayShapes(displayShapes) {
      if (displayShapes.indexOf(2600) > -1) {
        return this.handleCatEyeShapes(displayShapes);
      } else {
        if (
          this.getDifference(
            displayShapes,
            LensDetailsData.FRAME_SHAPE_CONSTANTS.ROUND_SQUARE
          )
        ) {
          return "round";
        } else if (
          this.getDifference(
            displayShapes,
            LensDetailsData.FRAME_SHAPE_CONSTANTS.SQUARE_RECTANGLE
          )
        ) {
          return "rectangle";
        } else if (
          this.getDifference(
            displayShapes,
            LensDetailsData.FRAME_SHAPE_CONSTANTS.ROUND_RECTANGLE
          )
        ) {
          return "round";
        } else {
          return "round";
        }
      }
    },

    getDiagramImages(label) {
      const displayShapes = this.props.displayShapes || [];
      if (displayShapes.length === 1) {
        // If there is only a single shape ID in the array, we only need its
        // corresponding shape string.
        return this.getSingleDisplayShape(displayShapes[0], label);
      } else {
        // Handle reducing multiple shape IDs to the preffered shape.
        const shape = this.handleMultipleDisplayShapes(displayShapes);
        return LensDetailsData.DISPLAY_SHAPE_LOOKUP[label][shape];
      }
    },

    renderLensDetails() {
      const lensDetails = LensDetailsData.LENS_DETAILS.map((detail, i) => {
        const diagramImages = this.getDiagramImages(detail.label);
        return (
          <div key={i} className={`js-learning-${i}`}>
            <Component
              {...this.props}
              {...detail}
              diagramImages={diagramImages}
            />
          </div>
        );
      });
      return lensDetails;
    },

    render() {
      return <div children={this.renderLensDetails()} />;
    },
  });
