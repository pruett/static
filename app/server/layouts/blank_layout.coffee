[
  _
  React

  BaseLayout
  GoogleTagManager
  TypekitAsync
  Mpulse
  NewRelic
  PreGtm
  PreReact
] = [
  require 'lodash'
  require 'react/addons'

  require 'hedeia/server/layouts/base_layout'
  require 'hedeia/server/layouts/includes/google_tag_manager'
  require 'hedeia/server/layouts/includes/typekit_async'
  require 'hedeia/server/layouts/includes/mpulse'
  require 'hedeia/server/layouts/includes/new_relic'
  require 'hedeia/server/layouts/includes/pre_gtm'
  require 'hedeia/server/layouts/includes/pre_react'
]

class BlankLayout extends BaseLayout
  name: -> 'blank'

  headStylesheets: -> [
    'utility'
  ]

  meta: ->
    metaTags = _.map(@metaTags, (tag) -> React.DOM.meta tag)
    title = @title()
    [
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
    if @isTagEnabled('new-relic') && Config.get('server.newrelic.browser_enabled')
      React.DOM.script
        key: 'new-relic'
        dangerouslySetInnerHTML:
          __html: NewRelic
    React.DOM.script
      key: 'no-js'
      dangerouslySetInnerHTML:
        __html: "
          window.__timing__start = new Date().getTime();
          document.documentElement.className = document.documentElement.className.replace('no-js', 'js');
          window.dataLayer = window.dataLayer || [];
          window.optimizely = window.optimizely || [];
          window.$ = window.jQuery = undefined;
        "
    if @isTagEnabled('mpulse') && Config.get('server.mpulse.enabled')
      React.DOM.script(
        dangerouslySetInnerHTML:
          __html: Mpulse Config.get('server.mpulse')
      )

    if @isTagEnabled('typekit')
      if @isTagEnabled('typekit-async')
        React.DOM.script(
          key: 'typekit'
          dangerouslySetInnerHTML:
            __html: TypekitAsync('rua4jeq')
        )
      else
        [
          React.DOM.script(
            key: 'typekit'
            type: 'text/javascript'
            src: '//fonts.warbycdn.com/rua4jeq.js'
          )
          React.DOM.script(
            key: 'typekit-load'
            type: 'text/javascript'
            dangerouslySetInnerHTML:
              __html: 'try{Typekit.load();}catch(e){}'
          )
        ]
  ]

  head: -> [
    React.DOM.link(
      key: 'dns-prefetch-image'
      href: '//i.warbycdn.com'
      rel: 'dns-prefetch'
    )
    React.DOM.link(
      key: 'dns-prefetch-fonts'
      href: '//fonts.warbycdn.com'
      rel: 'dns-prefetch'
    )
    React.DOM.link(
      key: 'apple-touch-icon'
      rel: 'apple-touch-icon'
      href: '/apple-touch-icon.png'
    )
  ].concat @canonicalLinks()

  canonicalLinks: ->
    location = _.get @appState, 'location'
    locale = _.get @appState, 'locale'

    if not location or location.error
      # No canonical hints on error pages.
      return []

    links = [
      React.DOM.link(
        key: 'canonical'
        rel: 'canonical'
        href: "//#{locale.host}#{location.pathname}"
      )
    ]

    _.each locale.alternates, (alternate) ->
      links.push React.DOM.link(
        key: "alternate-#{alternate.country}"
        rel: 'alternate'
        href: "//#{alternate.host}#{location.pathname}"
        hrefLang: alternate.lang
      )

    links

  asyncScripts: ->
    scripts = {}

    if @isTagEnabled('optimizely')
      scripts.optimizely =
        "//cdn.optimizely.com/js/#{Config.get 'server.optimizely.project_id'}.js"

    scripts

  afterBodyOpen: ->
    _.compact _.flatten [
      if Config.get('server.pre_react.enabled')
        React.DOM.script(
          key: 'prereact'
          dangerouslySetInnerHTML:
            __html: PreReact()
        )
      if Config.get('server.gtm.enabled') and @isTagEnabled('gtm')
        [
          React.DOM.script
            key: 'pregtm'
            dangerouslySetInnerHTML:
              __html: PreGtm(_.get @appState, 'location.href')
          React.DOM.div
            className: 'u-hide-all'
            key: 'google-tag-manager'
            dangerouslySetInnerHTML:
              __html: GoogleTagManager(Config.get 'server.gtm.container_id')
        ]
    ]

module.exports = BlankLayout
