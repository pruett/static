const _ = require('lodash');
const React = require('react/addons');
const LayoutDefault = require(
  'components/layouts/layout_default/layout_default'
);

const Header = require('components/organisms/birthday/header/header');
const Footer = require('components/organisms/birthday/footer/footer');
const Form = require('components/organisms/birthday/form/form');
const Success = require('components/organisms/birthday/success/success');
const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({
  displayName: 'PagesCollectionsBirthday',
  CONTENT_PATH: '/birthday-form',
  FRAMES_PATH: '/landing-page/birthday-frames',
  mixins: [Mixins.context, Mixins.dispatcher, Mixins.routing],
  statics: {
    route: function() {
      return {
        path: '/glasses-for-life',
        handler: 'BirthdayForm',
        title: 'Glasses For Life'
      };
    }
  },
  fetchVariations: function() {
    return [this.CONTENT_PATH, this.FRAMES_PATH];
  },
  receiveStoreChanges: function() {
    return ['birthday', 'regions', 'session'];
  },
  manageSubmit: function(attrs) {
    this.commandDispatcher('birthday', 'submit', attrs);
  },
  manageChange: function(key, value) {
    this.commandDispatcher('birthday', 'validate', key, value);
  },
  getFrames: function(content = {}) {
    return (content.products || [])
      .map(product => _.get(content, `__data.products[${product.product_id}]`))
      .filter(product => product);
  },
  render: function() {
    const birthday = this.getStore('birthday');
    const frames = this.getFrames(this.getContentVariation(this.FRAMES_PATH));
    const content = this.getContentVariation(this.CONTENT_PATH) || {};
    const copy = content.copy || {};
    const images = content.images || {};

    let body = null;
    if (birthday.active) {
      if (birthday.success) {
        body = <Success images={images} copy={copy.success} />;
      } else {
        body = (
          <Form
            {...birthday}
            {...this.getStore('regions')}
            {...this.getStore('session')}
            copy={copy.form}
            country={this.getLocale('country')}
            manageSubmit={this.manageSubmit}
            manageChange={this.manageChange}
          />
        );
      }
    }

    return (
      <LayoutDefault cssModifier={'-full-page'} {...this.props}>
        {this.inExperiment('seventhBirthday', 'enabled')
          ? <main>
              <Header {...birthday} images={images} copy={copy.header} />
              {body}
              <Footer images={images} copy={copy.footer} frames={frames} />
            </main>
          : null}
      </LayoutDefault>
    );
  }
});
