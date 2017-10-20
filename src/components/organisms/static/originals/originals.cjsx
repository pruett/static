[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './originals.scss'
]

module.exports = React.createClass
  mixins: [
    Mixins.context
  ]

  shouldComponentUpdate: ->
    false

  findParentNode: (child, parentName) ->
    parent = child.parentNode
    while not parent.classList.contains parentName
      parent = parent.parentNode

    parent

  onProductClick: (event) ->
    el = event.currentTarget
    container = @findParentNode el, 'product-container'
    container.classList.toggle 'expanded'

  onSwatchClick: (event) ->
    el = event.currentTarget
    container = @findParentNode el, 'product-container'

    # Get changing properties
    productId = el.getAttribute('data-ga-label')
    nextColor = el.getAttribute('title')
    currImg = container.querySelector(".product-img-container:not([data-product-id='#{productId}'])")
    nextImg = document.querySelector(".product-img-container[data-product-id='#{productId}']")

    # Set changing properties
    container.querySelector(".product-text[data-product-id='#{productId}'")
    container.querySelector('.product-color').innerHTML = nextColor
    input.removeAttribute('checked') for input in container.querySelectorAll('input')

    el.parentNode.querySelector('input').setAttribute 'checked', true
    label.classList.add('inactive') for label in container.querySelectorAll('.swatch-label')

    el.classList.remove('inactive')

    nextImg.classList.remove 'hidden'
    currImg.classList.add 'hidden'

  localeBasePrice: ->
    (parseInt(@getFeature('basePriceCents'), 10) / 100).toFixed()

  render: ->
    <div id="mobile-content" className='c-originals'>
      <div id="originals-page">
        <div className="banner content-hero">
          <img className="hero-img" src=
          "//i.warbycdn.com/v/c/assets/originals/image/originals-hero-books/4/242fbc4e69/3200x1630/dbd5.jpg" />
          <div className="banner-text">
            <h1>Warby Parker Original Series</h1>
            <h2>Our most classic styles start at ${@localeBasePrice()}, including prescription
            lenses. (And you can try them at home for free.)</h2>
          </div>
        </div>
        <div className="sub-banner">
          <p>Our Original Series features ten of our best-loved frames. These are
          the winners that our customers return to again and again: flattering
          shapes, classic lines, brilliant materials.<br />
          <br />
          <b>Meet your new number-one pair.</b></p>
          <hr />
        </div>
        <div className="product-list">
          <div className="product-container">
            <div className="product-img-container" data-product-id="0164_0256_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/percey-striped-sassafras-front/0/961f387753/1160x580/85e7.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-marine-slate-angle/0/4ed02995fc/1000x458/87ec.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0164_0256_OPK" data-product-gender="Men"
                  data-product-id="758" href=
                  "/eyeglasses/men/percey/striped-sassafras">Shop
                  Men</a><a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Women" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0164_0256_OPK" data-product-gender="Women"
                  data-product-id="423" href=
                  "/eyeglasses/women/percey/striped-sassafras">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0164_0133_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/percey-charcoal-fade-front/0/999b820d18/1160x580/0b4a.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-oak-barrel-angle/0/b03b23d265/995x480/bef0.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0164_0133_OPK" data-product-gender="Men"
                  data-product-id="141" href=
                  "/eyeglasses/men/percey/charcoal-fade">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0164_0133_OPK" data-product-gender="Women" data-product-id=
                  "983" href="/eyeglasses/women/percey/charcoal-fade">Shop
                  Women</a>
                </div>
              </div>
            </div>
            <div className="product-details">
              <div onClick=@onProductClick className="product-text" data-product-id="0164_0256_OPK">
                <div className="product-name">
                  Percey
                </div>
                <div className="product-color">
                  Striped Sassafras
                </div>
              </div>
              <div className="product-color-selector">
                <ul className="swatches">
                  <li>
                    <input defaultChecked=true className="swatch-input" id="product-0164_0256_OPK" name="product-0164_0256_OPK" type="radio" />
                    <div onClick=@onSwatchClick className="swatch-label js-ga-click"
                      style={{backgroundImage:"url(//i.warbycdn.com/-/f/color-striped-sassafras-0d16c1b6)"}}
                      data-ga-action="Click-Toggle-Color"
                      data-ga-category="Landing-Page-Originals"
                      data-ga-label="0164_0256_OPK"
                      title="Striped Sassafras"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0164_0133_OPK" name=
                    "product-0164_0133_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0164_0133_OPK" style={{backgroundImage: "url(//i.warbycdn.com/-/f/color-charcoal-fade-b1886011)"}}
                    title="Charcoal Fade"></div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <div className="product-container">
            <div className="product-img-container hidden" data-product-id=
            "0158_0150_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/bensen-greystone-front/0/fac5a47e56/1000x500/5bf9.jpeg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/bensen-greystone-angle/1/e0547e9de6/1160x580/14cb.jpg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0158_0150_OPK" data-product-gender="Men"
                  data-product-id="668" href=
                  "/eyeglasses/men/bensen/greystone">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0158_0150_OPK" data-product-gender="Women" data-product-id=
                  "914" href="/eyeglasses/women/bensen/greystone">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container" data-product-id="0158_0200_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/bensen-whiskey-tortoise-front/0/249afe6a80/1000x500/36b8.jpeg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/bensen-whiskey-tortoise-angle/1/2f4bd17c7d/1160x580/5169.jpg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0158_0200_OPK" data-product-gender="Men"
                  data-product-id="918" href=
                  "/eyeglasses/men/bensen/whiskey-tortoise">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0158_0200_OPK" data-product-gender="Women" data-product-id=
                  "682" href="/eyeglasses/women/bensen/whiskey-tortoise">Shop
                  Women</a>
                </div>
              </div>
            </div>
            <div className="product-details">
              <div onClick=@onProductClick className="product-text" data-product-id="0158_0150_OPK">
                <div className="product-name">
                  Bensen
                </div>
                <div className="product-color">
                  Whiskey Tortoise
                </div>
              </div>
              <div className="product-color-selector">
                <ul className="swatches">
                  <li>
                    <input  className="swatch-input" id="product-0158_0150_OPK" name=
                    "product-0158_0150_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label js-ga-click inactive"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0158_0150_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-greystone-756a9008)"}}
                    title="Greystone"></div>
                  </li>
                  <li>
                    <input defaultChecked=true className="swatch-input" id="product-0158_0200_OPK" name=
                    "product-0158_0200_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label js-ga-click" data-ga-action=
                    "Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0158_0200_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-whiskey-tortoise-44ffbb63)"}}
                    title="Whiskey Tortoise"></div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <div className="product-container">
            <div className="product-img-container" data-product-id="0270_0142_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/upton-sea-smoke-tortoise-front/0/f3daa26b88/1160x580/3dcf.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/bensen-greystone-angle/0/94326d9f79/782x400/7753.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Women" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0270_0142_OPK" data-product-gender="Women"
                  data-product-id="1126" href=
                  "/eyeglasses/women/upton/sea-smoke-tortoise">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0270_0225_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/upton-oak-barrel-front/0/d951761d1e/1160x580/5a98.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/bensen-whiskey-tortoise-angle/0/9102a9e257/789x400/f5d4.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0270_0225_OPK" data-product-gender="Women" data-product-id=
                  "1076" href="/eyeglasses/women/upton/oak-barrel">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-details">
              <div onClick=@onProductClick className="product-text" data-product-id="0270_0142_OPK">
                <div className="product-name">
                  Upton
                </div>
                <div className="product-color">
                  Sea Smoke Tortoise
                </div>
              </div>
              <div className="product-color-selector">
                <ul className="swatches">
                  <li>
                    <input defaultChecked=true className="swatch-input" id="product-0270_0142_OPK" name=
                    "product-0270_0142_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label js-ga-click" data-ga-action=
                    "Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0270_0142_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-sea-smoke-tortoise-3b4a6067)"}}
                    title="Sea Smoke Tortoise"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0270_0225_OPK" name=
                    "product-0270_0225_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0270_0225_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-oak-barrel-4609b64e)"}}
                    title="Oak Barrel"></div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <div className="banner content-hto">
          <img className="hero-img" srcSet=
          "//i.warbycdn.com/v/c/assets/originals/image/originals-hero-hto/2/488ca806a7/1830x2000/1954.jpg" />
          <div className="banner-text">
            <h2>Try them on for free</h2>
            <p>Try on glasses in the comfort of your own home—for free. Select
            “Add to Home Try-On” beneath five pairs that you like. We’ll mail you
            a box of frames to try on. Shipping is free both ways. (And no
            obligation to buy.)</p>
            <hr />
          </div>
        </div>
        <div className="product-grid">
          <div className="product-container">
            <div className="product-img-container" data-product-id="0203_0325_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/wilkie-eastern-bluebird-fade-front/0/abc9c0cdd6/1160x580/29bc.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-marine-slate-angle/0/4ed02995fc/1000x458/87ec.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0203_0325_OPK" data-product-gender="Men"
                  data-product-id="1402" href=
                  "/eyeglasses/men/wilkie/eastern-bluebird-fade">Shop
                  Men</a><a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Women" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0203_0325_OPK" data-product-gender="Women"
                  data-product-id="1401" href=
                  "/eyeglasses/women/wilkie/eastern-bluebird-fade">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0203_0150_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/wilkie-greystone-front/0/84db6d43b5/1160x580/c2f8.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-oak-barrel-angle/0/b03b23d265/995x480/bef0.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0203_0150_OPK" data-product-gender="Men"
                  data-product-id="776" href=
                  "/eyeglasses/men/wilkie/greystone">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0203_0150_OPK" data-product-gender="Women" data-product-id=
                  "394" href="/eyeglasses/women/wilkie/greystone">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0203_0200_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/wilkie-whiskey-tortoise-front/0/33149a404e/1160x580/8bd6.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/wilkie-whiskey-tortoise-front/0/33149a404e/1160x580/8bd6.jpg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0203_0200_OPK" data-product-gender="Men"
                  data-product-id="67" href=
                  "/eyeglasses/men/wilkie/whiskey-tortoise">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0203_0200_OPK" data-product-gender="Women" data-product-id=
                  "949" href="/eyeglasses/women/wilkie/whiskey-tortoise">Shop
                  Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0203_0280_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/wilkie-sugar-maple-front/0/7845e5f93a/1160x580/66c8.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-jet-black-matte-angle/0/18dadfdb3a/983x480/e648.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0203_0280_OPK" data-product-gender="Men"
                  data-product-id="674" href=
                  "/eyeglasses/men/wilkie/sugar-maple">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0203_0280_OPK" data-product-gender="Women" data-product-id=
                  "136" href="/eyeglasses/women/wilkie/sugar-maple">Shop
                  Women</a>
                </div>
              </div>
            </div>
            <div className="product-details">
              <div onClick=@onProductClick className="product-text" data-product-id="0203_0325_OPK">
                <div className="product-name">
                  Wilkie
                </div>
                <div className="product-color">
                  Eastern Bluebird Fade
                </div>
              </div>
              <div className="product-color-selector">
                <ul className="swatches">
                  <li>
                    <input defaultChecked=true className="swatch-input" id="product-0203_0325_OPK" name=
                    "product-0203_0325_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label js-ga-click" data-ga-action=
                    "Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0203_0325_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-eastern-bluebird-fade-0e3258c4)"}}
                    title="Eastern Bluebird Fade"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0203_0150_OPK" name=
                    "product-0203_0150_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0203_0150_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-greystone-756a9008)"}}
                    title="Greystone"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0203_0200_OPK" name=
                    "product-0203_0200_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0203_0200_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-whiskey-tortoise-44ffbb63)"}}
                    title="Whiskey Tortoise"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0203_0280_OPK" name=
                    "product-0203_0280_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0203_0280_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-sugar-maple-3ce5e1e6)"}}
                    title="Sugar Maple"></div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <div className="product-container">
            <div className="product-img-container" data-product-id="0138_0100_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/winston-jet-black-front/0/597f318642/1160x580/e89e.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/winston-jet-black-angle/0/4ad3dcccf0/1160x580/4fb8.jpg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0138_0100_OPK" data-product-gender="Men"
                  data-product-id="553" href=
                  "/eyeglasses/men/winston/jet-black">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0138_0100_OPK" data-product-gender="Women" data-product-id=
                  "944" href="/eyeglasses/women/winston/jet-black">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0138_0273_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/winston-old-fashioned-fade-front/0/ec39d8c81e/1160x580/8120.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/winston-old-fashioned-fade-angle/0/3f3fb51902/1160x580/e6de.jpg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0138_0273_OPK" data-product-gender="Men"
                  data-product-id="976" href=
                  "/eyeglasses/men/winston/old-fashioned-fade">Shop
                  Men</a><a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Women" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0138_0273_OPK" data-product-gender="Women"
                  data-product-id="481" href=
                  "/eyeglasses/women/winston/old-fashioned-fade">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-details">
              <div onClick=@onProductClick className="product-text" data-product-id="0138_0100_OPK">
                <div className="product-name">
                  Winston
                </div>
                <div className="product-color">
                  Jet Black
                </div>
              </div>
              <div className="product-color-selector">
                <ul className="swatches">
                  <li>
                    <input defaultChecked=true className="swatch-input" id="product-0138_0100_OPK" name=
                    "product-0138_0100_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label js-ga-click" data-ga-action=
                    "Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0138_0100_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-jet-black-3d0b43f1)"}}
                    title="Jet Black"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0138_0273_OPK" name=
                    "product-0138_0273_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0138_0273_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-old-fashioned-fade-4ca222c2)"}}
                    title="Old Fashioned Fade"></div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <div className="product-container">
            <div className="product-img-container" data-product-id="0166_0256_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/sims-striped-sassafras-front/0/68ff20da4f/1160x580/68ae.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/sims-striped-sassafras-front/0/68ff20da4f/1160x580/68ae.jpg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0166_0256_OPK" data-product-gender="Men"
                  data-product-id="2009" href=
                  "/eyeglasses/men/sims/striped-sassafras">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0166_0256_OPK" data-product-gender="Women" data-product-id=
                  "179" href="/eyeglasses/women/sims/striped-sassafras">Shop
                  Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0166_0252_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/sims-violet-magnolia-front/0/23dccbc853/1160x580/0a4f.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-jet-black-matte-angle/0/18dadfdb3a/983x480/e648.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0166_0252_OPK" data-product-gender="Men"
                  data-product-id="2010" href=
                  "/eyeglasses/men/sims/violet-magnolia">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0166_0252_OPK" data-product-gender="Women" data-product-id=
                  "718" href="/eyeglasses/women/sims/violet-magnolia">Shop
                  Women</a>
                </div>
              </div>
            </div>
            <div className="product-details">
              <div onClick=@onProductClick className="product-text" data-product-id="0166_0256_OPK">
                <div className="product-name">
                  Sims
                </div>
                <div className="product-color">
                  Striped Sassafras
                </div>
              </div>
              <div className="product-color-selector">
                <ul className="swatches">
                  <li>
                    <input defaultChecked=true className="swatch-input" id="product-0166_0256_OPK" name=
                    "product-0166_0256_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label js-ga-click" data-ga-action=
                    "Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0166_0256_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-striped-sassafras-0d16c1b6)"}}
                    title="Striped Sassafras"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0166_0252_OPK" name=
                    "product-0166_0252_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0166_0252_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-violet-magnolia-f745a1f0)"}}
                    title="Violet Magnolia"></div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <div className="product-container">
            <div className="product-img-container" data-product-id="0102_0203_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/fillmore-tennesee-whiskey-front/0/fd43420553/1160x580/c594.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/fillmore-tennesee-whiskey-angle/0/deff379dc4/1160x580/1172.jpg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0102_0203_OPK" data-product-gender="Men"
                  data-product-id="410" href=
                  "/eyeglasses/men/fillmore/tennessee-whiskey">Shop
                  Men</a><a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Women" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0102_0203_OPK" data-product-gender="Women"
                  data-product-id="524" href=
                  "/eyeglasses/women/fillmore/tennessee-whiskey">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0102_0920_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/fillmore-redwood-ash-front/0/464a8c01b9/1160x580/8e9f.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/fillmore-redwood-ash-angle/0/2ca3432847/1160x580/345f.jpg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0102_0920_OPK" data-product-gender="Men"
                  data-product-id="261" href=
                  "/eyeglasses/men/fillmore/redwood-ash">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0102_0920_OPK" data-product-gender="Women" data-product-id=
                  "366" href="/eyeglasses/women/fillmore/redwood-ash">Shop
                  Women</a>
                </div>
              </div>
            </div>
            <div className="product-details">
              <div onClick=@onProductClick className="product-text" data-product-id="0102_0203_OPK">
                <div className="product-name">
                  Fillmore
                </div>
                <div className="product-color">
                  Tennessee Whiskey
                </div>
              </div>
              <div className="product-color-selector">
                <ul className="swatches">
                  <li>
                    <input defaultChecked=true className="swatch-input" id="product-0102_0203_OPK" name=
                    "product-0102_0203_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label js-ga-click" data-ga-action=
                    "Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0102_0203_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-tennessee-whiskey-2b13e832)"}}
                    title="Tennessee Whiskey"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0102_0920_OPK" name=
                    "product-0102_0920_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0102_0920_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-redwood-ash-a21c39f6)"}}
                    title="Redwood Ash"></div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <div className="banner content-style">
          <img className="hero-img" srcSet=
          "//i.warbycdn.com/v/c/assets/originals/image/orignals-hero-acetate/3/3c8961dadf/1840x1940/8e86.jpg" />
          <div className="banner-text">
            <h2>Style</h2>
            <p>Each Warby Parker Original is crafted from single-sheet cellulose
            acetate sourced from a family-run Italian factory. Frames are
            hand-polished for three days and polished with a German wax compound
            before making their way to your eyes.</p>
            <hr />
          </div>
        </div>
        <div className="product-list">
          <div className="product-container">
            <div className="product-img-container" data-product-id="0133_0101_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/beckett-jet-black-front/0/444cee409e/1160x580/cc47.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/bensen-whiskey-tortoise-angle/0/9102a9e257/789x400/f5d4.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0133_0101_OPK" data-product-gender="Men"
                  data-product-id="277" href=
                  "/eyeglasses/men/beckett/jet-black-matte">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0133_0101_OPK" data-product-gender="Women" data-product-id=
                  "826" href="/eyeglasses/women/beckett/jet-black-matte">Shop
                  Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0133_0230_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/beckett-striped-chestnut-front/0/57d2fdd85c/1160x580/34c2.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/bensen-olivewood-angle/1/a12fe0657a/1000x460/d471.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0133_0230_OPK" data-product-gender="Men"
                  data-product-id="478" href=
                  "/eyeglasses/men/beckett/striped-chestnut">Shop
                  Men</a><a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Women" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0133_0230_OPK" data-product-gender="Women"
                  data-product-id="658" href=
                  "/eyeglasses/women/beckett/striped-chestnut">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-details">
              <div onClick=@onProductClick className="product-text" data-product-id="0133_0101_OPK">
                <div className="product-name">
                  Beckett
                </div>
                <div className="product-color">
                  Jet Black Matte
                </div>
              </div>
              <div className="product-color-selector">
                <ul className="swatches">
                  <li>
                    <input defaultChecked=true className="swatch-input" id="product-0133_0101_OPK" name=
                    "product-0133_0101_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label js-ga-click" data-ga-action=
                    "Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0133_0101_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-jet-black-matte-bc3c093b)"}}
                    title="Jet Black Matte"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0133_0230_OPK" name=
                    "product-0133_0230_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0133_0230_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-striped-chestnut-0fbdba33)"}}
                    title="Striped Chestnut"></div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <div className="product-container">
            <div className="product-img-container" data-product-id="0186_0340_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-marine-slate-front/0/c11bc0e081/1000x500/7ef8.jpeg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-marine-slate-angle/1/9891e77150/1160x580/0e0f.jpg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0186_0340_OPK" data-product-gender="Men"
                  data-product-id="941" href=
                  "/eyeglasses/men/duckworth/marine-slate">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0186_0340_OPK" data-product-gender="Women" data-product-id=
                  "985" href="/eyeglasses/women/duckworth/marine-slate">Shop
                  Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0186_0225_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-oak-barrel-front/0/08d4593266/1000x500/29b6.jpeg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-oak-barrel-angle/2/962e122371/1160x580/c998.jpg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0186_0225_OPK" data-product-gender="Men"
                  data-product-id="852" href=
                  "/eyeglasses/men/duckworth/oak-barrel">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0186_0225_OPK" data-product-gender="Women" data-product-id=
                  "612" href="/eyeglasses/women/duckworth/oak-barrel">Shop
                  Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0186_0101_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-jet-black-matte-front/0/19b0861d6c/1000x500/ce83.jpeg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-jet-black-matte-angle/1/00c5f77f97/1160x580/eaa4.jpg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0186_0101_OPK" data-product-gender="Men"
                  data-product-id="868" href=
                  "/eyeglasses/men/duckworth/jet-black-matte">Shop
                  Men</a><a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Women" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0186_0101_OPK" data-product-gender="Women"
                  data-product-id="328" href=
                  "/eyeglasses/women/duckworth/jet-black-matte">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-details">
              <div onClick=@onProductClick className="product-text" data-product-id="0186_0340_OPK">
                <div className="product-name">
                  Duckworth
                </div>
                <div className="product-color">
                  Marine Slate
                </div>
              </div>
              <div className="product-color-selector">
                <ul className="swatches">
                  <li>
                    <input defaultChecked=true className="swatch-input" id="product-0186_0340_OPK" name=
                    "product-0186_0340_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label js-ga-click" data-ga-action=
                    "Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0186_0340_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-marine-slate-b5c99f81)"}}
                    title="Marine Slate"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0186_0225_OPK" name=
                    "product-0186_0225_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0186_0225_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-oak-barrel-4609b64e)"}}
                    title="Oak Barrel"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0186_0101_OPK" name=
                    "product-0186_0101_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0186_0101_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-jet-black-matte-bc3c093b)"}}
                    title="Jet Black Matte"></div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <div className="product-container">
            <div className="product-img-container" data-product-id="0232_0500_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/nash-crystal-front/0/24f8acb3c0/1160x580/f604.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-marine-slate-angle/0/4ed02995fc/1000x458/87ec.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0232_0500_OPK" data-product-gender="Men"
                  data-product-id="1276" href="/eyeglasses/men/nash/crystal">Shop
                  Men</a><a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Women" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0232_0500_OPK" data-product-gender="Women"
                  data-product-id="1275" href=
                  "/eyeglasses/women/nash/crystal">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0232_0150_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/nash-greystone-front/0/04058f5964/1160x580/cba1.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-oak-barrel-angle/0/b03b23d265/995x480/bef0.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0232_0150_OPK" data-product-gender="Men"
                  data-product-id="600" href=
                  "/eyeglasses/men/nash/greystone">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0232_0150_OPK" data-product-gender="Women" data-product-id=
                  "46" href="/eyeglasses/women/nash/greystone">Shop Women</a>
                </div>
              </div>
            </div>
            <div className="product-img-container hidden" data-product-id=
            "0232_0200_OPK">
              <img onClick=@onProductClick className="product-img front" srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/nash-whiskey-tortoise-front/0/54bd17c87f/1160x580/f845.jpg" /><img onClick=@onProductClick className="product-img angled"
              srcSet=
              "//i.warbycdn.com/v/c/assets/originals/image/duckworth-jet-black-matte-angle/0/18dadfdb3a/983x480/e648.jpeg" />
              <div className="buttons">
                <div className="product-links">
                  <a className="product-button js-ga-click" data-ga-action=
                  "Click-Shop-Men" data-ga-category="Landing-Page-Originals"
                  data-ga-label="0232_0200_OPK" data-product-gender="Men"
                  data-product-id="134" href=
                  "/eyeglasses/men/nash/whiskey-tortoise">Shop Men</a><a className=
                  "product-button js-ga-click" data-ga-action="Click-Shop-Women"
                  data-ga-category="Landing-Page-Originals" data-ga-label=
                  "0232_0200_OPK" data-product-gender="Women" data-product-id=
                  "530" href="/eyeglasses/women/nash/whiskey-tortoise">Shop
                  Women</a>
                </div>
              </div>
            </div>
            <div className="product-details">
              <div onClick=@onProductClick className="product-text" data-product-id="0232_0500_OPK">
                <div className="product-name">
                  Nash
                </div>
                <div className="product-color">
                  Crystal
                </div>
              </div>
              <div className="product-color-selector">
                <ul className="swatches">
                  <li>
                    <input defaultChecked=true className="swatch-input" id="product-0232_0500_OPK" name=
                    "product-0232_0500_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label js-ga-click" data-ga-action=
                    "Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0232_0500_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/basic-color-crystal-0ac9121e)"}}
                    title="Crystal"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0232_0150_OPK" name=
                    "product-0232_0150_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0232_0150_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-greystone-756a9008)"}}
                    title="Greystone"></div>
                  </li>
                  <li>
                    <input className="swatch-input" id="product-0232_0200_OPK" name=
                    "product-0232_0200_OPK" type="radio"/>
                    <div onClick=@onSwatchClick className="swatch-label inactive js-ga-click"
                    data-ga-action="Click-Toggle-Color" data-ga-category=
                    "Landing-Page-Originals" data-ga-label="0232_0200_OPK" style={{
                    backgroundImage: "url(//i.warbycdn.com/-/f/color-whiskey-tortoise-44ffbb63)"}}
                    title="Whiskey Tortoise"></div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <div className="banner content-substance">
          <img className="hero-img" srcSet=
          "//i.warbycdn.com/v/c/assets/originals/image/originals-hero-photos/2/a5c547534e/1600x1348/003e.jpg" />
          <div className="banner-text">
            <h2>Substance</h2>
            <p>For every pair of glasses sold, a pair is distributed to someone
            in need.</p>
            <hr />
            <a className="js-ga-click" data-ga-action="Click-Section-Substance"
            data-ga-category="Landing-Page-Originals" data-ga-label="Text" href=
            "/buy-a-pair-give-a-pair">Find out more</a>
          </div>
        </div>
      </div>
    </div>

