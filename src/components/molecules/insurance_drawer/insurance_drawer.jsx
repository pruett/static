const _ = require('lodash');
const React = require('react/addons');

const IconX = require('components/quanta/icons/thin_x/thin_x');
const FSAIllustration = require('components/atoms/out_of_network/fsa_illustration/fsa_illustration');
const ReimbursementIllustration = require('components/atoms/out_of_network/reimbursement_illustration/reimbursement_illustration');

const Mixins = require('components/mixins/mixins');

require('./insurance_drawer.scss');

module.exports = React.createClass({
  BLOCK_CLASS: 'c-insurance-drawer',

  mixins: [
    Mixins.classes,
    Mixins.analytics,
  ],

  getDefaultProps: function () {
    return {
      'isOpen': false,
      'handleClose': _.noop,
    };
  },

  getInitialState: function () {
    return {
      'isOpen': this.props.isOpen,
    };
  },

  getStaticClasses: function () {
    return {
      'animated': `${this.BLOCK_CLASS}__animated u-db u-pr u-tar
        u-btw1 u-btss u-bc--light-gray-alt-1
        u-pb8 u-pb24--600`,
      'block': `${this.BLOCK_CLASS} u-oh`,
      'close': 'u-button-reset u-mt18 u-mr18',
      'content': 'u-w12c u-w10c--720 u-mla u-mra u-db',
      'details': `
        ${this.BLOCK_CLASS}__details u-color--dark-gray-alt-3
        u-mla u-mra u-lh26 u-fs16 u-fs18--720`,
      'icon': 'u-mt4 u-mt8--720 u-fill--dark-gray-alt-2',
      'illustration': 'u-mla u-mra u-mt18 u-w5c u-w4c--600 u-w5c--720 u-db',
      'link': 'u-dib u-fws u-link--hover',
      'section': `${this.BLOCK_CLASS}__section u-dib u-tac u-vat
        u-w12c u-w6c--720 u-pl12 u-pr12 u-pb8 u-pb0--720 u-mb24 u-mb0--720`,
      'subhead': 'u-fs18 u-fws',
    };
  },

  classesWillUpdate: function () {
    return {
      'block': {
        '-open': this.props.isOpen,
      },
    };
  },

  renderSection: function (classes, section) {
    return (
      <div className={classes.section}>
        {section.illustration}
        <h1 className={classes.subhead} children={section.subhead} />
        <p className={classes.details} children={section.details} />
        <a className={classes.link}
          href={section.href}
          target="_blank"
          onClick={(evt) => this.clickInteraction(section.clickTarget)}
          children='Learn more' />
      </div>
    );
  },

  render: function () {
    const classes = this.getClasses();
    const sections = [
      {
        'illustration': <FSAIllustration cssModifier={classes.illustration} />,
        'subhead': 'Use your FSA or HSA dollars',
        'details': `At checkout, you can use the card associated with your flexible spending
        or health spending account to pay for prescription eyeglasses and sunglasses`,
        'href': '/flexible-spending-accounts',
        'clickTarget': 'learnFsaHsa',
      },{
        'illustration': <ReimbursementIllustration cssModifier={classes.illustration} />,
        'subhead': 'Get reimbursed by your insurance',
        'details': `If your vision insurance plan includes an out-of-network benefit (most do!),
        it’s easy to apply for reimbursement after purchasing`,
        'href': '/insurance',
        'clickTarget': 'learnReimbursement',
      }]
    return (
      <div className={classes.block}>
        <div className={classes.animated}>
          <button type='button'
            aria-label="Close"
            className={classes.close}
            onClick={this.props.handleClose}>
            <IconX cssModifier={classes.icon} />
          </button>
          <div className={classes.content}
            children={_.map(sections, _.bind(this.renderSection, this, classes))} />
        </div>
      </div>
    );
  }
});
