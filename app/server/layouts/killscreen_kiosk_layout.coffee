[
  _
  React

  BaseLayout
] = [
  require 'lodash'
  require 'react/addons'

  require 'hedeia/server/layouts/base_layout'
]

class KillScreenKioskLayout extends BaseLayout
  name: -> 'KillScreenKiosk'

  bodyAttrs: ->
    style: {margin: 0}

  meta: ->
    metaTags = _.map(@metaTags, (tag) -> React.DOM.meta tag)
    title = @title()
    [
      React.DOM.meta(
        name: "description"
        content: "Warby Parker x KillScreen"
      )
      React.DOM.meta(
        key: 'meta-charset'
        charSet: 'UTF-8'
      )
      React.DOM.meta(
        name: 'apple-mobile-web-app-capable'
        content: 'yes'
      )
      React.DOM.meta(
        name: 'apple-mobile-web-app-status-bar-style'
        content: 'black-translucent'
      )
      React.DOM.meta(
        key: 'meta-viewport'
        name: 'viewport'
        content: 'width=device-width,initial-scale=1'
      )
      unless Config.isProduction
        React.DOM.meta(
          key: 'meta-robots'
          name: 'robots'
          content: 'noindex'
        )
    ].concat metaTags

  headScripts: ->
    [
      React.DOM.script
        key: 'phaser'
        src: @assetPath '/assets/killscreen/', 'phaser.min', 'js'
    ]

  beforeBodyClose: ->
    [
      React.DOM.script
        key: 'game'
        src: @assetPath '/assets/killscreen/', 'game.kiosk', 'js'
    ]


  afterBodyOpen: ->
    [
      React.DOM.div
        id: 'killscreen-game'
    ]

  bodyAttrs: ->
    style:
      backgroundColor: 'black'
      margin: 0
      pading: 0


module.exports = KillScreenKioskLayout
