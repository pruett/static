const React = require("react/addons");
const Mixins = require("components/mixins/mixins");
const Layout = require("components/layouts/layout_default/layout_default");

module.exports = React.createClass({
  displayName: "Half Decade",

  mixins: [Mixins.context, Mixins.dispatcher],

  statics: {
    route: function() {
      return {
        path: "/half-decade",
        handler: "Default",
        title: "Half Decade",
      };
    },
  },

  render: function() {
    return (
      <Layout {...this.props}>
        <link
          rel="stylesheet"
          href="https://www.warbyparker.com/assets/css/legacy/desktop.css"
        />

        <link
          rel="stylesheet"
          href="https://www.warbyparker.com/assets/css/legacy/collections/half_decade_desktop.css"
        />
        <style>
          {`#half-decade .half-decade-shop { width: auto;}
          #half-decade { min-width: 0; } .video-player .video-player-bg {
            background-image: url(https://www.warbyparker.com/assets/css/legacy/collections/half_decade/video_image.jpg)
          }`}
        </style>
        <div id="half-decade">
          <div className="header">
            <div className="video-bg">
              <video
                autoPlay="autoplay"
                loop="loop"
                muted="muted"
                poster="https://www.warbyparker.com/assets/css/legacy/collections/half_decade/video_transparent.png?v=cd2dc1c57ce150b786b9aedce923b4ea"
                id="video-bg-video"
              >
                <source
                  src="https://www.warbyparker.com/assets/css/legacy/collections/half_decade/half_decade_parade.mp4?v=6f72a30bf211d8d7c8b19e6243085eb8"
                  type="video/mp4"
                />
                <source
                  src="https://www.warbyparker.com/assets/css/legacy/collections/half_decade/half_decade_parade.webm?v=203137691e446861b2d5fcdbe4fb868c"
                  type="video/webm"
                />
              </video>
            </div>
            <div className="half-decade-text">
              <div className="messaging">
                <div className="message">
                  <h3>
                    <p>We're celebrating </p>
                    <p>our fifth birthday</p>
                  </h3>
                </div>
              </div>
            </div>
          </div>
          <div className="container half-decade-intro">
            <p />
            <p>
              ...first with a parade (the smallest biggest one ever) and now,
            </p>
            <p>with five and a half frames in signature blue hues</p><p />
          </div>
          <div className="container">
            <div className="half-decade-shop">
              <div className="col frame">
                <div className="product">
                  <div className="product-images">
                    <div className="imageset">
                      <img
                        srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/roosevelt/1/8536c0a055/349x104/ee00.png"
                        alt="Roosevelt Blue Slate Fade - Half Decade Collection"
                        className="product-image active"
                      />
                    </div>
                  </div>
                  <h4 className="product-title">
                    Roosevelt
                    <span className="product-color active">Blue Slate Fade</span>
                  </h4>
                  <div className="buttons">
                    <div className="product-links active">
                      <div className="sold-out">
                        Sold out
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div className="col frame">
                <div className="product">
                  <div className="product-images">
                    <div className="imageset">
                      <img
                        srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/fillmore/1/9bd32d28e3/364x106/4980.png"
                        alt="Fillmore Harbor Blue - Half Decade Collection"
                        className="product-image active"
                      />
                    </div>
                  </div>
                  <h4 className="product-title">
                    Fillmore
                    <span className="product-color active">Harbor Blue</span>
                  </h4>
                  <div className="buttons">
                    <div className="product-links active">
                      <div className="sold-out">
                        Sold out
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div className="col frame">
                <div className="product">
                  <div className="product-images">
                    <div className="imageset">
                      <img
                        srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/wiloughby/1/fa1ddaf3cc/348x98/c1d7.png"
                        alt="Wiloughby Striped Indigo - Half Decade Collection"
                        className="product-image active"
                      />
                    </div>
                  </div>
                  <h4 className="product-title">
                    Wiloughby
                    <span className="product-color active">Striped Indigo</span>
                  </h4>
                  <div className="buttons">
                    <div className="product-links active">
                      <div className="sold-out">
                        Sold out
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div className="col frame">
                <div className="product">
                  <div className="product-images">
                    <div className="imageset">
                      <img
                        srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/huxley/1/b718bd4a75/347x100/a9f7.png"
                        alt="Huxley Eastern Bluebird Fade - Half Decade Collection"
                        className="product-image active"
                      />
                    </div>
                  </div>
                  <h4 className="product-title">
                    Huxley
                    <span className="product-color active">
                      Eastern Bluebird Fade
                    </span>
                  </h4>
                  <div className="buttons">
                    <div className="product-links active">
                      <div className="sold-out">
                        Sold out
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div className="col frame">
                <div className="product">
                  <div className="product-images">
                    <div className="imageset">
                      <img
                        srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/nedwin/1/b3a2e6198a/344x76/0ab7.png"
                        alt="Nedwin Blue Sapphire - Half Decade Collection"
                        className="product-image active"
                      />
                    </div>
                  </div>
                  <h4 className="product-title">
                    Nedwin
                    <span className="product-color active">Blue Sapphire</span>
                  </h4>
                  <div className="buttons">
                    <div className="product-links active">
                      <div className="sold-out">
                        Sold out
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div className="col frame">
                <div className="product">
                  <div className="product-images monocle">
                    <div className="imageset">
                      <img
                        srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/monocle/2/f5da252669/400x150/c4e2.png"
                        alt="The Colonel monocle Atlas Blue - Half Decade Collection"
                        className="product-image active"
                      />
                    </div>
                  </div>
                  <h4 className="product-title">
                    The Colonel monocle
                    <span className="product-color active">Atlas Blue</span>
                  </h4>
                  <div className="buttons">
                    <div className="product-links active">
                      <div className="sold-out">
                        Sold out
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="container">
            <div className="photos-layout">
              <div className="photo-left-col">
                <img
                  srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/photo-1/2/e79b7521ab/284x510/c3ec.png"
                  alt="Half Decade Collection"
                />
                <img
                  srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/photo-2/2/0e721eefea/284x178/b5e6.png"
                  alt="Half Decade Collection"
                />
                <img
                  srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/photo-3/2/1cef845668/284x184/d101.png"
                  alt="Half Decade Collection"
                />
              </div>
              <div className="photo-center-col">
                <img
                  srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/photo-4/1/8653ad6b7c/463x695/8e82.png"
                  alt="Half Decade Collection"
                />
                <img
                  srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/photo-5/2/c31c4efbd5/447x298/9161.png"
                  alt="Half Decade Collection"
                />
              </div>
              <div className="photo-right-col">
                <img
                  srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/photo-6/2/d7d70dc27c/284x230/ffd7.png"
                  alt="Half Decade Collection"
                />
                <img
                  srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/photo-7/0/1648580a1f/284x212/64dd.png"
                  alt="Half Decade Collection"
                />
                <img
                  srcSet="//i.warbycdn.com/v/c/assets/half-decade/image/photo-8/0/24797703dc/284x430/5173.png"
                  alt="Half Decade Collection"
                />
              </div>
            </div>
            <div data-video-id="Hnk5-gIw_w8" className="video-player">
              <div className="video-player-bg">
                <div className="play-btn-container">
                  <div className="play-btn">
                  <a href="https://www.youtube.com/watch?v=Hnk5-gIw_w8" target="_blank">
                    <img
                      src="//i.warbycdn.com/v/c/assets/half-decade/image/desktop-play-btn/1/1f380250a2.png"
                      alt="Half Decade Collection"
                    />
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="container">
            <a className="tagline" href="https://www.youtube.com/watch?v=Hnk5-gIw_w8" target="_blank">
              <h3>
                Watch the smallest biggest parade ever
                <span>
                  <img
                    src="//i.warbycdn.com/v/c/assets/half-decade/image/right-icon/0/6489404dd4.png"
                    alt="Half Decade Collection"
                  />
                </span>
              </h3>
            </a>
          </div>
          <script type="text/javascript">
            WP_COLLECTION_LIST_VALUE = 'collection_half_decade';
            WP_COLLECTION_MAX_ROW_COUNT = 3;
          </script>
        </div>{" "}
      </Layout>
    );
  },
});
