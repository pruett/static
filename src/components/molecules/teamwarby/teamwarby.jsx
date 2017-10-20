const _ = require('lodash');
const React = require('react/addons');

const SlidingDrawer = require('components/atoms/sliding_drawer/sliding_drawer');

const Mixins = require('components/mixins/mixins');

require('./teamwarby.scss');

module.exports = React.createClass({
  BLOCK_CLASS: 'c-teamwarby',

  mixins: [
    Mixins.classes,
  ],

  sections: [
    {
      header: 'A RELENTLESS GO-GETTER',
      details: `Our company is changing as fast as it’s growing (read: very, very fast).
                  We’re constantly setting ambitious new goals for ourselves, working on all cylinders to meet them,
                  and proactively stopping along the way to set newer, even more ambitious ones. We’re goal gluttons.`,
    },{
      header: 'AN IDEA MACHINE',
      details: `We never get tired of crazy, creative new ideas. Sometimes these take the form of subtle new design
                  details, other times they majorly transform the company. Here’s the SAT analogy:
                  Garfield : lasagna :: us : innovation.`,
    },{
      header: 'AN MVTP (MOST VALUABLE TEAM PLAYER)',
      details: `About those ideas—they come from all over the company, and it takes the whole team to make them happen.
                  From retail advisors to graphic designers to data scientists, everyone pitches in with their particular
                  strengths. `,
    },{
      header: 'AND GOOD COMPANY',
      details: `Bottomless snacks, book clubs, midday surprises, intramural sports: We do a lot to mix our workdays up.
                  But nothing beats the delight of working with smart, curious, and kind people committed to doing good
                  in the world.`,
    },
  ],

  getDefaultProps: function () {
    return {
      isOpen: false,
      handleClose: _.noop,
    };
  },

  getStaticClasses: function () {
    return {
      anchor: 'u-dib',
      block: `
        ${this.BLOCK_CLASS} u-tac
        u-w12c u-mw1440 u-pr32 u-pl32 u-mla u-mra
        u-color-bg--light-gray-alt-2`,
      closeArrow: `u-db u-pr
        u-mla u-mra u-button-reset
        ${this.BLOCK_CLASS}__close`,
      hashtag: 'u-fs16 u-fws u-mt24 u-mb48',
      image: `${this.BLOCK_CLASS}__image u-w10c u-w6c--600 u-mt48 u-mb12`,
      intro: 'u-mw600 u-fs16 u-mla u-mra u-color--dark-gray-alt-3',
      section: 'u-mw600 u-mla u-mra',
      sectionHeader: 'u-fs16 u-fws u-color--dark-gray u-mb4 u-mt36',
      sectionDetails: 'u-ffss u-fs16 u-color--dark-gray-alt-3',
    };
  },

  renderSection: function (classes, section) {
    return (
      <div className={classes.section}>
        <h3 className={classes.sectionHeader} children={section.header} />
        <div className={classes.sectionDetails} children={section.details} />
      </div>
    );
  },

  render: function () {
    const classes = this.getClasses();

    return (
      <SlidingDrawer
        cssModifier={classes.block}
        isOpen={this.props.isOpen}
        handleClose={this.props.handleClose}>
        <a className={classes.anchor} />
        <div id="teamwarby" className={classes.intro} children={`
          All kinds of people work at Warby Parker: dog people, cat people, bookworms, people who can do the worm.
          According to the hundreds of coworkers we asked, you might be a good fit if you’re…
        `} />
        <img className={classes.image}
          src='https://i.warbycdn.com/v/c/assets/teamwarby/image/glasses/0/dd296606b4.png' />
        {_.map(this.sections, _.partial(this.renderSection, classes))}
        <div className={classes.hashtag} children="#teamwarby" />
        <button className={classes.closeArrow} onClick={this.props.handleClose} />
      </SlidingDrawer>
    );
  }
});
