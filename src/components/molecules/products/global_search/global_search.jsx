const _ = require("lodash");
const React = require("react/addons");
const X = require("components/quanta/icons/thin_x/thin_x");
const Input = require("components/atoms/forms/input/input");
const ListFrame = require("components/molecules/products/global_search/list_frame/list_frame");
const Mixins = require("components/mixins/mixins");

require("./global_search.scss");

module.exports = React.createClass({
  BLOCK_CLASS: "c-global-search",

  mixins: [Mixins.analytics, Mixins.classes, Mixins.dispatcher],

  propTypes: {
    analyticsCategory: React.PropTypes.string,
    emptyMessage: React.PropTypes.string,
    filters: React.PropTypes.object,
    frames: React.PropTypes.array,
    makeSuggestionOnEmpty: React.PropTypes.bool,
    manageChange: React.PropTypes.func,
    manageClose: React.PropTypes.func,
    query: React.PropTypes.string,
    searchableProps: React.PropTypes.array,
    title: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      analyticsCategory: "globalSearch",
      filters: {},
      frames: [],
      manageClose() {},
      manageChange() {},
      emptyMessage: "Hm. Doesn’t look like we carry a frame by that name",
      makeSuggestionOnEmpty: true,
      query: "",
      searchableProps: ["display_name", "color"],
      title: ""
    };
  },

  frameRoutes: [
    { gender: "Men", assembly: "eyeglasses", url: "/eyeglasses/men" },
    { gender: "Women", assembly: "eyeglasses", url: "/eyeglasses/women" },
    { gender: "Men", assembly: "sunglasses", url: "/sunglasses/men" },
    { gender: "Women", assembly: "sunglasses", url: "/sunglasses/women" }
  ],

  getInitialState() {
    return {
      filteredProducts: [],
      isDeleting: false
    };
  },

  getStaticClasses() {
    return {
      block: this.BLOCK_CLASS,
      grid: `
        u-grid -maxed
        u-m0a
        u-pr--900
      `,
      label: `
        u-pt36 u-pb10
        u-pt60--600 u-pb16--600
        u-ffss u-fs12
        u-ttu
        u-ls3
        u-color--dark-gray-alt-3
      `,
      input: `
        ${this.BLOCK_CLASS}__input
        u-reset--button
        u-w100p
        u-ffss u-ffs--600
        u-fs16 u-fs60--600
        u-color-bg--white
        u-bc--light-gray
        u-bw1 u-bss
        u-bw0--600
        u-br1
        u-pt10 u-pb10 u-pl18 u-pr18
        u-p0--600 u-pt12--600 u-pb24--600
        u-ttc
      `,
      close: `
        u-pa
        u-t0 u-r0
        u-p18
        u-p30--600
      `,
      cancel: `
        u-fs14
        u-fws
        u-pr18
        u-color--blue
        u-dn--600
        u-pa u-t50p u-ttyn50
        u-r0
      `,
      iconX: `
        u-stroke--dark-gray
        u-dib
      `,
      divider: `
        u-dn
        u-db--600
        u-mt18 u-mb18 u-mt0--900
        u-hr-xm
      `,
      results: `
        u-pt6
        u-grid__row
      `,
      search: `
        u-pr u-ps--600
      `,
      message: `
        u-pt24
        u-ffss u-fs16 u-fs18--600
        u-color--dark-gray-alt-3
      `
    };
  },

  componentWillReceiveProps(nextProps) {
    return this.filterFrames(nextProps.query);
  },

  componentWillMount() {
    return this.filterFrames(this.props.query);
  },

  componentDidMount() {
    _.defer(() => {React.findDOMNode(this.refs.searchInput).focus()});
  },

  productsMatchingQuery(products, query) {
    return _.reduce(
      products,
      (filteredProducts, product) => {
        for (const prop of Array.from(this.props.searchableProps)) {
          let value = _.get(product, prop);
          if (!value) return filteredProducts;

          value = value.toLowerCase();
          if (value.indexOf(query) === 0 || value.indexOf(` ${query}`) !== -1) {
            filteredProducts.push(product);
          }
        }
        return filteredProducts;
      },
      []
    );
  },

  filterFrames(currentQuery) {
    const query = currentQuery.toLowerCase();
    let filteredProducts = [];
    if (
      this.state.filteredProducts.length &&
      query.length > this.props.query.length
    ) {
      filteredProducts = this.productsMatchingQuery(
        this.state.filteredProducts,
        query
      );
    } else if (query.length) {
      filteredProducts = _.reduce(
        this.props.frames,
        (memo, frame) => {
          return memo.concat(this.productsMatchingQuery(frame.products, query));
        },
        []
      );
    }

    const dedupeFilteredProducts = _.uniqBy(filteredProducts, product => product.assembly_type + product.display_name + product.color);

    return this.setState({ filteredProducts: dedupeFilteredProducts });
  },

  manageGenderClick(product) {
    this.trackInteraction(
      [
        this.props.analyticsCategory,
        "clickProduct",
        product.product_id,
        this.props.query.toLowerCase()
      ].join("-")
    );
    return this.commandDispatcher("analytics", "pushProductEvent", {
      type: "productClick",
      eventMetadata: {
        list: this.props.analyticsCategory
      },
      products: product
    });
  },

  manageProductClick(product) {
    if (product.product_id === this.state.activeProductId) {
      this.setState({ activeProductId: null });
    } else {
      this.setState({ activeProductId: product.product_id });
    }

    const ids = _.map(product.gendered_details, detail => detail.product_id)

    this.trackInteraction(
      [
        this.props.analyticsCategory,
        "toggleProduct",
        ids.join('x'),
        this.props.query.toLowerCase()
      ].join("-")
    );
  },

  handleClickMore(route) {
    return this.trackInteraction(
      [
        this.props.analyticsCategory,
        "clickAlternative",
        _.camelCase(route),
        this.props.query.toLowerCase()
      ].join("-")
    );
  },

  handleClose(evt) {
    this.trackInteraction(
      [
        this.props.analyticsCategory,
        "click",
        "closeButton",
        this.props.query.toLowerCase()
      ].join("-")
    );
    return this.props.manageClose(evt);
  },

  handleCancel(evt) {
    this.trackInteraction(
      [
        this.props.analyticsCategory,
        "click",
        "clearButton",
        this.props.query.toLowerCase()
      ].join("-")
    );
    return this.props.manageChange(_.assign({}, evt, { value: "" }));
  },

  handleChange(evt) {
    const { value } = evt.target;
    if (value.length > this.props.query.length) {
      this.setState({ isDeleting: false });
    } else if (!this.state.isDeleting) {
      this.setState({ isDeleting: true });
      this.trackInteraction(
        [
          this.props.analyticsCategory,
          "delete",
          "inputField",
          this.props.query.toLowerCase()
        ].join("-")
      );
    }
    return this.props.manageChange(evt);
  },

  getBigrams(rawStr) {
    // The string fuzzy matching in this component is a quick-and-dirty version
    // taken from http://stackoverflow.com/a/23305385. Down the road it may
    // be worth switching to http://fusejs.io

    const str = rawStr.toLowerCase();
    const bigrams = new Array(str.length - 1);
    for (let i = 0, end = bigrams.length; i <= end; i++) {
      bigrams[i] = str.slice(i, i + 2);
    }
    return bigrams;
  },

  stringSimilarity(str1, str2) {
    if (str1.length > 0 && str2.length > 0) {
      const pairs1 = this.getBigrams(str1);
      const pairs2 = this.getBigrams(str2);
      const union = pairs1.length + pairs2.length;
      let hitCount = 0;
      for (let x of Array.from(pairs1)) {
        for (let y of Array.from(pairs2)) {
          if (x === y) {
            hitCount++;
          }
        }
      }
      if (hitCount > 0) {
        return 2 * hitCount / union;
      }
    }
    return 0;
  },

  getFlattenedFilterGroups(groups) {
    const filterGroups = {};
    _.forEach(groups, (filters, groupName) => {
      if (_.isArray(filters)) {
        return (filterGroups[groupName] = filters);
      } else {
        return _.assign(filterGroups, this.getFlattenedFilterGroups(filters));
      }
    });
    return filterGroups;
  },

  getFilterRecommendation(query) {
    const flattenedFilterGroups = this.getFlattenedFilterGroups(
      this.props.filters
    );
    let topResult = {
      group: null,
      name: null,
      relevance: 0
    };
    for (const groupName in flattenedFilterGroups) {
      const filters = flattenedFilterGroups[groupName];
      for (const filterName of Array.from(filters)) {
        const relevance = this.stringSimilarity(query, filterName);
        if (relevance > topResult.relevance) {
          topResult = {
            group: groupName,
            name: filterName,
            relevance
          };
        }
      }
    }
    return topResult;
  },

  reduceFrameRouteWithAttributes(acc, route, index, routes) {
    const isLast = index === routes.length - 1;
    const href = route.url;
    const children = `${route.gender}'s ${route.assembly}`;
    const handleClick = this.handleClickMore.bind(this, route.url);
    acc.push(<a onClick={handleClick} href={href} children={children} />);
    return acc.concat(<span children={isLast ? "?" : " or "} />);
  },

  reduceFrameRouteWithFilter(reco, acc, route, index, routes) {
    const isLast = index === routes.length - 1;
    const query = `?${_.camelCase(reco.group)}=${_.camelCase(reco.name)}`;
    const href = `${route.url}${query}`;
    const children = `${route.gender}'s ${reco.name} ${route.assembly}`;
    const handleClick = this.handleClickMore.bind(this, href);

    acc.push(<a onClick={handleClick} href={href} children={children} />);
    return acc.concat(<span children={isLast ? "?" : " or "} />);
  },

  filterRouteByAttrs(route) {
    const query = (this.props.query || "").toLowerCase();
    return [route.gender.toLowerCase(), route.assembly].includes(query);
  },

  renderEmptyMessage() {
    const emptyMessage = `${this.props.emptyMessage}.`;
    if (!this.props.makeSuggestionOnEmpty) {
      return emptyMessage;
    }
    const reco = this.getFilterRecommendation(this.props.query);
    if (!reco.group) return emptyMessage;

    const frameRoutes = _.filter(this.frameRoutes, this.filterRouteByAttrs);

    return (
      <section>
        {`${emptyMessage} How about seeing `}
        {frameRoutes.length
          ? frameRoutes.reduce(this.reduceFrameRouteWithAttributes, [])
          : this.frameRoutes.reduce(
              this.reduceFrameRouteWithFilter.bind(this, reco),
              []
            )}
      </section>
    );
  },
  renderFrame(product, i, products) {
    const assemblyType = (products[i - 1] || {}).assembly_type;
    const isNewAssembly = assemblyType !== product.assembly_type;
    const key = product.assembly_type + product.display_name + product.color;
    return [
      isNewAssembly ? <div key="sep" /> : undefined,
      (
        <ListFrame
          active={this.state.activeProductId === product.product_id}
          key={key}
          manageProductClick={this.manageProductClick}
          manageGenderClick={this.manageGenderClick}
          product={product}
        />
      )
    ];
  },
  render() {
    const classes = this.getClasses();
    return (
      <div className={classes.block}>
        <div className={classes.grid}>
          <a className={classes.close} onClick={this.handleClose}>
            <X cssUtility={classes.iconX} />
          </a>
          <div
            className={classes.label}
            children={`Search ${this.props.title}`}
          />
          <div className={classes.search}>
            <Input
              ref="searchInput"
              className={classes.input}
              placeholder="Search"
              onChange={this.handleChange}
              value={this.props.query}
            />
            <a
              className={classes.cancel}
              onClick={this.handleCancel}
              children="Cancel"
            />
          </div>
        </div>
        <hr className={classes.divider} />
        <div className={classes.grid}>
          {this.state.filteredProducts.length === 0 &&
            this.props.query.length > 0
            ? <div
                className={classes.message}
                children={this.renderEmptyMessage()}
              />
            : <div
                className={classes.results}
                children={_.map(this.state.filteredProducts, this.renderFrame)}
              />}
        </div>
      </div>
    );
  }
});
