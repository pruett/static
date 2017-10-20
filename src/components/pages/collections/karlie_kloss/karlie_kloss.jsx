const React = require("react/addons");
const Mixins = require("components/mixins/mixins");
const Layout = require("components/layouts/layout_default/layout_default");

module.exports = React.createClass({
  displayName: "Karlie Kloss",

  mixins: [Mixins.context, Mixins.dispatcher],

  statics: {
    route: function() {
      return {
        path: "/karlie-kloss",
        handler: "Default",
        title: "Karlie Kloss",
      };
    },
  },

  render: function() {
    return (
      <Layout {...this.props}>
        <link
          rel="stylesheet"
          href="https://www.warbyparker.com/assets/css/legacy/base.css"
        />
        <link
          rel="stylesheet"
          href="https://www.warbyparker.com/assets/css/legacy/desktop.css"
        />

        <link
          rel="stylesheet"
          href="https://www.warbyparker.com/assets/css/legacy/collections/karlie-kloss.css"
        />

        <div id="karlie-kloss" style={{ margin: "0 auto" }}>
          <div className="karlie-kloss">
            <div className="row desktop-only">
              <div className="small-12 columns karlie-kloss-top">
                <div className="karlie-kloss-top-content">
                  <p>
                    <i style={{ fontWeight: "normal" }}>
                      we both had the exact same thing<br />
                      in mind from the start: fresh and<br />
                      flattering sunglasses that are lively<br />
                      and graceful—with a nice helping<br />
                      of personality.
                    </i>
                  </p>
                </div>
                <div className="karlie-kloss-top-price">
                  <p>
                    $145 each, featuring ultra-strong<br />
                    and lightweight Japanese titanium
                  </p>
                </div>
                <a href="/sunglasses/women/clara#heirloom-gold">
                  <div
                    className="karlie-kloss-top-credits"
                    data-scroll-reveal="enter"
                  >
                    <p>
                      Clara in Heirloom Gold<br />
                      <span className="lenses">with Copper Fade lenses</span>
                    </p>
                  </div>
                </a>
              </div>
            </div>
            <div className="row mobile-only">
              <div className="small-12 columns">
                <img
                  className="karlie-kloss-image"
                  src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/karlie-top-hero-mobile.jpg"
                />
                <p className="karlie-kloss-top-content">
                  <i>
                    we both had the exact same thing in mind from<br />
                    the start: fresh and flattering sunglasses that are<br />
                    lively and graceful—with a nice helping<br />
                    of personality.
                  </i>
                </p>
                <img src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/karlie-kloss-mobile-image.jpg" />
                <p className="karlie-kloss-top-price">
                  <i>
                    $145 each, featuring ultra-strong and<br />
                    lightweight Japanese titanium
                  </i>
                </p>
                <img
                  className="karlie-kloss-image"
                  src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/mobile-divider-down.jpg"
                />
              </div>
            </div>
            <div className="row desktop-only">

              <div className="small-12 columns product-wrapper">
                <div className="small-7 columns">

                  <div
                    className="product-image"
                    data-scroll-reveal="after 0.5s, ease-in-out 14px and reset over .66s"
                    data-wp-frame-id="clara-frame"
                  >
                    <div className="color-wrap">
                      <div className="image-wrap front">
                        <a
                          className="frame-image"
                          href="/sunglasses/women/clara#heirloom-silver"
                          rel="0259_2190_SNK"
                        >
                          <img src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/clara-frames.jpg" />
                        </a>
                      </div>
                    </div>
                    <div className="color-wrap">
                      <div className="image-wrap front">
                        <a
                          className="frame-image"
                          href="/sunglasses/women/clara#heirloom-gold"
                          rel="0259_2200_SNK"
                        >
                          <img src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/clara-frames-2.jpg" />
                        </a>
                      </div>
                    </div>
                  </div>

                  <div
                    className="color-dots"
                    data-wp-frame-id="clara-frame"
                    data-wp-frame-to-switch="clara-frame"
                    data-wp-switch-type="active"
                  >
                    <div className="dot active">
                      <div className="dot-inner" />
                    </div>
                    <div className="dot">
                      <div className="dot-inner" />
                    </div>
                  </div>
                </div>
                <div className="small-4 columns frame-divider">

                  <p className="product-name" data-scroll-reveal="enter">
                    <img src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/clara-frame-name.jpg" />
                    <br />
                    <span data-wp-frame-id="clara-frame">
                      <a
                        style={{ fontWeight: "normal" }}
                        href="/sunglasses/women/clara#heirloom-silver"
                      >
                        <span className="title">
                          Heirloom Silver
                          <br />
                          <span className="lenses lenses-name-left">
                            with Sepia Wash lenses
                          </span>
                        </span>
                      </a>
                      <a href="/sunglasses/women/clara#heirloom-gold">
                        <span className="title">
                          <strong>Heirloom Gold</strong>
                          <br />
                          <span className="lenses lenses-name-left">
                            with Copper Fade lenses
                          </span>
                        </span>
                      </a>
                    </span>
                  </p>

                  <div
                    className="btn-wrapper"
                    data-scroll-reveal="enter"
                    data-wp-frame-id="clara-frame"
                  >
                    <div className="shop-btn-group">
                      <a
                        className="button-clara shop-women"
                        href="/sunglasses/women/clara#heirloom-silver"
                        rel="0259_2190_SNK"
                      >
                        <span>Shop now</span>
                      </a>
                    </div>
                    <div className="shop-btn-group">
                      <a
                        className="button-clara-2 shop-women"
                        href="/sunglasses/women/clara#heirloom-gold"
                        rel="0259_2200_SNK"
                      >
                        <span>Shop now</span>
                      </a>
                    </div>
                  </div>
                </div>
              </div>

              <div className="small-12 columns product-wrapper">
                <div className="small-4 columns frame-divider-2">

                  <p className="product-name" data-scroll-reveal="enter">
                    <img
                      className="marple-name"
                      src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/marple-frame-name.jpg"
                    />
                    <br />
                    <span data-wp-frame-id="marple-frame">
                      <a href="/sunglasses/women/marple#heirloom-gold">
                        <span className="marple-title">
                          <strong>Heirloom Gold</strong>
                          <br />
                          <span className="lenses marple-lenses-left">
                            with Violet Clover lenses
                          </span>
                        </span>
                      </a>
                      <a href="/sunglasses/women/marple#heirloom-silver">
                        <span className="marple-title-2">
                          <strong>Heirloom Silver</strong>
                          <br />
                          <span className="lenses marple-lenses-left-2">
                            with Faded Slate lenses
                          </span>
                        </span>
                      </a>
                    </span>
                  </p>

                  <div
                    className="btn-wrapper marple-tablet-wrapper"
                    data-scroll-reveal="enter"
                    data-wp-frame-id="marple-frame"
                  >
                    <div className="shop-btn-group marple-btn-group">
                      <a
                        className="button-marple shop-women"
                        href="/sunglasses/women/marple#heirloom-gold"
                        rel="0258_2242_SNK"
                      >
                        <span>Shop now</span>
                      </a>
                    </div>
                    <div className="shop-btn-group marple-btn-group">
                      <a
                        className="button-marple-2 shop-women"
                        href="/sunglasses/women/marple#heirloom-silver"
                        rel="0258_2160_SNK"
                      >
                        <span>Shop now</span>
                      </a>
                    </div>
                  </div>
                </div>
                <div className="small-7 columns marple-column">

                  <div
                    className="product-image"
                    data-scroll-reveal="after 0.5s, ease-in-out 14px and reset over .66s"
                    data-wp-frame-id="marple-frame"
                  >
                    <div className="color-wrap">
                      <div className="image-wrap">
                        <a
                          className="frame-image"
                          href="/sunglasses/women/marple#heirloom-gold"
                          rel="0258_2242_SNK"
                        >
                          <img src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/marple-frames.jpg" />
                        </a>
                      </div>
                    </div>
                    <div className="color-wrap">
                      <div className="image-wrap">
                        <a
                          className="frame-image"
                          href="/sunglasses/women/marple#heirloom-silver"
                          rel="0258_2160_SNK"
                        >
                          <img src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/marple-frames-2.jpg" />
                        </a>
                      </div>
                    </div>
                  </div>

                  <div
                    className="color-dots"
                    data-wp-frame-id="marple-frame"
                    data-wp-frame-to-switch="marple-frame"
                    data-wp-switch-type="active"
                  >
                    <div className="dot active">
                      <div className="dot-inner" />
                    </div>
                    <div className="dot">
                      <div className="dot-inner" />
                    </div>
                  </div>
                </div>
              </div>

              <div className="small-12 columns product-wrapper">
                <div className="small-7 columns">

                  <div
                    className="product-image"
                    data-scroll-reveal="after 0.5s, ease-in-out 14px and reset over .66s"
                    data-wp-frame-id="julia-frame"
                  >
                    <div className="color-wrap">
                      <div className="image-wrap">
                        <a
                          className="frame-image"
                          href="/sunglasses/women/julia#heirloom-silver"
                          rel="0260_2160_SNK"
                        >
                          <img src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/julia-frames.jpg" />
                        </a>
                      </div>
                    </div>
                    <div className="color-wrap">
                      <div className="image-wrap">
                        <a
                          className="frame-image"
                          href="/sunglasses/women/julia#heirloom-gold"
                          rel="0260_2256_SNK"
                        >
                          <img src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/julia-frames-2.jpg" />
                        </a>
                      </div>
                    </div>
                  </div>

                  <div
                    className="color-dots"
                    data-wp-frame-id="julia-frame"
                    data-wp-frame-to-switch="julia-frame"
                    data-wp-switch-type="active"
                  >
                    <div className="dot active">
                      <div className="dot-inner" />
                    </div>
                    <div className="dot">
                      <div className="dot-inner" />
                    </div>
                  </div>
                </div>
                <div className="small-4 columns frame-divider">

                  <p className="product-name" data-scroll-reveal="enter">
                    <img src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/julia-frame-name.jpg" />
                    <br />
                    <span data-wp-frame-id="julia-frame">
                      <a href="/sunglasses/women/julia#heirloom-silver">
                        <span className="title">
                          <strong>Heirloom Silver</strong>
                          <br />
                          <span className="lenses lenses-name-left">
                            with Indigo Wash lenses
                          </span>
                        </span>
                      </a>
                      <a href="/sunglasses/women/julia#heirloom-gold">
                        <span className="title">
                          <strong>Heirloom Gold</strong>
                          <br />
                          <span className="lenses lenses-name-left">
                            with Copper Fade lenses
                          </span>
                        </span>
                      </a>
                    </span>
                  </p>

                  <div
                    className="btn-wrapper"
                    data-scroll-reveal="enter"
                    data-wp-frame-id="julia-frame"
                  >
                    <div className="shop-btn-group">
                      <a
                        className="button-julia shop-women"
                        href="/sunglasses/women/julia#heirloom-silver"
                        rel="0260_2160_SNK"
                      >
                        <span>Shop now</span>
                      </a>
                    </div>
                    <div className="shop-btn-group">
                      <a
                        className="button-julia-2 shop-women"
                        href="/sunglasses/women/julia#heirloom-gold"
                        rel="0260_2256_SNK"
                      >
                        <span>Shop now</span>
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="row mobile-only">
              <ul className="small-12 columns small-block-grid-1">

                <li className="product-wrapper columns first">
                  <div className="mobile-width" id="swipe-list-1">
                    <ul className="color-list">

                      <li className="frame-list first-frame">
                        <div className="product-image">
                          <div className="color-wrap">
                            <div className="image-wrap front">
                              <a
                                className="frame-image"
                                href="/sunglasses/women/clara#heirloom-silver"
                                rel="0259_2190_SNK"
                              >
                                <img
                                  className="karlie-kloss-frames"
                                  src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/clara-frames.jpg"
                                />
                              </a>
                            </div>
                          </div>
                          <p className="swipe"><i>swipe for more colors</i></p>
                          <a href="/sunglasses/women/clara#heirloom-silver">
                            <img
                              className="frame-name"
                              src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/clara-frame-name.jpg"
                            />
                          </a>
                          <a href="/sunglasses/women/clara#heirloom-silver">
                            <p className="frame-style">
                              Heirloom Silver with Sepia Wash lenses
                            </p>
                          </a>
                          <div className="btn-wrapper">
                            <div className="shop-btn-group">
                              <a
                                className="button-clara shop-women"
                                href="/sunglasses/women/clara#heirloom-silver"
                                rel="0259_2190_SNK"
                              >
                                <span>Shop now</span>
                              </a>
                            </div>
                          </div>
                        </div>
                      </li>

                      <li className="frame-list second-frame">
                        <div className="product-image">
                          <div className="color-wrap">
                            <div className="image-wrap front">
                              <a
                                className="frame-image"
                                href="/sunglasses/women/clara#heirloom-gold"
                                rel="0259_2200_SNK"
                              >
                                <img
                                  className="karlie-kloss-frames"
                                  src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/clara-frames-2.jpg"
                                />
                              </a>
                            </div>
                          </div>
                          <p className="swipe"><i>swipe for more colors</i></p>
                          <a href="/sunglasses/women/clara#heirloom-gold">
                            <img
                              className="frame-name"
                              src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/clara-frame-name.jpg"
                            />
                          </a>
                          <a href="/sunglasses/women/clara#heirloom-gold">
                            <p className="frame-style">
                              Heirloom Gold with Copper Fade lenses
                            </p>
                          </a>
                          <div className="btn-wrapper">
                            <div className="shop-btn-group">
                              <a
                                className="button-clara-2 shop-women"
                                href="/sunglasses/women/clara#heirloom-gold"
                                rel="0259_2200_SNK"
                              >
                                <span>Shop now</span>
                              </a>
                            </div>
                          </div>
                        </div>
                      </li>
                    </ul>
                  </div>
                  <script type="text/javascript">
                    window.mobileSwipe1 = new Swipe(document.getElementById("swipe-list-1"));
                  </script>
                </li>

                <li className="product-wrapper columns first">
                  <div className="mobile-width" id="swipe-list-2">
                    <ul className="color-list">

                      <li className="frame-list third-frame">
                        <div className="product-image">
                          <div className="color-wrap">
                            <div className="image-wrap front">
                              <a
                                className="frame-image"
                                href="/sunglasses/women/marple#heirloom-gold"
                                rel="0258_2242_SNK"
                              >
                                <img
                                  className="karlie-kloss-frames"
                                  src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/marple-frames.jpg"
                                />
                              </a>
                            </div>
                          </div>
                          <p className="swipe"><i>swipe for more colors</i></p>
                          <a href="/sunglasses/women/marple#heirloom-gold">
                            <img
                              className="frame-name"
                              src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/marple-frame-name.jpg"
                            />
                          </a>
                          <a href="/sunglasses/women/marple#heirloom-gold">
                            <p className="frame-style">
                              Heirloom Gold with Violet Clover lenses
                            </p>
                          </a>
                          <div className="btn-wrapper">
                            <div className="shop-btn-group">
                              <a
                                className="button-marple shop-women"
                                href="/sunglasses/women/marple#heirloom-gold"
                                rel="0258_2242_SNK"
                              >
                                <span>Shop now</span>
                              </a>
                            </div>
                          </div>
                        </div>
                      </li>

                      <li className="frame-list fourth-frame">
                        <div className="product-image">
                          <div className="color-wrap">
                            <div className="image-wrap front">
                              <a
                                className="frame-image"
                                href="/sunglasses/women/marple#heirloom-silver"
                                rel="0258_2160_SNK"
                              >
                                <img
                                  className="karlie-kloss-frames"
                                  src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/marple-frames-2.jpg"
                                />
                              </a>
                            </div>
                          </div>
                          <p className="swipe"><i>swipe for more colors</i></p>
                          <a href="/sunglasses/women/marple#heirloom-silver">
                            <img
                              className="frame-name"
                              src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/marple-frame-name.jpg"
                            />
                          </a>
                          <a href="/sunglasses/women/marple#heirloom-silver">
                            <p className="frame-style">
                              Heirloom Silver with Faded Slate lenses
                            </p>
                          </a>
                          <div className="btn-wrapper">
                            <div className="shop-btn-group">
                              <a
                                className="button-marple-2 shop-women"
                                href="/sunglasses/women/marple#heirloom-silver"
                                rel="0258_2160_SNK"
                              >
                                <span>Shop now</span>
                              </a>
                            </div>
                          </div>
                        </div>
                      </li>
                    </ul>
                  </div>
                  <script type="text/javascript">
                    window.mobileSwipe1 = new Swipe(document.getElementById("swipe-list-2"));
                  </script>
                </li>

                <li className="product-wrapper columns first">
                  <div className="mobile-width" id="swipe-list-3">
                    <ul className="color-list">

                      <li className="frame-list fifth-frame">
                        <div className="product-image">
                          <div className="color-wrap">
                            <div className="image-wrap front">
                              <a
                                className="frame-image"
                                href="/sunglasses/women/julia#heirloom-silver"
                                rel="0260_2160_SNK"
                              >
                                <img
                                  className="karlie-kloss-frames"
                                  src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/julia-frames.jpg"
                                />
                              </a>
                            </div>
                          </div>
                          <p className="swipe"><i>swipe for more colors</i></p>
                          <a href="/sunglasses/women/julia#heirloom-silver">
                            <img
                              className="frame-name"
                              src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/julia-frame-name.jpg"
                            />
                          </a>
                          <a href="/sunglasses/women/julia#heirloom-silver">
                            <p className="frame-style">
                              Heirloom Silver with Indigo Wash lenses
                            </p>
                          </a>
                          <div className="btn-wrapper">
                            <div className="shop-btn-group">
                              <a
                                className="button-julia shop-women"
                                href="/sunglasses/women/julia#heirloom-silver"
                                rel="0260_2160_SNK"
                              >
                                <span>Shop now</span>
                              </a>
                            </div>
                          </div>
                        </div>
                      </li>

                      <li className="frame-list six-frame">
                        <div className="product-image">
                          <div className="color-wrap">
                            <div className="image-wrap front">
                              <a
                                className="frame-image"
                                href="/sunglasses/women/julia#heirloom-gold"
                                rel="0260_2256_SNK"
                              >
                                <img
                                  className="karlie-kloss-frames"
                                  src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/julia-frames-2.jpg"
                                />
                              </a>
                            </div>
                          </div>
                          <p className="swipe"><i>swipe for more colors</i></p>
                          <a href="/sunglasses/women/julia#heirloom-gold">
                            <img
                              className="frame-name"
                              src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/julia-frame-name.jpg"
                            />
                          </a>
                          <a href="/sunglasses/women/julia#heirloom-gold">
                            <p className="frame-style">
                              Heirloom Gold with Copper Fade lenses
                            </p>
                          </a>
                          <div className="btn-wrapper">
                            <div className="shop-btn-group">
                              <a
                                className="button-julia-2 shop-women"
                                href="/sunglasses/women/julia#heirloom-gold"
                                rel="0260_2256_SNK"
                              >
                                <span>Shop now</span>
                              </a>
                            </div>
                          </div>
                        </div>
                      </li>
                    </ul>
                  </div>
                  <script type="text/javascript">
                    window.mobileSwipe1 = new Swipe(document.getElementById("swipe-list-3"));
                  </script>
                </li>
              </ul>
            </div>
            <div className="small-12 columns desktop-only karlie-kloss-bottom">
              <div className="small-7 columns">
                <img
                  data-scroll-reveal="enter"
                  src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/karlie-bottom-image.jpg"
                />
              </div>
              <div className="small-4 columns">
                <div data-scroll-reveal="enter">
                  <img
                    className="edible-title"
                    src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/edible-title.jpg"
                  />
                  <p className="karlie-kloss-bottom-text">
                    To celebrate our partnership, we're donating<br />
                    to an organization dear to Karlie.<br /><br />
                    Edible Schoolyard NYC works with low-income<br />
                    NYC public schools to build kitchens and gardens<br />
                    where they teach students to develop lifelong
                    {" "}
                    <br />
                    healthy habits.
                    <br />
                    <br />
                    The donation will benefit two community<br />
                    farm stands in Brooklyn and East Harlem,<br />
                    where kids learn about food preparation in <br />
                    their own neighborhoods.<br /><br />
                    And as always, for every pair sold, a pair<br />
                    is distributed to someone in need.
                  </p>
                </div>
                <a href="//warbyparker.com/sunglasses/women/marple#heirloom-silver">
                  <div
                    className="karlie-kloss-bottom-credits"
                    data-scroll-reveal="enter"
                  >
                    <p>
                      Marple in Heirloom Silver<br />
                      <span className="lenses">with Faded Slate lenses</span>
                    </p>
                  </div>
                </a>
              </div>
            </div>
            <div className="row mobile-only">
              <div className="small-12 columns" style={{ margin: "40px 0" }}>
                <img src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/karlie-bottom-hero-mobile.jpg" />
                <p className="karlie-kloss-bottom-content">
                  To celebrate our partnership, we're donating<br />
                  to an organization dear to Karlie.<br /><br />
                  Edible Schoolyard NYC gives low-income<br />
                  public schools kitchens and gardens to help<br />
                  students develop lifelong healthy habits.<br /><br />
                  The donation will benefit two community<br />
                  farm stands in Brooklyn and East Harlem,<br />
                  where kids learn about food preparation in<br />
                  their own neighborhoods.<br /><br />
                  And as always, for every pair sold, a pair is<br />
                  distributed to someone in need.
                </p>
                <img
                  className="karlie-kloss-image"
                  src="//s1.warbyparker.com/media/wysiwyg//karlie-kloss-2014/mobile-divider-up.jpg"
                />
              </div>
            </div>
          </div>
        </div>

      </Layout>
    );
  },
});
