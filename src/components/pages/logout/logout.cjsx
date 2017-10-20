[
  _
  React

  LayoutDefault

  EmptyWithCta

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/molecules/empty_with_cta/empty_with_cta'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  statics:
    route: ->
      path: '/logout'
      handler: 'Default'
      bundle: 'session'
      title: 'Signed-out'

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'session'
  ]

  componentDidMount: ->
    @commandDispatcher 'session', 'logout'

  getStaticClasses: ->
    block:
      'u-df
      u-flexd--c
      u-ai--c
      u-jc--c
      u-mwn
      u-pa
      u-t0 u-r0 u-b0 u-l0
      u-m0
      u-color-bg--light-gray-alt-2'

  render: ->
    classes = @getClasses()
    session = @getStore('session')

    <LayoutDefault {...@props}>
      <div className=classes.block>
        {if session.__fetched and _.isEmpty(session.customer)
          <EmptyWithCta
            headline='You’re now signed-out'
            ctaChildren='Keep poking around'
            ctaLink='/'
            analyticsSlug='logout-click-cta' />}
      </div>
    </LayoutDefault>
