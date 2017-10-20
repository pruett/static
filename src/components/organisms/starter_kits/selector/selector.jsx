const _ = require('lodash');
const React = require('react/addons');

const Select = require('components/molecules/rich_select/rich_select');
const Mixins = require('components/mixins/mixins');

require('./selector.scss');

module.exports = React.createClass({

  BLOCK_CLASS: 'c-starter-kit-selector',
  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.dispatcher
  ],

  propTypes: {
    options: React.PropTypes.object,
    settings: React.PropTypes.object
  },

  getDefaultProps: function() {
    return {
      analyticsCategory: '',
      options: {
        gender: [
          {value: 'm', label: 'Men’s styles'},
          {value: 'f', label: 'Women’s styles'}
        ],
        fit: [
          {
            value: 'narrow',
            label: 'Narrow fit',
            description: 'If hats are big or if frames often appear oversized'
          },
          {
            value: 'medium',
            label: 'Medium fit',
            description: 'A large range of people have medium-width faces. Not sure about yours? Pick this one.'
          },
          {
            value: 'wide',
            label: 'Wide fit',
            description: 'If hats are snug or if frames sometimes pinch'
          }
        ]
      },
      settings: {},
      copy: {
        intro: 'Start by selecting your style and fit',
        summary: 'Pick and choose your 5 frames below'
      },
      scrollToPromo: function(){},
      stickyHeader: false
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-pr
        u-mw1440
        u-mla u-mra
        u-mt48 u-mt72--600
        u-color-bg--light-gray-alt-5
        u-tac
      `,
      content: `
        u-pa u-center u-w100p
      `,
      intro: `
        u-pa u-t0 u-w100p
        u-m0
        u-ffs u-fsi
        u-fs16 u-fs18--600
        u-color--dark-gray-alt-3
      `,
      summary: `
        u-pa u-b0 u-w100p
        u-mb24 u-mb36--600
        u-fs10 u-ls2_5
        u-fws u-ttu
        u-color--dark-gray-alt-3
      `,
      sentence: `
        u-pt96 u-pb96
        u-pl12 u-pl36--600 u-pl48--900
        u-pr12 u-pr36--600 u-pr48--900
        u-ffs u-fws
        u-fs40 u-fs60--600 u-fs80--900
      `,
      select: `
        ${this.BLOCK_CLASS}__select
        u-color--blue
        u-mw100p
        u-mt8
      `,
      stickyHeader: `
        ${this.BLOCK_CLASS}__sticky-header
        u-pf u-t0 u-l0 u-r0
        u-mw1440 u-m0a
        u-pt18 u-pb18
        u-color-bg--white
        u-btw1 u-bbw1 u-blw0 u-brw0
        u-bss u-bc--light-gray-alt-1
        u-fws
      `,
      headerString: `
        u-pr18 u-pr24--600
      `
    };
  },

  handleChangeSetting: function(evt) {
    this.commandDispatcher('homeTryOn', 'updateStarterKit', evt.target.name, evt.target.value);
  },

  getSettingsString: function() {
    return _.reduce(this.props.options, (labels, option, key) => {
      const selected = _.find(option, {value: this.props.settings[key]});
      if(selected) {
        labels.push(selected.label);
      }
      return labels;
    }, []).join(', ');
  },

  renderSelect: function(name, cssModifier) {
    return (
      <Select
        analyticsCategory={this.props.analyticsCategory}
        cssModifier={cssModifier}
        handleChange={this.handleChangeSetting}
        name={name}
        options={_.get(this.props, `options.${name}`, [])}
        selected={_.get(this.props, `settings.${name}`, '')} />
    );
  },

  render: function() {
    const classes = this.getClasses();

    return (
      <div>
        <div className={classes.block} id={'starter-kit'}>
          <p className={classes.summary} children={_.get(this.props, 'copy.summary')} />
          <div className={classes.content}>
            <p className={classes.intro} children={_.get(this.props, 'copy.intro')} />
            <div className={classes.sentence}>
              <div>
                {'I’m looking for '}
                {this.renderSelect('gender', `${classes.select} -wide`)}
              </div>
              <div>
                {'in a '}
                {this.renderSelect('fit', classes.select)}
              </div>
            </div>
          </div>
        </div>

        {this.props.stickyHeader &&
          <div className={classes.stickyHeader}>
            <span
              className={classes.headerString}
              children={`Viewing ${this.getSettingsString()}`} />
            <a
              data-link={true}
              href={'#starter-kit'}
              children={'Edit'}
              onClick={this.props.scrollToPromo} />
          </div>}
      </div>
    );
  }

});
