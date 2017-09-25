[
  _
  React

  UnsupportedBrowserNotice

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/unsupported_browser_notice/unsupported_browser_notice'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  mixins: [
    Mixins.context
  ]

  propTypes:
    isAlt: React.PropTypes.bool
    appState: React.PropTypes.object

  getDefaultProps: ->
    isAlt: false
    appState: {}

  render: ->
    <div className='u-template'>
      <UnsupportedBrowserNotice />

      <main {...@props}
        role='main'
        children=@props.children
        className={[
          'u-template__main'
          '-main-alt' if @props.isAlt
        ].join ' '} />
    </div>
