[
  _
  React

  BaseLayout
] = [
  require 'lodash'
  require 'react/addons'

  require 'hedeia/server/layouts/base_layout'
]

class YearInReview2014Layout extends BaseLayout
  name: -> 'yearInReview2014'

  meta: ->
    metaTags = _.map(@metaTags, (tag) -> React.DOM.meta tag)
    title = @title()
    [

      React.DOM.meta(
        name: "description"
        content: "The 2014 Warby Parker Year in Review"
      )
      React.DOM.meta(
        property: "og:title"
        content: "The 2014 Warby Parker Year in Review"
      )
      React.DOM.meta(
        property: "og:type"
        content: "website"
      )
      React.DOM.meta(
        property: "og:image"
        content: "//i.warbycdn.com/v/c/assets/yir/image/fb-share/2/3cc7f8a830/1200x630/fe34.png"
      )
      React.DOM.meta(
        property: "og:url"
        content: "//www.warbyparker.com/year-in-review-2014"
      )
      React.DOM.meta(
        property: "og:description"
        content: "Explore a year's worth of excitement in the world of Warby Parker."
      )
      React.DOM.meta(
        property: "og:site_name"
        content: "Warby Parker"
      )

      React.DOM.meta(
        name: "twitter:card"
        content: "summary_large_image"
      )
      React.DOM.meta(
        name: "twitter:site"
        content: "@WarbyParker"
      )
      React.DOM.meta(
        name: "twitter:title"
        content: "The 2014 Warby Parker Year in Review"
      )
      React.DOM.meta(
        name: "twitter:description"
        content: "Explore a year's worth of excitement in the world of Warby Parker."
      )
      React.DOM.meta(
        name: "twitter:image:src"
        content: "//i.warbycdn.com/v/c/assets/yir/image/fb-share/2/3cc7f8a830/1200x630/fe34.png")
      React.DOM.meta(
        name: "viewport"
        content: "width:device-width, initial-scale:1"
      )
      React.DOM.meta(
        key: 'meta-charset'
        charSet: 'UTF-8'
      )
      React.DOM.meta(
        key: 'meta-viewport'
        name: 'viewport'
        content: 'width=device-width,initial-scale=1'
      )
      React.DOM.meta(
        key: 'meta-edge'
        httpEquiv: 'x-ua-compatible'
        content: 'ie=edge'
      )
      React.DOM.meta(
        key: 'meta-x-dns-prefetch-control'
        httpEquiv: 'x-dns-prefetch-control'
        content: 'on'
      )
      React.DOM.meta(
        key: 'meta-twitter-title'
        name: 'twitter:title'
        content: title
      )
      React.DOM.meta(
        key: 'meta-theme-color'
        name: 'theme-color'
        content: '#00a2e1'
      )
      React.DOM.meta(
        key: 'meta-og-title'
        property: 'og:title'
        content: title
      )
      unless Config.isProduction
        React.DOM.meta(
          key: 'meta-robots'
          name: 'robots'
          content: 'noindex'
        )
    ].concat metaTags

  headScripts: -> [
    React.DOM.link
        key: "stylesheet"
        rel: 'stylesheet'
        type: 'text/css'
        href: @assetPath '/assets/css/ar2014/', 'ar-2014-review-main', 'css'
  ]

  bodyAttrs: ->
    staticHostname = Config.get('server.config.static_hostname') or ''
    staticHostname = "//#{staticHostname}/assets/img/ar2014/" if staticHostname

    'data-static-url': staticHostname

  afterBodyOpen: -> [
    React.DOM.div(
      className: 'container yir-container-main'
      React.DOM.header({}
        React.DOM.a(
          'data-gtm-event': 'view-warby'
          href: '/'
          target: '_blank'
          React.DOM.img(
            width: '200'
            src: @assetPath '/assets/img/ar2014/', 'logo', 'png'
            alt: 'Warby Parker'
          )
        )
        React.DOM.h2(
          children: 'Year in Review 2014'
        )
      )

      React.DOM.div(
        className: 'row'
        React.DOM.div(
          className: 'yir-main col-xs-12'
        )
      )
    )

    React.DOM.hr(
      className: 'seperator-share'
    )

    React.DOM.div(
      className: 'container yir-container-share'
      React.DOM.div(
        className: 'row'
        React.DOM.div(
          className: 'yir-share col-xs-12'
        )
      )
    )

    React.DOM.hr(
      className: 'seperator-footer'
    )

    React.DOM.div(
      className: 'yir-wrapper-footer'
    )

  ]

  beforeBodyClose: -> [
    React.DOM.script
      key: 'vendor'
      src: @assetPath '/assets/js/ar2014/', 'ar-2014-review-vendor', 'js'
    React.DOM.script
      key: 'plugins'
      src: @assetPath '/assets/js/ar2014/', 'ar-2014-review-plugins', 'js'
    React.DOM.script
      key: 'main'
      src: @assetPath '/assets/js/ar2014/', 'ar-2014-review-main', 'js'
    React.DOM.script
      key: 'dataLayer'
      dangerouslySetInnerHTML: __html: "
        window.dataLayer = window.dataLayer || [];
        window.dataLayer.push({'gtm.start': new Date().getTime(), event: 'gtm.js'});"
    React.DOM.script
      key: 'gtm'
      aync: true
      src: '//www.googletagmanager.com/gtm.js?id=GTM-TJ5PJK'
    React.DOM.noscript
      key: 'noscript'
      React.DOM.iframe
        src: '//www.googletagmanager.com/ns.html?id=GTM-TJ5PJK'
        height: '0'
        width: '0'
        style:
          display: 'none'
          visibility: 'hidden'
  ]

module.exports = YearInReview2014Layout
