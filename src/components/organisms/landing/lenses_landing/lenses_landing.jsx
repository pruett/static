const _ = require("lodash");
const React = require('react/addons');
const Markdown = require('components/molecules/markdown/markdown');
const GlassesNav = require('components/molecules/glasses_nav/glasses_nav');

const Picture = require('components/atoms/images/picture/picture');
const Img = require('components/atoms/images/img/img');
const Mixins = require('components/mixins/mixins');
require('./lenses_landing.scss');


module.exports = React.createClass({
  BLOCK_CLASS: 'c-lenses-landing',

  STICKY_NAV_HEIGHT: 60,
  
  mixins: [
    Mixins.classes,
    Mixins.scrolling,
    Mixins.analytics,
    Mixins.image,
  ],

  getStaticClasses: function() {
    return {
      page: `
        u-mw1440
        u-m0a
      `,
      heroContainer: `
        u-pr
      `,
      heroText: `
        u-fs16 u-fs20--600
        u-pl18 u-pr18 u-pt36 u-pb36
        u-pa--900 u-center-y--900 u-l1c--900 u-tac 
        u-w4c--900 u-w8c--600
        u-m0a
      `,
      heroHeader: `
        u-ffs u-fws 
        u-fs24 u-fs30--900 u-fs40--1200
        u-mt0 
      `,
      heroImage: `
        u-mbn5 u-db
      `,
      heroBody: `
        u-mb0
        u-color--dark-gray-alt-3
        u-fs16 u-fs18--600 u-fs16--900 u-fs18--1200 u-ffss
        u-lh30--900
      `,
      categoryTitle: `
        u-color--light-gray
      `,
      stickyContainer: `
        ${this.BLOCK_CLASS}__sticky-container
        u-btss u-bbss u-bw1
        u-color-bg--white
        u-bc--light-gray-alt-1
      `,
      headerLinks: `
        u-fs16 u-fs18--600 u-fws
        u-pt18 u-pb18 u-pl32 u-pr32
        u-m0a
        u-tac
        u-mw960
      `,
      headerLink: `
        ${this.BLOCK_CLASS}__header-link
        u-color--light-gray-alt-6
        u-ml9 u-mr9 u-mr18--600 u-ml18--600
        u-pr
      `,
      sectionHeader: `
        u-w5c--600
        u-mla u-mra u-mt0
        u-mb12 u-mb48--600 
        u-tac
        u-ffs u-fws
        u-fs24 u-fs30--900 
      `,
      section: `
        ${this.BLOCK_CLASS}__section
        u-pt48 u-pt72--600
        u-pb24 u-pb72--600 
        u-bbss u-bw1
        u-bc--light-gray-alt-1
      `,
      textBlock: `
        u-fs16 u-fs18--600
        u-ffss
        u-color--dark-gray-alt-3
        u-oh
        u-mb24
      `,
      textBlockWithoutHeader: `
        u-w10c--600 u-tac u-m0a
        u-db
        u-mb0--600
      `,
      textBlockRow: `
        u-w6c--600
        u-vat
        u-dib--600
        u-pl18--600 u-pr18--600
        u-mb0--600
      `,
      textBlockColumn: `
        u-w6c--600
        u-vat u-dib--600 u-pl18--600 u-pr48--600
      `,
      textBlocks: `
        ${this.BLOCK_CLASS}__text-blocks
      `,
      textBlockHeader: `
        u-mt0 u-mb0
        u-fws
        u-color--dark-gray
      `,
      sectionImage: `
        ${this.BLOCK_CLASS}__section-image
        u-mla u-mra u-db
        u-mt18 u-mt36--600
        u-mb36 u-mb72--600
      `,
      markdown: `
        ${this.BLOCK_CLASS}__markdown
      `,
      textBlockContainer:`
        u-dib
      `,
      category: `
        ${this.BLOCK_CLASS}__category
        u-pl36--600 u-pr36--600
        u-pl18 u-pr18
        u-m0a--600
      `,
      outerCategory: `
        ${this.BLOCK_CLASS}__outer-category
      `,
      categoryDesktopTitle: `
        u-dn u-dib--600
      `,
      categoryMobileTitle: `
        u-dib u-dn--600
      `,
      shopLinksArea: `
        u-mla u-mra
        u-tac
        u-fws
        u-pb36  u-pb84--600
      `,
      shopLinksHeader: `
        u-w5c--600
        u-mla u-mra u-mt0
        u-mb24 u-mb48--600 
        u-ffs 
        u-fs30--900 u-fs24--600 
        u-tac
        u-pt48 u-pt72--600
      `,
      shopLinksButtonArea: `
        u-db u-di--600
      `,
      shopLinksButton: `
        ${this.BLOCK_CLASS}__button-links
        u-mr24--600 u-mb12 u-mb0--600 u-mla u-mra
        u-fs16
        u-color--dark-gray
        u-button -button-clear -button-medium 
        u-pb12 u-pb0--600
      `,
      
    };
  },

  getDefaultProps: function() {
    return {
      hero: {},
      categories: [],
      glasses: [],
    };
  },

  getInitialState: function() {
    return {
      activeCategory: `eyeglasses`,
    };
  },

  handleHeaderLinkClick: function(id, event) {
    const node = this.refs[id];
    const target = _.camelCase(`header ${id}`);
    this.scrollToNode(node, {
      time: 800,
      offset: -this.STICKY_NAV_HEIGHT + 2,
    });
    this.setState({activeCategory: id});
    this.trackInteraction(`lensesLanding-click-${target}`);
  },

  componentDidMount: function() {
    if (window.location.hash) {
      const hash = window.location.hash.replace(/#/, "");
      const node = this.refs[hash];
      this.scrollToNode(node, {
        time: 0,
        offset: -this.STICKY_NAV_HEIGHT + 2,
      });
      this.setState({activeCategory: hash});
    }
    return this.addScrollListener(this.updateActiveCategory, 100);
  },

  updateActiveCategory: function() {
    this.setState({
      activeCategory: _.first(
        Object.keys(this.refs).filter(ref =>
          this.elementIsInViewport(this.refs[ref], this.STICKY_NAV_HEIGHT)
        )
      )
    });
  },

  renderHeroChildren: function(hero) {
    const sources = {
      sources: [
        { url: hero.image_desktop,
          widths: [1000, 1200, 1440, 2880],
          mediaQuery: "(min-width: 900px)",
          sizes: "(min-width: 1440px) 1440px, 100vw",
        },
        { url: hero.image_tablet,
          widths: [700, 800, 900, 1400, 1800],
          mediaQuery: "(min-width: 600px)",
          sizes: "100vw",
        },
        { url: hero.image_mobile,
          widths: [375, 414, 750, 828],
          mediaQuery: "(min-width: 0px)",
          sizes: "100vw",
        },
      ]
    };
    return(
      this.getPictureChildren(sources)
    );
  },

  renderHero: function(classes, hero) {
    return(
      <div className={classes.heroContainer}>
        <Picture cssModifier={classes.heroImage} children={this.renderHeroChildren(hero)} />
        <div className={classes.heroText}>
          <h1 className={classes.heroHeader} children={hero.header} />
          <p className={classes.heroBody} children={hero.description} />
        </div>
      </div>
    );
  },

  renderHeaderLink: function(classes, category, i) {
    const id = _.kebabCase(category.title);
    return(
      <a key={i}  
        href={`#${id}`}
        onClick={this.handleHeaderLinkClick.bind(this, id)}
        className={
          this.state.activeCategory === id
            ? `${classes.headerLink} -active`
            : classes.headerLink
        }
      >
        <span className={classes.categoryDesktopTitle} children={category.title}/>
        <span className={classes.categoryMobileTitle} children={category.mobile_title}/>
      </a>
    );
  },

  renderShopLinks: function(classes, title, links, i) {
    const target = _.camelCase(`${title} ${links.title}`);
    return(
        <div className={classes.shopLinksButtonArea} key={i}>
          <a className={classes.shopLinksButton} children={links.title} href={links.url} 
              onClick={this.trackInteraction.bind(this, `lensesLanding-click-${target}`)}/> 
        </div>
    );
  },

  renderCategory: function(classes, category, i) {
    return(
      <div ref={_.kebabCase(category.title)} key={i} className={classes.outerCategory}>
        <div
          className={classes.category} 
          children={category.sections.map(this.renderSection.bind(this, classes))} 
        />
        {category.shop_links.title ?
          <div className={classes.shopLinksArea}>
             <h3 className={classes.shopLinksHeader} children={category.shop_links.title} />
             {category.shop_links.links.map(this.renderShopLinks.bind(this, classes, category.shop_links.title))}
          </div>
        : null}
      </div>
    );
  },

  renderSectionChildren: function(section, imgClass) {
    const sources = {
      sources: [
        { url: section.image,
          widths: [552, 1104],
          mediaQuery: "(min-width: 900px)",
          sizes: "552px",
          quality: 100,
        },
        { url: section.image_mobile,
          widths: [362, 724],
          mediaQuery: "(min-width: 0px)",
          sizes: "362px",
          quality: 100,
        },
      ], 
      img: {
        className: imgClass,
      },
    };
    return(
      this.getPictureChildren(sources)
    );
  },

  renderSection: function(classes, section, i) {
    const imgClass = `${classes.sectionImage} ${section.is_animation ? '-animated' : ''}`;
    let textBlockClass = ``;
    if (section.text_blocks.length > 2 ) {
      textBlockClass += `${classes.textBlocks}`;
    } 
    if (!section.image) {
      textBlockClass += ` u-mt24 u-mt0--600`;
    }
    return(
      <div className={classes.section} key={i}>
        <h3 className={classes.sectionHeader} children={section.header} />
        {Boolean(section.image) && 
          <Picture children={this.renderSectionChildren(section, imgClass)} />
        } 
        <div className={textBlockClass} 
          children={section.text_blocks.map(this.renderTextBlock.bind(this, classes, section.text_blocks.length))} />
      </div>
    );
  },

  renderTextBlock: function(classes, blockCount, textBlock, i) {
    let wrapperClass = classes.textBlock;
    if (blockCount == 1) {
      wrapperClass += ` ${classes.textBlockWithoutHeader}`;
    } 
    else if (blockCount == 2) {
      wrapperClass += ` ${classes.textBlockRow}`;
    } else {
      wrapperClass +=  ` ${classes.textBlockColumn}`;
    }
    return(
      <div className={wrapperClass} key={i}>
        <div className={classes.textBlockContainer}>
          {textBlock.header ? <p className={classes.textBlockHeader} children={textBlock.header} /> : null}
          <Markdown rawMarkdown={textBlock.description} cssBlock={classes.markdown}/>
        </div>
      </div>
    );
  },

  render: function() {
    const classes = this.getClasses();
    return(
      <div className={classes.page}>
        {this.renderHero(classes, this.props.hero)}
        <div className={classes.stickyContainer}>
          <div className={classes.headerLinks}
            children={this.props.categories.map(this.renderHeaderLink.bind(this, classes))} 
          />
        </div>
        <div children={this.props.categories.map(this.renderCategory.bind(this, classes))} />
        <h3 className={classes.shopLinksHeader} children={`Shop all our frames`} />
        <GlassesNav glasses={this.props.glasses} />
      </div>
    );
  }
});
