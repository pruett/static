[
  React

  Mixins

] = [
  require 'react/addons'

  require 'components/mixins/mixins'

  require './progressives.scss'
]

TypeKit = require 'components/atoms/scripts/typekit/typekit'

module.exports = React.createClass

  mixins: [
    Mixins.analytics
    Mixins.context
  ]

  componentWillUpdate: ->
    false

  render: ->
    country = @getLocale 'country'
    prices =
      if @getLocale('country') is 'CA'
        opticalAcetate: 475
        opticalTitanium: 550
        sunwearAcetate: 600
        sunwearTitanium: 675
      else
        opticalAcetate: 295
        opticalTitanium: 345
        sunwearAcetate: 375
        sunwearTitanium: 425

    <div>
      <TypeKit typeKitModifier='jsl1ymy' />
      <div id="progressives-legacy" className="body-block-container">

        <div id="progressives-desktop">
          <div className="breadcrumbs-container">
            <ul className="breadcrumbs breadcrumbs-main">
              <li>
                <a href="/" onClick={@trackInteraction.bind @, "progressives-click-breadcrumb"} className="js-ga-click" data-ga-category="" data-ga-action="Click-Breadcrumb" data-ga-label="Home-Home">
                Home
                </a>
              </li>
              <li className="end">
                Progressives
              </li>
            </ul>
          </div>
          <div className="full-length-line"></div>
          <div id="progressives-page">
            <div className="row header-row">
              <div className="header-text">
                <h1>
                  Progressives
                </h1>
                <p>{"We offer digital free-form progressive lenses in either eyeglasses or sunglasses, starting at $#{prices.opticalAcetate}."}</p>
                <p>Progressive lenses offer a seamless transition from distance correction on top to reading correction on bottom. That means you can see your whole field of vision without switching between multiple pairs of glasses. (Life hack!)</p>
              </div>
              <div className="in-between-space"></div>
              <div className="progressives-illustration"><img alt="Progressives Illustrated" srcSet="//i.warbycdn.com/v/c/assets/progressives/image/progressives-header/0/f5bb65ab4e/497x276/5d9a.jpg" />
              </div>
            </div>
            <div className="row">
              <div className="about-header">
                <h2>
                  About our progressives
                </h2>
              </div>
            </div>
            <div className="full-length-line"></div>
            <div className="row">
              <div className="about-row">
                <div className="text-info-container">
                  <div className="bullet-illustration lens-illo"><img srcSet="//i.warbycdn.com/v/c/assets/progressives/image/section-lens/0/94589566b7/81x81/c302.png" />
                  </div>
                  <div className="text-info-paragraph">
                    <p>At Warby Parker, we use digital free‑form lenses, which are the most advanced in progressive technology.</p>
                  </div>
                </div>
                <div className="text-info-container middle-text-info">
                  <div className="bullet-illustration seg-height-illo"><img srcSet="//i.warbycdn.com/v/c/assets/progressives/image/section-segheight/0/c78a669a59/92x68/7984.png" />
                  </div>
                  <div className="text-info-paragraph">
                    <p>We use predictive technology to determine segment height based on your individual prescription, as well as your desired frame shape and size.</p>
                  </div>
                </div>
                <div className="text-info-container">
                  <div className="bullet-illustration triangle-illo"><img srcSet="//i.warbycdn.com/v/c/assets/progressives/image/section-design/0/8ca780c9b2/77x92/91b4.png" />
                  </div>
                  <div className="text-info-paragraph">
                    <p>Applied digitally, the design is more precise than that of conventional progressives models. Added bonus: the application also provides a larger field of vision for the wearer.</p>
                  </div>
                </div>
              </div>
            </div>
            <br className="clear" />
            <div className="row">
              <div className="price-container">
                <table className="price-table">
                  <tbody>
                    <tr>
                      <th className="pricing-for-progressives">
                        <div>Pricing for progressives
                        </div>
                      </th>
                      <th colSpan="2" className="optical">
                        <div>Eyeglasses
                        </div>
                      </th>
                      <th colSpan="2" className="sunwear">
                        <div>Sunglasses
                        </div>
                      </th>
                    </tr>
                    <tr>
                      <td>&nbsp;</td>
                      <td className="left-price-box price-box acetate-optical-price-box">
                        <div><span className="material">Acetate</span><br />Starting at
                          <span className="price-dollars"> {"$#{prices.opticalAcetate}"}</span>
                        </div>
                      </td>
                      <td className="right-price-box price-box titanium-optical-price-box">
                        <div><span className="material">Titanium</span><br />Starting at
                          <span className="price-dollars"> {"$#{prices.opticalTitanium}"}</span>
                        </div>
                      </td>
                      <td className="left-price-box price-box acetate-sunwear-price-box">
                        <div><span className="material">Acetate</span><br />Starting at
                          <span className="price-dollars"> {"$#{prices.sunwearAcetate}"}</span>
                        </div>
                      </td>
                      <td className="right-price-box price-box titanium-sunwear-price-box">
                        <div><span className="material">Titanium</span><br />Starting at
                          <span className="price-dollars"> {"$#{prices.sunwearTitanium}"}</span>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
            <div className="row">
              <div className="shop-boxes">
                <div className="shop-container">
                  <div className="shop-label"><span>Shop Men</span>
                  </div>
                  <div className="thumb-wrapper">
                    <div className="inner-thumb-wrapper">
                      <ul className="small-block-grid-2">
                        <li>
                          <a onClick={@trackInteraction.bind @, "progressives-click-mensOptical"} href="/eyeglasses/men" className="ga-nav-promo js-ga-click" data-promo-name="main_nav_men_shop_all_optical" data-promo-creative="dorset_357" data-promo-position="main_nav_shop_all_tile_1" data-ga-category="submenu nav men" data-ga-action="click" data-ga-label="dorset_357 pos_1">
                            <div className="thumbnail-wrapper">
                              <div className="thumbnail"><img src="//i.warbycdn.com/d/f/4f7911b24d3af809100637a7f0661d6ac10d38b0" alt="Eyeglasses - Men" /></div>
                            </div>
                            <div className="label">Eyeglasses</div>
                          </a>
                        </li>
                        <li>
                          <a onClick={@trackInteraction.bind @, "progressives-click-mensSunwear"} href="/sunglasses/men" className="ga-nav-promo js-ga-click" data-promo-name="main_nav_men_shop_all_sunwear" data-promo-creative="dempsey_2150" data-promo-position="main_nav_shop_all_tile_2" data-ga-category="submenu nav men" data-ga-action="click" data-ga-label="dempsey_2150 pos_2">
                            <div className="thumbnail-wrapper">
                              <div className="thumbnail"><img src="//i.warbycdn.com/d/f/2ab93717a0bf5a7576747a83647808daad1f902c" alt="Sunglasses - Men" /></div>
                            </div>
                            <div className="label">Sunglasses</div>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
                <div className="spacer-div"></div>
                <div className="shop-container">
                  <div className="shop-label"><span>Shop Women</span>
                  </div>
                  <div className="thumb-wrapper">
                    <div className="inner-thumb-wrapper">
                      <ul className="small-block-grid-2">
                        <li>
                          <a onClick={@trackInteraction.bind @, "progressives-click-womensOptical"} href="/eyeglasses/women" className="ga-nav-promo js-ga-click" data-promo-name="main_nav_women_shop_all_optical" data-promo-creative="laurel_728" data-promo-position="main_nav_shop_all_tile_1" data-ga-category="submenu nav women" data-ga-action="click" data-ga-label="laurel_728 pos_1">
                            <div className="thumbnail-wrapper">
                              <div className="thumbnail"><img src="//i.warbycdn.com/d/f/daf75f711776ccb15e2e3c7ec761e5368ee0fe2f" alt="Eyeglasses - Women" /></div>
                            </div>
                            <div className="label">Eyeglasses</div>
                          </a>
                        </li>
                        <li>
                          <a onClick={@trackInteraction.bind @, "progressives-click-womensSunwear"} href="/sunglasses/women" className="ga-nav-promo js-ga-click" data-promo-name="main_nav_women_shop_all_sunwear" data-promo-creative="reilly_195" data-promo-position="main_nav_shop_all_tile_2" data-ga-category="submenu nav women" data-ga-action="click" data-ga-label="reilly_195 pos_2">
                            <div className="thumbnail-wrapper">
                              <div className="thumbnail"><img src="//i.warbycdn.com/d/f/fa37de6b4278180ce57fa6b191c3cebb5ef8ffdd" alt="Sunglasses - Men" /></div>
                            </div>
                            <div className="label">Sunglasses</div>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div id="progressives-mobile">
          <div id="progressives-page">
            <div className="row header-row">
              <h1>
                Progressives
              </h1>
              <img alt="Progressives Illustrated" srcSet="//i.warbycdn.com/v/c/assets/progressives/image/progressives-header/0/f5bb65ab4e/497x276/5d9a.jpg" className="big-illo" />
              <p>{"We offer digital free-form progressive lenses in either eyeglasses or sunglasses, starting at $#{prices.opticalAcetate}."}</p>
              <p>Progressive lenses offer a seamless transition from distance correction on top to reading correction on bottom. That means you can see your whole field of vision without switching between multiple pairs of glasses. (Life hack!)</p>
            </div>
            <div className="row about-header">
              <h2>
                About our progressives
              </h2>
            </div>
            <div className="row about-row">
              <div className="text-info-container">
                <div className="bullet-illustration lens-illo"><img srcSet="//i.warbycdn.com/v/c/assets/progressives/image/section-lens/0/94589566b7/81x81/c302.png"/>
                </div>
                <div className="text-info-paragraph">
                  <p>At Warby Parker, we use digital free‑form lenses, which are the most advanced in progressive technology.</p>
                </div>
              </div>
              <div className="text-info-container middle-text-info">
                <div className="bullet-illustration seg-height-illo"><img srcSet="//i.warbycdn.com/v/c/assets/progressives/image/section-segheight/0/c78a669a59/92x68/7984.png"/>
                </div>
                <div className="text-info-paragraph">
                  <p>We use predictive technology to determine segment height based on your individual prescription, as well as your desired frame shape and size.</p>
                </div>
              </div>
              <div className="text-info-container">
                <div className="bullet-illustration triangle-illo"><img srcSet="//i.warbycdn.com/v/c/assets/progressives/image/section-design/0/8ca780c9b2/77x92/91b4.png"/>
                </div>
                <div className="text-info-paragraph">
                  <p>Applied digitally, the design is more precise than that of conventional progressives models. Added bonus: the application also provides a larger field of vision for the wearer.</p>
                </div>
              </div>
              <br className="clear" />
            </div>
            <div className="row price-header">
              <h2>Pricing for progressives</h2>
            </div>
            <div className="row price-container">
              <table className="price-table">
                <tbody>
                  <tr>
                    <th colSpan="2" className="optical">
                      <div>Eyeglasses
                      </div>
                    </th>
                  </tr>
                  <tr>
                    <td className="left-price-box price-box acetate-optical-price-box">
                      <div>
                        <span className="material">Acetate</span><br />Starting at
                        <span className="price-dollars"> {"$#{prices.opticalAcetate}"}</span>
                      </div>
                    </td>
                    <td className="right-price-box price-box titanium-optical-price-box">
                      <div>
                        <span className="material">Titanium</span><br />Starting at
                        <span className="price-dollars"> {"$#{prices.opticalTitanium}"}</span>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div className="row price-container">
              <table className="price-table">
                <tbody>
                  <tr>
                    <th colSpan="2" className="optical">
                      <div>Sunglasses
                      </div>
                    </th>
                  </tr>
                  <tr>
                    <td className="left-price-box price-box acetate-sunwear-price-box">
                      <div><span className="material">Acetate</span><br />Starting at
                        <span className="price-dollars"> {"$#{prices.sunwearAcetate}"}</span>
                      </div>
                    </td>
                    <td className="right-price-box price-box titanium-sunwear-price-box">
                      <div><span className="material">Titanium</span><br />Starting at
                        <span className="price-dollars"> {"$#{prices.sunwearTitanium}"}</span>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div className="row shop-row">
              <h2>Shop</h2>
            </div>
            <div className="row shop-mens-row">
              <p><a onClick={@trackInteraction.bind @, "progressives-click-mensOptical"} href="/eyeglasses/men">Men’s Eyeglasses</a><span className="link-arrow"></span>
              </p>
              <p><a onClick={@trackInteraction.bind @, "progressives-click-mensSunwear"} href="/sunglasses/men">Men’s Sunglasses</a><span className="link-arrow"></span>
              </p>
            </div>
            <div className="row shop-womens-row">
              <p><a onClick={@trackInteraction.bind @, "progressives-click-womensOptical"} href="/eyeglasses/women">Women’s Eyeglasses</a><span className="link-arrow"></span>
              </p>
              <p><a onClick={@trackInteraction.bind @, "progressives-click-womensSunwear"} href="/sunglasses/women">Women’s Sunglasses</a><span className="link-arrow"></span>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
