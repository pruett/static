const _ = require('lodash');
const React = require('react/addons');

const Mixins = require('components/mixins/mixins');

require('./success.scss');

module.exports = React.createClass({
  displayName: 'BirthdaySuccess',
  BLOCK_CLASS: 'c-birthday-success',
  ANALYTICS_CATEGORY: 'seventhBirthday',
  mixins: [Mixins.analytics, Mixins.classes, Mixins.context],
  propTypes: {
    copy: React.PropTypes.object,
    images: React.PropTypes.object
  },
  getDefaultProps: function() {
    return {
      copy: {},
      images: {}
    };
  },
  getStaticClasses: function() {
    return {
      block: (
        `
        ${this.BLOCK_CLASS}
        u-tac
        u-pt48 u-pt72--600
        u-pb48 u-pb72--600
        u-mb24
        u-bw0 u-btw1 u-bss u-bc--light-gray-alt-2
      `
      ),
      grid: (
        `
         u-grid -maxed u-ma
      `
      ),
      row: (
        `
        u-grid__row
      `
      ),
      col: (
        `
        u-grid__col
        u-w10c
        u-ffss
        u-fs16 u-fs18--600
      `
      ),
      body: (
        `
        u-reset u-pr
        u-ffss u-fs16 u-fs18--600
        u-w10c--600 u-l1c--600
        u-w6c--900 u-l3c--900
        u-mb24
      `
      ),
      shares: (
        `
        u-df--600
        u-ma u-mb30 u-mb36
        u-mw600
      `
      ),
      share: (
        `
        u-db u-w4c--600
        u-mb12 u-mb0--600
      `
      ),
      img: `${this.BLOCK_CLASS}__img u-mb24`,
      link: (
        `
        u-link--underline
      `
      ),
      copy: (
        `
        u-color-bg--white
        u-bc--light-gray u-bw1 u-bss
        u-p12 u-pt6 u-pb6
        u-br1
        u-dib
      `
      ),
      copyText: (
        `
        u-color--blue
        u-fws
        u-dib
        u-mr12
      `
      ),
      copyLink: (
        `
        u-color--light-gray
      `
      )
    };
  },
  handleClick: function(url, name, event) {
    this.clickInteraction(name);
    const opts = 'status=1,width=575,height=400,top=25,left=25';
    window.open(url, name, opts);
    event.preventDefault();
  },
  render: function() {
    const classes = this.getClasses();
    const { copy, images } = this.props;
    const bgStyle = { backgroundImage: `url(${images.submitted})` };

    return (
      <section
        className={classes.block}
        htmlFor={this.props.images.submitted}
        style={bgStyle}
      >
        <div className={classes.grid}>
          <div className={classes.row}>
            <div className={classes.col}>
              <p className={classes.body} children={copy.body} />
              <img src={images.good_luck} className={classes.img} />
              <p className={classes.body} children={copy.share} />
              <div className={classes.shares}>
                <div className={classes.share}>
                  <a
                    href={copy.facebook_url}
                    className={classes.link}
                    onClick={this.handleClick.bind(
                      this,
                      copy.facebook_url,
                      'facebook'
                    )}
                    target="_blank"
                    children={copy.facebook}
                  />
                </div>
                <div className={classes.share}>
                  <a
                    href={copy.twitter_url}
                    className={classes.link}
                    onClick={this.handleClick.bind(
                      this,
                      copy.twitter_url,
                      'twitter'
                    )}
                    target="_blank"
                    children={copy.twitter}
                  />
                </div>
                <div className={classes.share}>
                  <a
                    href={copy.email_url}
                    className={classes.link}
                    children={copy.email}
                    onClick={this.clickInteraction.bind(this, 'email')}
                  />
                </div>
              </div>
              <div className={classes.copy}>
                <span className={classes.copyText} children={copy.copy} />
                <span className={classes.copyLink} children={copy.copy_url} />
              </div>
            </div>
          </div>
        </div>
      </section>
    );
  }
});
