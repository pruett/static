const React = require('react/addons');
const Mixins = require('components/mixins/mixins');
const Markdown = require('components/molecules/markdown/markdown');

require('./countdown.scss');

module.exports = React.createClass({
  BLOCK_CLASS: 'c-countdown',

  mixins: [
    Mixins.classes,
  ],

  getStaticClasses: function() {
    return{
      headText: `
        ${this.BLOCK_CLASS}__head-text
        u-fs55 u-mb0
      `,
      subTextContainer: `
        u-m0a u-pt12
        u-fs16
      `,
      subText: `
        ${this.BLOCK_CLASS}__sub-text
      `,
      fixedSize: `
        ${this.BLOCK_CLASS}__fixed-size
        u-mla u-mra
      `
    }
  },

  getInitialState: function() {
    return {
      days: 0,
    }
  },

  getDefaultProps: function() {
    return {
      /* April 8, 2024, date of next eclipse*/
      dateNextEclipse: 1712635140000,
    }
  },

  componentDidMount: function() {
    if (!(typeof window === 'undefined' || window === null)) {
      this.updateTime();
    };
  },

  padNumber: function(number) {
    return (number < 10) ? `0${number}`: number;
  },

  updateTime: function() {
    const now = this.props.currentTime || Date.now();
    let difference = Math.floor((this.props.dateNextEclipse - now) / 1000);

    const days = Math.floor(difference / (60*60*24));
    this.setState({days:days});
  },

  render: function() {
    const classes = this.getClasses();
    let headTextContainer = '';
    const headText = `the spectacle is over`;
    const subtext = `view the next great american solar eclipse in *${this.state.days}* days`;

    return(
      <div className={classes.countdownContainer}>
        <div className={headTextContainer}>
          <Markdown cssBlock={classes.headText} rawMarkdown={headText} />
        </div>
        <div className={`${classes.subTextContainer} ${classes.fixedSize}`}>
          <Markdown cssBlock={classes.subText} rawMarkdown={subtext} />
        </div>
      </div>
    );
  }

});
