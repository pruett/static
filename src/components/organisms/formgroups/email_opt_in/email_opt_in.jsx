const React = require('react/addons');

const FormGroupCheckbox = require('components/organisms/formgroups/checkbox/checkbox');

const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({

  mixins: [
    Mixins.classes
  ],

  propTypes: {
    cssModifier: React.PropTypes.string,
    name: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      cssModifier: '',
      name: 'wants_marketing_emails',
      txtLabel: [
        (
          <span
            key='email-opt-in-1'
            children='I’d like to get news on collections, events, and more. I understand
              I can opt out at any time. See our ' />
        ),
        (
          <a
            key='email-opt-in-2'
            href='/privacy-policy'
            target='_blank'
            rel='noopener noreferrer'
            children='terms and conditions' />
        ),
        (
          <span key='email-opt-in-3' children=' for details.' />
        )
      ]
    };
  },

  getStaticClasses: function() {
    return {
      block: `u-tal ${this.props.cssModifier}`
    };
  },

  render: function() {
    const classes = this.getClasses();

    return (
      <FormGroupCheckbox
        {...this.props}
        cssModifier={classes.block} />
    );
  }

});
