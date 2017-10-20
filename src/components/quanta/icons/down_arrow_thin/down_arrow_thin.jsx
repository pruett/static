const React = require('react/addons');
const Rsvg = require('components/quanta/rsvg/rsvg');

require('./down_arrow_thin.scss');

module.exports = React.createClass({

  SVG: {
    'class': 'c-icon--down-arrow-thin',
    width: 20,
    height: 10
  },

  getDefaultProps: function() {
    return({
      cssUtility: 'u-icon',
      cssModifier: ''
    })
  },

  render: function() {
    return(
      <Rsvg {...this.props} SVG={this.SVG} title={'Down arrow'}>
        <path
          fill={'none'}
          d={'M308 40L300 31 308 22'}
          transform={'rotate(-90 144 165)'}
          strokeLinecap={'round'}
          strokeLinejoin={'round'} />
      </Rsvg>
    );
  }

});
