const React = require('react/addons');
const Rsvg = require('components/quanta/rsvg/rsvg');

require('./play.scss');

module.exports = React.createClass({

  SVG: {
    'class': 'c-icon--play',
    width: 42,
    height: 42
  },

  getDefaultProps: function() {
    return({
      cssUtility: 'u-icon u-fill--blue',
      cssModifier: '',
      cssModifierArrow: 'u-stroke--white u-fill--white'
    })
  },

  render: function() {
    return(
      <Rsvg {...this.props} SVG={this.SVG} title={'Play'}>
        <circle cx='21' cy='21' r='21'/>
        <path
          className={this.props.cssModifierArrow}
          transform='translate(16.947 16)'
          d='M1.33 0.03L7.96 4.01 7.96 6.66 1.33 10.64'/>
        <path
          className={this.props.cssModifierArrow}
          strokeWidth='3.6'
          strokeLinecap='round'
          transform='matrix(-1 0 0 1 26.233 16)'
          d='M.27498012e-12 5.33420345L7.95918367.92377261M7.95918367 9.74463429L7.95918367.92377261M7.95918367 9.74463429L.27498012e-12 5.33420345' />
      </Rsvg>
    );
  }

});
