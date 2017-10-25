[
  _
  React

  BlankLayout
] = [
  require 'lodash'
  require 'react/addons'

  require './blank_layout'
]

class DefaultLayout extends BlankLayout
  name: -> 'default'

  blockingScripts: ->
    pageBundle = _.get @appState, 'location.bundleFile'
    super().concat _.compact([
      'bundles/bundle-vendor'
      'bundles/bundle-core-components'
      "bundles/#{pageBundle}" if pageBundle
      'bundles/bundle-main'
    ])

  headStylesheets: ->
    pageBundle = _.get @appState, 'location.bundleFile'

    super().concat _.compact([
      'bundles/bundle-core-components'
      "bundles/#{pageBundle}" if pageBundle
    ])

module.exports = DefaultLayout
